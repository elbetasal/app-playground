data "aws_availability_zones" "aws-east" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "this" {
  count = length(slice(data.aws_availability_zones.aws-east.names,0, var.number_of_subnets))
  cidr_block = cidrsubnet(aws_vpc.this[0].cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.aws-east.names[count.index]
  vpc_id = aws_vpc.this[0].id
  map_public_ip_on_launch = var.public
  tags = {
    Name = "${var.environment}-subnet"
}
}

resource "aws_internet_gateway" "this" {
    count = var.public
  vpc_id = aws_vpc.this[0].id
  tags = {
    Name = "${var.environment}-gateway"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  tags = {
    Name = "${var.environment}-route-table"
  }
 }
 
resource "aws_route_table_association" "this" {
  count = length(data.aws_availability_zones.aws-east.names)
  subnet_id = element(aws_subnet.this[0].*.id, count.index)
  route_table_id = aws_route_table.this[0].id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.this[0].id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this[0].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "allow_tls"
  }

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSL access"
  vpc_id      = aws_vpc.this[0].id

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
  
  tags = {
      Name = "allow_ssh"
  }
}