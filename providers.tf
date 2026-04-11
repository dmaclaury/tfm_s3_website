# Setting the required Terraform Providers
terraform {
  required_version = "1.12.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Setting our target AWS region
provider "aws" {
  region = "us-west-2"
}

# CF Provider
provider "cloudflare" {}