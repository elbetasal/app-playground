resource "aws_lb_listener_rule" "path-based-routing" {
  listener_arn  = var.lb_arn
  priority =  100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  # N.B. Multiple Hostname Support
  # condition block values are a list, but only support one item :(
  # To support all common aliases ('-use1-', '-platform-') for the hostnames, we use a pattern.

  condition {
    path_pattern {
      values = [
        var.entrypoint
      ]
    }
  }
}
