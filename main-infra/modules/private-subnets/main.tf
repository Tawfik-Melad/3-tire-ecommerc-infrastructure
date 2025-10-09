resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones

  tags = { Name = "${var.name_prefix}-private" }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = "${var.name_prefix}-private-rt" }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
