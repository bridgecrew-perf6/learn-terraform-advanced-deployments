
variable "ecr-repo-name" {
  default = "advanced-ecr-repo"
}

resource "aws_ecr_repository" "advanced-ecr-repo" {
  name = var.ecr-repo-name # "advanced-ecr-repo"

  provisioner "local-exec" {
    # command = "echo ${self.private_ip} >> private_ips.txt"
    command = "docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/${var.ecr-repo-name}:latest"
  }
}
