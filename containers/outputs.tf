output "lb_url" {
  value = aws_lb.aws_ecs_lb.dns_name
}