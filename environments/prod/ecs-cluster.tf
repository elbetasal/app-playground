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
    max_size                    = "1"
    min_size                    = "1"
    desired_capacity            = "1"
    vpc_zone_identifier         = [aws_subnet.production-subnet.id]
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