output "public_ip" {
  value = module.ec2.public_ip
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "db_endpoint" {
  value = module.rdb.db_endpoint
}

# Output S3 bucket name
output "s3_static_bucket_name" {
  description = "The name of the S3 bucket used for static files"
  value       = module.s3_static.bucket_name
}

# Output S3 bucket ARN
output "s3_static_bucket_arn" {
  description = "The ARN of the S3 bucket used for static files"
  value       = module.s3_static.bucket_arn
}
