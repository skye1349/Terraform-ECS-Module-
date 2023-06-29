resource "aws_ecr_repository" "ecrepo" {
  name                 = var.ecreponame
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = var.environment
    Project = var.project
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_lifecycle_policy" "foopolicy" {
  repository = aws_ecr_repository.ecrepo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}