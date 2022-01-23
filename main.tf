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

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "web-sg"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks # with load balancer
  # ingress_cidr_blocks = ["0.0.0.0/0"] # without load balancer
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "random_pet" "app" {
  length    = 2
  separator = "-"
}

