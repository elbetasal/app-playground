variable "environment" {
    type = string
}

variable "subnet_ids" {
    type = list
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