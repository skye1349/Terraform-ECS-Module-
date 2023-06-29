variable vpc_cidr_block {
    description = "The cidr_block of the VPC"
}
variable vpc_name {
    description = "The name of VPC"
}
variable public_subnet_cidr_block {
    type = list(string)
}
variable private_subnet_cidr_block {
    type = list(string)
}
variable public_subnet_name {
    type = list(string)
}
variable private_subnet_name {
    type = list(string)
}
######################EIP_NAT_IGW_RT
variable igw_name {
    description = "Name of IGW"
}

######################ECR
variable "ecreponame" {
  description = "The name of the ECR Repo"
}
variable "environment" {
  description = "The environment of project"
}
variable "project" {
  description = "The name of the project"
}
######################SG
variable "container_port" {
  description = "Ingress and egress port of the container"
}

######################ALB_ACM_Route53

variable "health_check_path" {
}
variable "domain" {
}
variable "sub_domain" {
  type = list(string)
}

######################ECS_IAM_SSM
variable "parameters" {
  description = "Map of parameter names and their values"
  type        = map(string)
  default     = {}
}
variable "ecs_role_name" {
}
variable "task_definition_name" {
}
variable "cpu" {
}
variable "memory" {
}
variable "service_name" {
}
variable "desired_service_number" {
}
variable "container_name" {
}


