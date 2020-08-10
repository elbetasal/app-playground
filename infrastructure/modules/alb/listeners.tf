resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.main.id
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.default_target_group.arn
    type = "forward"
  }
}
