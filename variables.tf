variable "environment" {
  type        = string
  description = "Deployment environment. i.e. Prod, Staging, Dev"
}

variable "domain" {
  type        = string
  description = "Domain for the S3 website."
}