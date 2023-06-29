output "ecs_role_arn" {
  description = "The ARN of the IAM role for ECS tasks"
  value       = aws_iam_role.ecs_role.arn
}
output "parameters_key_value_pairs" {
  value = {for secret in data.aws_ssm_parameter.secrets : secret.name => secret.value}
}