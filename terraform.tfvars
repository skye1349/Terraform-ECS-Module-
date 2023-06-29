vpc_cidr_block = "10.0.0.0/16"
vpc_name = "main"
public_subnet_cidr_block = [ "10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
public_subnet_name = ["public_subnet_1", "public_subnet_2"]
private_subnet_name = ["private_subnet_1", "private_subnet_2"]
######################EIP_NAT_IGW_RT
igw_name = "igw"
######################ECR
ecreponame = "reponame"
environment = "uat"
project = "project-name"
######################SG
container_port = "8080"
##################ALB_ACM
health_check_path = "/api/v1"
domain = "mysteriousclubs.com"
sub_domain = ["www.mysteriousclubs.com", "*.mysteriousclubs.com"]

###################Variable values for ECS_IAM_SSM
parameters = {
  "CONNECTION_STRING" = "value1",
  "REGION"            = "s",
  "BUCKET_NAME"       = "1",
  "ACCESS_KEY_ID"     = "s",
  "SECRET_ACCESS_KEY" = "a",
}
ecs_role_name = "ecs_role_name"
task_definition_name = "task_definition_name"
cpu ="1024"
memory = "2048"
service_name = "service_name"
desired_service_number = "2"
container_name = "container_name"

