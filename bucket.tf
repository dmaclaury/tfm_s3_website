resource "random_pet" "suffix" {}

resource "aws_s3_bucket" "website" {
  bucket = "${var.domain}-${random_pet.suffix.id}"

  tags = {
    Name        = "${var.domain}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls   = true
  block_public_policy = true
}