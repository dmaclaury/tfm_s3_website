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
  proxied = false
}

# Create a www CNAME to the S3 website endpoint
resource "cloudflare_record" "site_cname_www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www.${var.domain}"
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"

  ttl     = 1
  proxied = false
}

# Create ACM DNS validation records
resource "cloudflare_record" "acm_validation" {
  zone_id = data.cloudflare_zones.domain.zones[0].id

  for_each = { # Make sure we validate all the required entries from ACM
    for vali in aws_acm_certificate.acm_cert.domain_validation_options : vali.domain_name => {
      name  = vali.resource_record_name
      value = vali.resource_record_value
      type  = vali.resource_record_type
    }
  }

  name  = each.value.name
  value = each.value.value
  type  = each.value.type

}