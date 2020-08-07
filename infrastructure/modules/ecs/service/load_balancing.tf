resource "aws_alb" "main" {
  name = "${var.environment}-${var.service_name}-load-balancer"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "${var.environment}-${var.service_name}-load-balancer"
  }
}

resource "aws_alb_target_group" "app" {
  name = "${var.environment}-${var.service_name}"
  port = 80
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

resource "aws_alb_listener" "app" {
  load_balancer_arn = aws_alb.main.id
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type = "forward"
  }
}
