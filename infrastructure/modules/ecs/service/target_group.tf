resource "aws_lb_target_group" "app" {
  name = "${var.environment}-${var.service_name}"
  port = var.port
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = var.health_check_path
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "${var.environment}-${var.service_name}"
  }
}
