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