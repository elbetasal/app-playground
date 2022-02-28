resource "aws_ecs_cluster" "aws-ecs" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name
  }
}
