variable "cluster_name" {
  type = string
}

variable "size" {
  type = number
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 type for the cluster's instances"
}

variable "ssh_key_name" {
  type        = string
  default     = "production-ecs"
  description = "Key name to be used to SSH to the instances"
}

variable "subnet_ids" {
  type = list(any)
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
  default = "elbeta.dev"
}

locals {
  domain_namespace = "${var.environment}.${var.domain}"
}

