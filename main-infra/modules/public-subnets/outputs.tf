output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
