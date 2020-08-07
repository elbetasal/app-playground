variable "environment" {
    description = "Environment its provisioning"
    type = string
}

variable "number_of_subnets" {
    type = number
    default = 2
}

variable "cidr_block" {
    description = "CIDR block associated with the VPC"
    type = string
}

variable "public" {
    description = "Enable public access to the VPC"
    type = bool
}