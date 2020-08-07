resource "aws_internet_gateway" "ig" {
  count  = var.public ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-gateway"
  }
}

resource "aws_route_table" "route-table" {
  count  = var.public ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig[0].id
  }
  tags = {
    Name = "${var.environment}-route-table"
  }
}

resource "aws_route_table_association" "this" {
  count          = length(aws_subnet.subnet.*)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.route-table[0].id
}