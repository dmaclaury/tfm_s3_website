# Output website bucket name
output "s3_bucket_name" {
    value = aws_s3_bucket.website.id
}

# Output S3 bucket website domain
output "s3_bucket_website_url" {
    value = aws_s3_bucket_website_configuration.website.website_endpoint
}
