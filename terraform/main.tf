# Create the S3 bucket
resource "aws_s3_bucket" "private_frontend_bucket" {
  bucket = "private-s3-bucket-for-website-mahamudul-hasan-9213772"
}

# Set the bucket object's ownsership controls
resource "aws_s3_bucket_ownership_controls" "private_frontend_ownership_controls" {
  bucket = aws_s3_bucket.private_frontend_bucket.id
  
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "private_frontend_public_access_block" {
  bucket = aws_s3_bucket.private_frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload the website files into the private bucket
resource "aws_s3_object" "private_frontend_files" {
  bucket = aws_s3_bucket.private_frontend_bucket.id

  for_each = fileset("${path.module}/front-end/", "**")
  key = each.value
  source = "${path.module}/front-end/${each.value}"
}