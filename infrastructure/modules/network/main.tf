data "aws_availability_zones" "aws-east" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count                   = length(slice(data.aws_availability_zones.aws-east.names, 0, var.number_of_subnets))
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.aws-east.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.public
  tags = {
    Name = "${var.environment}-subnet"
  }
}