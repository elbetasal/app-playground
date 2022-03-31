resource "aws_ecs_task_definition" "task" {
    family                = var.service_name
    network_mode = "awsvpc"
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
    "memory": ${var.memory},
    "cpu": ${var.cpu},
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "awslogs-logtest",
                    "awslogs-region": "us-east-1",
                    "awslogs-create-group": "true",
                    "awslogs-stream-prefix": "${var.environment}-${var.service_name}"
                }
            }
  }
]
DEFINITION
}
