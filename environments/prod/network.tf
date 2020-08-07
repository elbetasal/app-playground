data "aws_availability_zones" "aws-east" {
  state = "available"
}

resource "aws_vpc" "production-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "production-vpc"
  }
}

resource "aws_subnet" "production-subnet" {
  count = length(slice(data.aws_availability_zones.aws-east.names,0, 2))
  cidr_block = cidrsubnet(aws_vpc.production-vpc.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.aws-east.names[count.index]
  vpc_id = aws_vpc.production-vpc.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "production-subnet"
  }
}

resource "aws_internet_gateway" "production-gateway" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "production-gateway"
  }
}

resource "aws_route_table" "production-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production-gateway.id
  }
  tags = {
    Name = "production-route-table"
  }
 }
 
resource "aws_route_table_association" "a" {
  count = length(data.aws_availability_zones.aws-east.names)
  subnet_id = element(aws_subnet.production-subnet.*.id, count.index)
  route_table_id = aws_route_table.production-route-table.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.production-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.production-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSL access"
  vpc_id      = aws_vpc.production-vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
}
