output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

output "subnet_ids" {
  value = aws_subnet.subnet.*.id
}

output "subnet_arn" {
  value = aws_subnet.subnet.*.arn
}