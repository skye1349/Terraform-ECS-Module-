output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_ecs_tasks_id" {
  value = aws_security_group.ecs_tasks.id
}