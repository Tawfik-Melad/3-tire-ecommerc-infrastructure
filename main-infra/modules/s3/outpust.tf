output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.static_bucket.bucket
}

output "bucket_url" {
  description = "Public URL of the created S3 bucket"
  value       = "https://${aws_s3_bucket.static_bucket.bucket}.s3.amazonaws.com"
}


output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.static_bucket.arn
}
