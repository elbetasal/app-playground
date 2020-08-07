resource "aws_alb" "main" {
  name = "${var.environment}-load-balancer"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "${var.environment}-load-balancer"
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

resource "aws_security_group" "aws-lb" {
  name = "${var.environment}-${var.service_name}-permanent"
  description = "Controls access to the ALB"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-${var.service_name}-permanent"
  }
}

resource "aws_security_group_rule" "allow_entry" {
  security_group_id = aws_security_group.aws-lb.id
  description = "ecs cluster egress"
  type = "ingress"
  from_port = var.port
  to_port = var.port
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow" {
  security_group_id = aws_security_group.aws-lb.id
  description = "ecs cluster egress"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_egress" {
  security_group_id = aws_security_group.aws-lb.id
  description = "ecs cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
