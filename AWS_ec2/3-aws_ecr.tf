#######################################################################################
# Create ECR -- Repository
#######################################################################################

resource "aws_ecr_repository" "docker" {
  name = "docker"
  image_scanning_configuration {
    scan_on_push = false
  }
}

#######################################################################################
# Create ECR -- Repository -- policy
#######################################################################################

resource "aws_ecr_repository_policy" "pythonpolicy" {
  repository = aws_ecr_repository.docker.name
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:BuildImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}