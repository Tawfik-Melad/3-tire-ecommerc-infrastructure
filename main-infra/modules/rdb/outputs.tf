# Endpoint (hostname) to connect Django
output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

# Username for DB connection
output "db_username" {
  description = "Database master username"
  value       = aws_db_instance.this.username
}

output "db_password" {
  description = "Database master password"
  value       = aws_db_instance.this.password
  sensitive   = true
}

# Name of DB (optional, defaults to instance identifier if not set)
output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}
