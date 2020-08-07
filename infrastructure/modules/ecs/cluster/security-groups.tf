  ##Move this resource to its own file and find a way to read it outside
  resource "aws_security_group" "ecs-cluster-host" {
  name = "ecs-cluster-host"
  description = "ecs-cluster-host"
  vpc_id = var.vpc_id
  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 1025
    to_port               = 65535
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 0
    to_port               = 0
    protocol              = "icmp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

