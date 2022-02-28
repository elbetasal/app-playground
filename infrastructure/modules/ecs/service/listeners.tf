resource "aws_lb_listener_rule" "path-based-routing" {
  listener_arn  = var.lb_arn
  priority =  100


  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = [
        var.entrypoint
      ]
    }
  }
}
