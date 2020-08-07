variable "environment" {
  description = "Environment its provisioning"
  type        = string
}

variable "vpc_id" {
    type = string
}

variable "port" {
    type = number
}

variable "health_check_path" {
    type = string
    default = "/"
}

variable "subnets" {
    type = list
}

variable "service_name" {
    type = string
}