variable "ecs_role_name" {

}
variable "parameters" {
  description = "Map of parameter names and their values"
  type        = map(string)
  default     = {}
}
variable "task_definition_name" {
  description = "name of task definition name"

}
variable "image_ecr_url"{
  description = "image url in aws ecr"
}
variable "cpu" {}
variable "memory" {}

variable "service_name" {}
variable "desired_service_number" {}
variable "target_group_arn" {}
variable "container_name" {}
variable "container_port" {}
variable "private_subnet_ids" {}
variable "alb_security_group" {}
variable "parameters_key_value_pairs" {
  type = map(string)
  default = {}
}
