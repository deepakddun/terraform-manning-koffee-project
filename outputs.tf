output "vpc_id" {
  value = module.vpc.vpc.vpc_id
}

output "aws_lb_url" {
  value = module.container.lb_url
}
