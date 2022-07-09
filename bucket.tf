# Creating the S3 bucket.
resource "aws_s3_bucket" "website" {
  bucket = var.domain

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

# Bucket Policy Document
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.domain}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
}

# Bucket Policy
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
