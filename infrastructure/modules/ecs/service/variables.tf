variable "environment" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "health_check_path" {
    type = string
}

variable "service_name" { 
    type = string
}

variable "image" {
    type = string
}

variable "port" {
    type = number
}

variable "cluster_id" {
    type = string
}

variable "desired_size" {
    type = number
}

variable "lb_arn" {
    type = string
}

variable "entrypoint" {
    type = string
}

variable "service_registry_id" {
    type = string
}

variable "private_subnets" {
    type = list(string)
}

variable "service_registry_arn" {
    type = string
}

variable "memory" {
    type = number
}
variable "cpu" {
    type = number
}
variable "app_mesh" {
    type = string
}

variable "root_domain" {
    type = string
}

locals {
    domain_namespace = "${var.environment}.${var.root_domain}"
}
