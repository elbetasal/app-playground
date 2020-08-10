output "lb_dns" {
  description = "DNS load balancer"
  value = aws_lb.main.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.app.arn
}

output "listener_id" {
  value = aws_lb_listener.app.id
}

output "id" {
  value = aws_lb.main.id
}

output "arn" {
  value = aws_lb.main.arn
}
