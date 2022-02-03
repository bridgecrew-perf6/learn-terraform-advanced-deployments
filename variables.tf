variable "region" {
  description = "The region Terraform deploys your instances"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
}

variable "sq_db_master_password" {


}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.243.0.0/16"
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC."
  type        = bool
  default     = false
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.243.1.0/24",
    "10.243.2.0/24",
    "10.243.3.0/24",
    "10.243.4.0/24",
    "10.243.5.0/24",
    "10.243.6.0/24",
    "10.243.7.0/24",
    "10.243.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.243.101.0/24",
    "10.243.102.0/24",
    "10.243.103.0/24",
    "10.243.104.0/24",
    "10.243.105.0/24",
    "10.243.106.0/24",
    "10.243.107.0/24",
    "10.243.108.0/24",
  ]
}

variable "cloudwatch-group-name" {
  description = "CloudWatch group name."
  type        = string
  default     = "advanced-deployment"
}


# variable "enable_blue_env" {
#   description = "Enable blue environment"
#   type        = bool
#   default     = true
# }

# variable "blue_instance_count" {
#   description = "Number of instances in blue environment"
#   type        = number
#   default     = 2
# }

# variable "enable_green_env" {
#   description = "Enable green environment"
#   type        = bool
#   default     = true
# }

# variable "green_instance_count" {
#   description = "Number of instances in green environment"
#   type        = number
#   default     = 2
# }

/*
While you could manually modify the load balancer's target groups to include the green environment, using feature toggles codifies this change for you. In this step, you will add a traffic_distribution variable and traffic_dist_map local variable to your configuration. The configuration will automatically assign the target group's weight based on the traffic_distribution variable.
*/

# locals {
#   traffic_dist_map = {
#     blue = {
#       blue  = 100
#       green = 0
#     }
#     blue-90 = {
#       blue  = 90
#       green = 10
#     }
#     split = {
#       blue  = 50
#       green = 50
#     }
#     green-90 = {
#       blue  = 10
#       green = 90
#     }
#     green = {
#       blue  = 0
#       green = 100
#     }
#   }
# }

# variable "traffic_distribution" {
#   description = "Levels of traffic distribution (blue|blue-90|split|green-90|green)"
#   type        = string

# }
