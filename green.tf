locals {
  green_app_version = "1.1"
}

resource "aws_instance" "green" {
  count = var.enable_green_env ? var.green_instance_count : 0

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  # path.module here = "."; details: https://www.terraform.io/language/expressions/references  
  user_data = templatefile("${path.module}/init-script.sh", {
    file_content = "Green version ${local.green_app_version} - #${count.index}"
  })

  tags = {
    #Name = "green-${count.index}"
    Name = "green-version-${local.green_app_version}-${count.index}"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "green-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "green" {
  count            = length(aws_instance.green)
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = aws_instance.green[count.index].id
  port             = 80
}

