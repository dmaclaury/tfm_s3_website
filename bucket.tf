# Random Pet Generator - used to ensure bucket name is globally unique.
resource "random_pet" "suffix" {}

# Creating the S3 bucket.
resource "aws_s3_bucket" "website" {
  bucket = "${var.domain}-${random_pet.suffix.id}"

  tags = {
    Name        = "${var.domain}"
    Environment = "${var.environment}"
  }
}

# Setting the Bucket ACL.
resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

# Blocking public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls   = true
  block_public_policy = true
}

# S3 bucket website settings.
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
