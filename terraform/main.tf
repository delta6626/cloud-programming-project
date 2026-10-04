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

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# Upload the website files into the private bucket
resource "aws_s3_object" "private_frontend_files" {
  bucket = aws_s3_bucket.private_frontend_bucket.id

  for_each = fileset("${path.module}/front-end/", "**")
  key = each.value
  source = "${path.module}/front-end/${each.value}"
}

# Create CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "private_frontend_oac" {
  name = "private-frontend-oac"

  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# Create the CloudFront CDN
resource "aws_cloudfront_distribution" "private_frontend_distribution" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.private_frontend_bucket.bucket_regional_domain_name
    origin_id = aws_s3_bucket.private_frontend_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.private_frontend_oac.id
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.private_frontend_bucket.id
    viewer_protocol_policy = "redirect-to-https"
  }

  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "private_frontend_bucket_policy" {
  bucket = aws_s3_bucket.private_frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "cloudfront.amazonaws.com"
      }

      Action = "s3:GetObject"

      Resource = "${aws_s3_bucket.private_frontend_bucket.arn}/*"

      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.private_frontend_distribution.arn
        }
      }
    }]
  })
}