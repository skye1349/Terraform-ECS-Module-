variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}
variable "aws_security_group_alb" {
    description = "Security Group for the ALB"
    type        = string
}
variable "vpc_id" {

}
variable "health_check_path" {
}
variable "domain" {
}
variable "sub_domain" {
  type = list(string)
}