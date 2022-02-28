resource "aws_ecs_task_definition" "task" {
    family                = var.service_name
    network_mode = "awsvpc"
    requires_compatibilities = ["EC2"]
    container_definitions = <<DEFINITION
[
  {
    "name": "${var.service_name}",
    "image": "${var.image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.port},
        "hostPort": ${var.port}
      }
    ],
    "memory": 300,
    "cpu": 10
  }
]
DEFINITION
}
