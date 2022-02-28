data "aws_ami" "ecs-ami" {
  most_recent = true
  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name = "architecture"
    values = [
      "x86_64"]
  }
  owners = [
    "amazon"]
}

data "template_file" "ecs-config" {
  template = file("${path.module}/ecs_config.sh")
  vars = {
    ecs_cluster = var.cluster_name
  }
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "${var.environment}-launch-configuration"
  image_id = data.aws_ami.ecs-ami.image_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type = "standard"
    volume_size = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.ecs-cluster-host.id]
  associate_public_ip_address = "true"
  key_name = var.ssh_key_name
  user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=production-cluster >> /etc/ecs/ecs.config
                                  EOF
}


resource "aws_launch_template" "ecs-launch-template" {
  name = "${var.environment}-launch-template"
  image_id = data.aws_ami.ecs-ami.image_id
  instance_type = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs-instance-profile.arn
  }
  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 100
      volume_type = "standard"
      delete_on_termination = true
    }
  }
  vpc_security_group_ids = [aws_security_group.ecs-cluster-host.id]
  key_name = var.ssh_key_name
  user_data = base64encode(data.template_file.ecs-config.rendered)
  disable_api_termination = false
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = var.size
  min_size = var.size
  desired_capacity = var.size
  vpc_zone_identifier = var.subnet_ids
#  launch_configuration = aws_launch_configuration.ecs-launch-configuration.id
  health_check_type = "EC2"
  launch_template {
    id = aws_launch_template.ecs-launch-template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

//How to healtcheck the cloud map or the service?
//How to deploy another microservice and use the route 53 domain?
// Setup SSM To connect
