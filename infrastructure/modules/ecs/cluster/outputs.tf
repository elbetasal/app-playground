output "id" {
    value = aws_ecs_cluster.aws-ecs.id
}

output "arn" {
    value = aws_ecs_cluster.aws-ecs.arn
}

output "service_discovery_registry_id" {
    value = aws_service_discovery_private_dns_namespace.ecs-namespace.id
}

output "service_discovery_registry_arn" {
    value = aws_service_discovery_private_dns_namespace.ecs-namespace.arn
}

output "domain" {
    value = local.domain_namespace
}
