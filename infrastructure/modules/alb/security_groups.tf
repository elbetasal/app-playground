resource "aws_security_group" "aws-lb" {
  name = "${var.environment}-permanent"
  description = "Controls access to the ALB"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-permanent"
  }
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
