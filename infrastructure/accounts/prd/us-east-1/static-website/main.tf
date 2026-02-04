locals {
  project_name = "demo-website-prd"
  env = "prd"
  common_tags = {
    Environment = local.env
    Project = local.project_name
  }
  domain_name = "demo-static.example.com"
  route53_zone_id = "Z123456ABCDEFG"  # Reemplaza con tu Route 53 Hosted Zone ID
}


module "website_s3_with_cloudfront" {
  source = "../../../../modules/website-s3-with-cloudfront"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
  project_name        = local.project_name
  environment         = local.env
  domain_name              = local.domain_name
  route53_zone_id          = local.route53_zone_id

  # S3 configuration
  enable_versioning    = false
  bucket_force_destroy = false

  # CloudFront configuration
  price_class         = "PriceClass_100"
  default_root_object = "index.html"
  enable_ipv6         = true
  http_version        = "http2"

  # Cache TTL settings
  min_ttl     = 0
  default_ttl = 3600  # 1 hour en prod, 5 min en dev
  max_ttl     = 86400  # 24 hours en prod, 1 hour en dev

  # Custom error pages
  custom_error_responses = [
    {
      error_code            = 404
      response_code         = 404
      response_page_path    = "/404.html"
      error_caching_min_ttl = 300
    },
    {
      error_code            = 403
      response_code         = 404
      response_page_path    = "/404.html"
      error_caching_min_ttl = 300
    }
  ]

  # ACM Certificate
  create_certificate              = true
  wait_for_certificate_validation = true

  # Security
  enable_security_headers = true


  # Tags
  tags = local.common_tags
}
