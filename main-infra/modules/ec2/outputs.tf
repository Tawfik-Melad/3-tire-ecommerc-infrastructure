output "public_instance_id" {
  description = "ID of public EC2 instances"
  value       = aws_instance.public.id
}

output "public_ip" {
  description = "Public IP of public EC2 instances"
  value       = aws_instance.public.public_ip
}

output "private_instance_id" {
  description = "ID of private EC2 instances"
  value       = aws_instance.private.id
}

output "private_ip" {
  description = "Private IP of private EC2 instances"
  value       = aws_instance.private.private_ip
}
