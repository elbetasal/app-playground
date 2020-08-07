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
    name                        = "${var.environment}-launch-configuration"
    image_id                    = data.aws_ami.ecs-ami.image_id
    instance_type               = var.instance_type
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
    key_name                    = var.ssh_key_name
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=production-cluster >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = var.size
    min_size                    = var.size
    desired_capacity            = var.size
    vpc_zone_identifier         = var.subnet_ids
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    health_check_type           = "ELB"

    lifecycle {
      create_before_destroy = true
    }
  }


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

