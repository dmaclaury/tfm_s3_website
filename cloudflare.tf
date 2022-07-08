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
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

# Create a www CNAME to the S3 website endpoint
resource "cloudflare_record" "site_cname_www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www.${var.domain}"
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"

  ttl     = 1
  proxied = true
}