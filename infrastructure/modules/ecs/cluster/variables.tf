variable "name" {  
    type = string
}

variable "size" {
    type = number
}

variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "EC2 type for the cluster's instances"
}

variable "ssh_key_name"  {
    type = string
    default = "my-pocs"
    description = "Key name to be used to SSH to the instances"
}

variable "subnet_ids" { 
    type = list
}

variable "environment" {
    type = string
}

variable "vpc_id" {
    type = string
}