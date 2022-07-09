# Output website bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.website.id
}

# Output cloudfront domain name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}