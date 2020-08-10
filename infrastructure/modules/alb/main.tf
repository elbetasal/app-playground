resource "aws_lb" "main" {
  name = "${var.environment}-load-balancer"
  subnets = var.subnet_ids
  internal = false
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "${var.environment}-load-balancer"
  }
}
