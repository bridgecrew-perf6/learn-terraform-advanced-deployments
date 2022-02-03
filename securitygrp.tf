# terraform import aws_security_group.sec-sonarqube-db sg-030a581be90f93e56
# this security group is labeled by former2 as: resource "aws_security_group" "EC2SecurityGroup4" 
# formerly "${aws_security_group.sec-sonarqube-db.id}"
resource "aws_security_group" "sec-sonarqube-db-2022-sg" {
  description = "Created by Terraform"
  name        = "sonarqube-db-sg"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "pgSQL-sq-2022"
  }
}

# terraform import aws_security_group.sonar-efs-nfs-sg sg-014416cc7dc730988
# former2 naming: resource "aws_security_group" "EC2SecurityGroup" {
# this security group does not seem to be referenced by any other AWS resource; remove it?
# 
# resource "aws_security_group" "sonar-efs-nfs-sg" {
#   description = "devops sonarqube EFSSecurityGroup"
#   vpc_id      = aws_vpc.devsecops-vpc.id
#   tags = {
#     Name = "EFS SonarQube DevOps"
#   }
# }

# resource "aws_security_group" "sonarqube-alb-external-sg" {
#   description            = "Security Group used for SonarQube Load Balancer"
#   revoke_rules_on_delete = false
#   egress {
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#     description = ""
#     from_port   = 0
#     protocol    = "-1"
#     self        = false
#     to_port     = 0
#   }
#   ingress {
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#     description      = ""
#     from_port        = 443
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 443
#   }

#   ingress {
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#     description      = ""
#     from_port        = 80
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 80
#   }
#   ingress {
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#     description      = ""
#     from_port        = 9000
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 9000
#   }

#   tags = {
#     "Name"        = "SonarQube-ALB-External"
#     "Application" = "SonarQube"
#     "Project"     = "DevOps"
#   }
# }

# output "sonarqube-alb-external-sg-id" {
#   value = aws_security_group.sonarqube-alb-external-sg.id
# }


# # terraform import aws_security_group.sonarqube-ec2 sg-09a7a1fa5b0c87f1d
# resource "aws_security_group" "sonarqube-ec2" {
#   description            = "ec2 instance for SonarQube"
#   revoke_rules_on_delete = true
#   ingress {
#     description = "John Kraus IP"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     # cidr_blocks = ["0.0.0.0/0"]
#     cidr_blocks = [var.my_ip_address]
#   }
#   ingress {
#     cidr_blocks = [
#       # "10.2.0.0/16"
#       aws_vpc.devsecops-vpc.cidr_block
#     ]
#     description = "devops vpc"
#     from_port   = 0
#     protocol    = "tcp"

#     to_port = 65535
#   }

#   ingress {
#     cidr_blocks = [
#       "136.28.81.226/32"
#     ]
#     description = "Felix IP"
#     from_port   = 9000

#     protocol = "tcp"

#     self    = false
#     to_port = 9000
#   }
#   ingress {
#     cidr_blocks = [
#       var.my_ip_address
#       # "173.73.91.11/32"
#     ]
#     description = "John Kraus IP"
#     from_port   = 9000
#     protocol    = "tcp"

#     self    = false
#     to_port = 9000
#   }
#   ingress {
#     cidr_blocks = [
#       "74.96.239.33/32"
#     ]
#     description = "Nicolas Westin"
#     from_port   = 9000

#     protocol = "tcp"

#     self    = false
#     to_port = 9000
#   }
#   ingress {

#     description = "EFS Volumes"
#     from_port   = 2049

#     protocol = "tcp"
#     security_groups = [
#       aws_security_group.sonar-efs-nfs-sg.id
#       # "sg-014416cc7dc730988",
#     ]
#     self    = false
#     to_port = 2049
#   }

#   ingress {
#     description = "SonarQube Load Balancer"
#     from_port   = 0
#     protocol    = "-1"
#     security_groups = [
#       aws_security_group.sonarqube-alb-external-sg.id,
#       #  "sg-0f0bb6b6cf9b586a8",
#     ]
#     self    = false
#     to_port = 0
#   }

# }