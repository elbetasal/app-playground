resource "aws_lb_target_group" "default_target_group" {

  name = "${var.environment}-lb"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id

  # No stickiness block.
  # No health_check block.

}
