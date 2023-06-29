terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
      }
    }
    required_version = ">=1.2.0"
}
provider "aws" {
  region = "ap-southeast-2"
}

module vpc_subnets {
    source            = "./modules/VPC_SUBNETS"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_name = var.vpc_name
    public_subnet_cidr_block = var.public_subnet_cidr_block
    private_subnet_cidr_block = var.private_subnet_cidr_block
    public_subnet_name = var.public_subnet_name
    private_subnet_name = var.private_subnet_name
}
module eip_nat_igw_rt {
    source            = "./modules/EIP_NAT_IGW_RT"
    vpc_id = module.vpc_subnets.vpc.id
    public_subnet_ids = module.vpc_subnets.public_subnet_ids
    gateway_id = module.eip_nat_igw_rt.gateway_id
    private_subnet_ids = module.vpc_subnets.private_subnet_ids
    igw_name = var.igw_name
}
module ecr {
    source            = "./modules/ECR"
    ecreponame = var.ecreponame
    environment = var.environment
    project = var.project
}
module "security_group" {
    source            = "./modules/Security_Group"
    vpc_id         = module.vpc_subnets.vpc.id
    container_port = var.container_port
}
module "alb_acm_route53" {
    source            = "./modules/ALB_ACM_Route53"
    aws_security_group_alb = module.security_group.security_group_alb_id
    public_subnet_ids = module.vpc_subnets.public_subnet_ids
    vpc_id         = module.vpc_subnets.vpc.id
    domain = var.domain
    sub_domain = var.sub_domain
    health_check_path = var.health_check_path
    }
module "ecs_iam_ssm" {
    source            = "./modules/ECS_IAM_SSM"
    parameters = var.parameters
    task_definition_name = var.task_definition_name
    image_ecr_url = module.ecr.ecr_repository
    cpu = var.cpu
    memory = var.memory
    service_name = var.service_name
    container_port = var.container_port
    desired_service_number = var.desired_service_number
    target_group_arn = module.alb_acm_route53.target_group_arn
    container_name = var.container_name
    private_subnet_ids = module.vpc_subnets.private_subnet_ids
    alb_security_group = module.security_group.security_group_alb_id
    ecs_role_name = var.ecs_role_name

}
