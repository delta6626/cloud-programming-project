output "private_s3_bucket_name" {
  description = "Name of the private S3 bucket"
  value = aws_s3_bucket.private_frontend_bucket.id
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value = aws_cloudfront_distribution.private_frontend_distribution.id
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value = "https://${aws_cloudfront_distribution.private_frontend_distribution.domain_name}"
}