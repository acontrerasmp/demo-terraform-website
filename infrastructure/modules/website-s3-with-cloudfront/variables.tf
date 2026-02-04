# General variables
variable "environment" {
  description = "Environment name (e.g., dev, stg, prd)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "environment must be one of: dev, stg, prd"
  }
}

variable "project_name" {
  description = "Project name to use for resource naming"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# S3 Bucket variables
variable "bucket_name" {
  description = "Name of the S3 bucket (if not provided, will be generated)"
  type        = string
  default     = null
}

variable "bucket_force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

# CloudFront variables
variable "domain_name" {
  description = "Primary domain name for the website (e.g., example.com)"
  type        = string
}

variable "alternative_domain_names" {
  description = "Alternative domain names (SANs) for the website (e.g., [www.example.com])"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "CloudFront distribution price class (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "custom_error_responses" {
  description = "Custom error responses for CloudFront"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "/404.html"
    },
    {
      error_code         = 403
      response_code      = 404
      response_page_path = "/404.html"
    }
  ]
}

variable "enable_ipv6" {
  description = "Enable IPv6 for CloudFront distribution"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "Maximum HTTP version to support on the distribution (http1.1, http2, http2and3, http3)"
  type        = string
  default     = "http2"
}

variable "min_ttl" {
  description = "Minimum amount of time objects stay in CloudFront cache"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default amount of time objects stay in CloudFront cache"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum amount of time objects stay in CloudFront cache"
  type        = number
  default     = 86400
}

# ACM Certificate variables
variable "create_certificate" {
  description = "Whether to create ACM certificate (set to false if you already have one)"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "ARN of existing ACM certificate (required if create_certificate is false)"
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS validation (required if create_certificate is true)"
  type        = string
  default     = null
}

variable "wait_for_certificate_validation" {
  description = "Wait for certificate validation to complete"
  type        = bool
  default     = true
}



# Security Headers
variable "enable_security_headers" {
  description = "Enable security headers via CloudFront response headers policy"
  type        = bool
  default     = true
}

# Logging
# variable "enable_logging" {
#   description = "Enable CloudFront access logging"
#   type        = bool
#   default     = false
# }

# variable "log_bucket_name" {
#   description = "S3 bucket name for CloudFront logs (if enable_logging is true)"
#   type        = string
#   default     = null
# }

# variable "log_prefix" {
#   description = "Prefix for CloudFront log files"
#   type        = string
#   default     = "cloudfront/"
# }


