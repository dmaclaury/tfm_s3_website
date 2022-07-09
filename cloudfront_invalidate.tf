# Based on https://faun.pub/lets-do-devops-terraform-hacking-s3-and-cloudfront-dependencies-13c8a2af2f20
resource "null_resource" "invalidate_cf_cache" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} --paths '/*'"
  }
  depends_on = [
    aws_s3_object.index,
  ]
}