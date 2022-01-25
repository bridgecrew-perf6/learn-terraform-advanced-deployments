provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Owner      = "John Kraus"
      Project    = "Learn Terraform Advanced Deployments tutorial"
      DevRootDir = "learn-terraform-advanced-deployments"
    }
  }

}

# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

resource "random_pet" "app" {
  length    = 2
  separator = "-"
}

