resource "aws_ecs_service" "test-ecs-service" {
  	name            = var.service_name
  	cluster         = var.cluster_id
  	task_definition = aws_ecs_task_definition.task.arn
  	desired_count   = 2
    load_balancer {
    	target_group_arn  = aws_alb_target_group.app.arn
    	container_port    = var.port
    	container_name    = var.service_name
	}
    depends_on = [
        aws_alb.main,
    ]
}   