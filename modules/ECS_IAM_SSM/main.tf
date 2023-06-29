locals {
   container_definition_env_vars_list = [for k, v in var.parameters_key_value_pairs : {name=k, value=v}]
}
//create IAM role for ECS service
resource "aws_iam_role" "ecs_role" {
  name               = var.ecs_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
//create parameter store
resource "aws_ssm_parameter" "secrets" {
  for_each = var.parameters
  name        = each.key
  key_id      = "alias/aws/ssm"
  type        = "SecureString"
  value       = each.value

}

#Get variable values from parameters store for task definition's environment variables

data "aws_ssm_parameter" "secrets" {
  for_each = var.parameters
	name = each.key
	with_decryption = false

  depends_on = [ aws_ssm_parameter.secrets ]
}

//create ECS cluster-container insight + logging
resource "aws_kms_key" "example" {
  description             = "example"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

resource "aws_ecs_cluster" "test" {
  name = "example"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.example.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.example.name
      }
    }
  }
} 
//create task denifition
resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  container_definitions = jsonencode([
    {
      name      = var.task_definition_name
      image     = var.image_ecr_url
      environment = local.container_definition_env_vars_list
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn            = aws_iam_role.ecs_role.arn
}
// create service
resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.test.id
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = var.desired_service_number
  iam_role        = aws_iam_role.ecs_role.arn
  //This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g., myimage:latest
  //force_new_deployment = true
  health_check_grace_period_seconds = "30"
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-2a, ap-southeast-2b]"
  }
  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [var.alb_security_group]
  }
}
//auto-scaling for ECS service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.test.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}