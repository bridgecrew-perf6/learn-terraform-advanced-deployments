output "lb_dns_name" {
  value = aws_lb.app.dns_name
}

# output "enable_blue_env" {
#   value = var.enable_blue_env
# }

# output "enable_green_env" {
#   value = var.enable_green_env
# }

# output "traffic_distribution" {
#   value = var.traffic_distribution
# }

output "public_subnets" {
  value = module.vpc.public_subnets
}