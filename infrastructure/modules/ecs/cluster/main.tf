resource "aws_ecs_cluster" "aws-ecs" {
  name = var.name 
  tags = {
    Name = var.name
  }
}