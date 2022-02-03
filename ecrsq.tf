
variable "ecr-sq-repo-name" {
  # sonarqube January 2022
  default = "sonarqube-2201"
}

resource "aws_ecr_repository" "sonarqube" {
  name                 = var.ecr-sq-repo-name
  image_tag_mutability = "IMMUTABLE"

  provisioner "local-exec" {

    command = "aws ecr get-login-password --region ${var.region} --profile ${var.aws_profile} | docker login --username AWS --password-stdin 506504484053.dkr.ecr.us-east-1.amazonaws.com"
  }
  provisioner "local-exec" {
    command = "docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/${var.ecr-sq-repo-name}:8.9.6-developer"
  }
}
