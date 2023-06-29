output "ecr_repository" {
  description = "ECR repository details"
  value = {
    name    = aws_ecr_repository.ecrepo.name
    arn     = aws_ecr_repository.ecrepo.arn
    url     = aws_ecr_repository.ecrepo.repository_url
    policy  = aws_ecr_lifecycle_policy.foopolicy.policy
  }
}
