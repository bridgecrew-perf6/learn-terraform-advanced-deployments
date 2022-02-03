# module "lb_security_group" {
#   source  = "terraform-aws-modules/security-group/aws//modules/web"
#   version = "3.17.0"

#   name        = "lb-sg"
#   description = "Security group for load balancer with HTTP ports open within VPC"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
# }

resource "aws_security_group" "load_balancer_security_group" {
  # description = "Allow traffic into load balancer"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80 # Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
  tags = {
    Name = "load-balancer-security-group"
  }
}


# output "lb_security_group" {
#   value = module.lb_security_group
# }

# app security group
resource "aws_security_group" "service_security_group" {
  vpc_id = module.vpc.vpc_id
  # description = "Allow traffic from the load balancer to the app"
  ingress {
    description = "Allow all traffic from the load balancer"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
    # TO DO == FIX THIS security_groups  = [module.lb_security_group.this_security_group_id]
    # cidr_blocks = ["0.0.0.0/0"] # Allowing traffic from all IP addresses, temp
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
  tags = {
    Name = "service-security-group"
  }
}

# output "service_security_group" {
#   value = aws_security_group.service_security_group
# }

# module "app_security_group" {
#   source  = "terraform-aws-modules/security-group/aws//modules/web"
#   version = "3.17.0"

#   name        = "web-sg"
#   description = "Security group for web-servers with HTTP ports open within VPC"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks # with load balancer
#   # ingress_cidr_blocks = ["0.0.0.0/0"] # without load balancer
# }

# output  "app_security_group" {
#   value = module.app_security_group
# }
