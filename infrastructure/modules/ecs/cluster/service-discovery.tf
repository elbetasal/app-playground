resource "aws_service_discovery_private_dns_namespace" "ecs-namespace" {
  name = "${var.environment}.${var.domain}"
  vpc  = var.vpc_id
}
