# Setting the required Terraform Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# Setting our target AWS region
provider "aws" {
  region = "us-west-2"
}

# CF Provider
provider "cloudflare" {}