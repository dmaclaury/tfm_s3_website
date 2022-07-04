terraform {
  backend "s3" {
    bucket = "tfm-backend-green-otter"
    region = "us-west-2"
    key    = "tfm_s3_website"
  }
}
