variable "environment" {
  type        = string
  description = "Deployment environment. i.e. Prod, Staging, Dev"
  default     = "Staging"
}

variable "domain" {
  type        = string
  description = "Domain for the S3 website."
}