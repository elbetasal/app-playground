resource "aws_ecs_cluster" "aws-ecs" {
  name = "production-cluster"
}

data "aws_ami" "ecs-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = data.aws_ami.ecs-ami.image_id
    instance_type               = "t2.micro"
    iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = [aws_security_group.ecs-cluster-host.id]
    associate_public_ip_address = "true"
    key_name                    = "my-pocs"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=production-cluster >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = "2"
    min_size                    = "2"
    desired_capacity            = "2"
    vpc_zone_identifier         = aws_subnet.production-subnet[*].id
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    health_check_type           = "ELB"
  }


resource "aws_security_group" "ecs-cluster-host" {
  name = "ecs-cluster-host"
  description = "ecs-cluster-host"
  vpc_id = aws_vpc.production-vpc.id
}

resource "aws_security_group_rule" "ecs-cluster-host-ssh" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "admin SSH access to ecs cluster"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "ecs cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs-cluster-port" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "ecs cluster egress"
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "aws-lb" {
  name = "load-balancer"
  description = "Controls access to the ALB"
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "load-balancer"
  }
}

resource "aws_security_group_rule" "allow_entry" {
  security_group_id = aws_security_group.aws-lb.id
  description = "ecs cluster egress"
  type = "ingress"
  from_port = 8080
  to_port = 8080
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

resource "aws_alb" "main" {
  name = "production-load-balancer"
  subnets = aws_subnet.production-subnet.*.id
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "alb"
  }
}

resource "aws_alb_target_group" "nginx_app" {
  name = "target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.production-vpc.id

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/greet"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "alb-target-group"
  }
}# Redirect all traffic from the ALB to the target group

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.nginx_app.id
    type = "forward"
  }
}# output nginx public ip
output "nginx_dns_lb" {
  description = "DNS load balancer"
  value = aws_alb.main.dns_name
}