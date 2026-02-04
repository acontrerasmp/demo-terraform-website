# Data Sources for CloudFront Policies

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3" {
  name = "Managed-CORS-S3Origin"
}

locals {
  bucket_name = var.bucket_name != null ? var.bucket_name : "${var.project_name}-${var.environment}-website"
  
  all_domain_names = concat([var.domain_name], var.alternative_domain_names)
  
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}

# S3 Bucket for Static Website

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.10.0"

  bucket        = local.bucket_name
  force_destroy = var.bucket_force_destroy

  # Ownership controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Versioning
  versioning = var.enable_versioning ? {
    enabled = true
  } : {}

  # Block all public access (CloudFront will access via OAC)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  tags = local.common_tags
}

# Bucket policy to allow CloudFront OAC access
resource "aws_s3_bucket_policy" "cloudfront_oac" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3_bucket.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.cloudfront_distribution_arn
          }
        }
      }
    ]
  })

  depends_on = [module.cloudfront]
}

# ACM Certificate

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.3.0"

  create_certificate = var.create_certificate

  domain_name               = var.domain_name
  zone_id                   = var.route53_zone_id
  subject_alternative_names = var.alternative_domain_names

  validation_method = "DNS"

  wait_for_validation = var.wait_for_certificate_validation

  tags = local.common_tags

  # CloudFront requires certificates in us-east-1
  providers = {
    aws = aws.us_east_1
  }
}

# CloudFront Distribution

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "6.4.0"

  aliases = local.all_domain_names
  comment             = "${var.project_name}-${var.environment} CloudFront Distribution"
  enabled             = true
  is_ipv6_enabled     = var.enable_ipv6
  price_class         = var.price_class
  http_version        = var.http_version
  default_root_object = var.default_root_object
  wait_for_deployment = false

  # Origin Access Control for S3
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3 bucket ${local.bucket_name}"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # S3 Origin
  origin = {
    s3_bucket = {
      domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control_key = "s3_oac"
    }
  }

  # Default cache behavior
  default_cache_behavior = {
    target_origin_id       = "s3_bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3.id

    # Use security headers policy if enabled
    response_headers_policy_id = var.enable_security_headers ? aws_cloudfront_response_headers_policy.security_headers[0].id : null
    forwarded_values = null
  }

  # Custom error responses
  custom_error_response = var.custom_error_responses

  # SSL Certificate
  viewer_certificate = {
    acm_certificate_arn      = var.create_certificate ? module.acm.acm_certificate_arn : var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


#   # Logging configuration (if enabled)
#   logging_config = var.enable_logging ? {
#     bucket          = "${var.log_bucket_name}.s3.amazonaws.com"
#     prefix          = var.log_prefix
#     include_cookies = false
#   } : null

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}

# Security Headers Response Policy

resource "aws_cloudfront_response_headers_policy" "security_headers" {
  count = var.enable_security_headers ? 1 : 0

  name    = "${var.project_name}-${var.environment}-security-headers"
  comment = "Security headers policy for ${var.project_name}-${var.environment}"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }

    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    content_security_policy {
      content_security_policy = "default-src 'self'; img-src 'self' data: https:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
      override                = true
    }
  }
}

resource "aws_route53_record" "cloudfront_alias" {
    for_each = toset(local.all_domain_names)
    zone_id  = var.route53_zone_id
    name     = each.value
    type     = "A"

    alias {
        name                   = module.cloudfront.cloudfront_distribution_domain_name
        zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
        evaluate_target_health = false
    }

    depends_on = [module.cloudfront]
}

resource "aws_route53_record" "cloudfront_alias_ipv6" {
    for_each = var.enable_ipv6 ? toset(local.all_domain_names) : toset([])
    zone_id  = var.route53_zone_id
    name     = each.value
    type     = "AAAA"

    alias {
        name                   = module.cloudfront.cloudfront_distribution_domain_name
        zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
        evaluate_target_health = false
    }

    depends_on = [module.cloudfront]
}