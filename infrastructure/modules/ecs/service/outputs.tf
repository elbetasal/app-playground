output "lb_dns" {
  description = "DNS load balancer"
  value = aws_alb.main.dns_name
}