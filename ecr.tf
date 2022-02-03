
variable "ecr-repo-name" {
  default = "advanced-ecr-repo"
}

resource "aws_ecr_repository" "advanced-ecr-repo" {
  name                 = var.ecr-repo-name # "advanced-ecr-repo"
  image_tag_mutability = "IMMUTABLE"

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} --profile ${var.aws_profile} | docker login --username AWS --password-stdin 506504484053.dkr.ecr.us-east-1.amazonaws.com"
  }

  provisioner "local-exec" {
    command = "docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/${var.ecr-repo-name}:latest"
  }
}
