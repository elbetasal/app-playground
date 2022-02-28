resource "aws_service_discovery_service" "service-registry" {
  name = var.service_name
  dns_config {
    namespace_id = var.service_registry_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_ecs_service" "ecs-service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_size

  network_configuration {
    subnets = var.private_subnets
    security_groups = [aws_security_group.service-security-group.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service-registry.arn
    container_name = var.service_name
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name = var.service_name
    container_port = var.port
  }

}
// Create another service to call the hello with service discovery
