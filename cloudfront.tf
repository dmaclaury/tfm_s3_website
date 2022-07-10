locals {
  s3_origin_id = "S3Origin"
}

#Define us-east-1 since CloudFront only uses ACM from us-east-1
provider "aws" {
  region = "us-east-1"
  alias  = "aws_cloudfront"
}

# Create an ACM certificate for our domain with SANs for the domain and www.domain
resource "aws_acm_certificate" "acm_cert" {
  provider = aws.aws_cloudfront #Use the us-east-1 region provider for Cloudfront ACM

  domain_name       = var.domain
  validation_method = "DNS"

  subject_alternative_names = ["${var.domain}", "www.${var.domain}"]


  tags = {
    Name        = var.domain
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create our OAI
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.domain
}

# Create the cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.domain}", "www.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100" # We're primarily concerned with US & EU access so we'll save costs here.

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = var.domain
    Environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.acm_cert.arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 403
    response_page_path = "/error.html"
  }
}