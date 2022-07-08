# Add cloudflare DNS and page rules for our S3 website
# Based on https://learn.hashicorp.com/tutorials/terraform/cloudflare-static-website?in=terraform/aws

# Get the zone_id for our domain
data "cloudflare_zones" "domain" {
  filter {
    name = var.tld
  }
}

# Create a CNAME to the S3 website endpoint
resource "cloudflare_record" "site_cname" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.domain
  value   = aws_s3_bucket_website_configuration.website.website_endpoint
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

# Create a www CNAME to the S3 website endpoint
/*resource "cloudflare_record" "site_cname_www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www.${var.domain}"
  value   = aws_s3_bucket_website_configuration.website.website_endpoint
  type    = "CNAME"

  ttl     = 1
  proxied = true
}*/