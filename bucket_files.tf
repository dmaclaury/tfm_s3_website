# Upload index.html to the bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "web/index.html"
  etag   = filemd5("web/index.html")
}