resource "aws_ecs_task_definition" "hello-task" {
    family                = "hello_world"
    container_definitions = <<DEFINITION
[
  {
    "name": "hello",
    "image": "pleymo/greeting-service",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "memory": 500,
    "cpu": 10
  }
]
DEFINITION
}

resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	cluster         = aws_ecs_cluster.aws-ecs.id
  	task_definition = aws_ecs_task_definition.hello-task.arn
  	desired_count   = 2
    load_balancer {
    	target_group_arn  = aws_alb_target_group.nginx_app.arn
    	container_port    = 8080
    	container_name    = "hello"
	}
}   