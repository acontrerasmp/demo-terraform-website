# S3 Bucket Outputs
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = module.s3_bucket.s3_bucket_bucket_regional_domain_name
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "The identifier for the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_arn
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = module.cloudfront.cloudfront_distribution_hosted_zone_id
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution"
  value       = module.cloudfront.cloudfront_distribution_status
}

# ACM Certificate Outputs
output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = var.create_certificate ? module.acm.acm_certificate_arn : var.certificate_arn
}

output "acm_certificate_status" {
  description = "Status of the certificate"
  value       = var.create_certificate ? module.acm.acm_certificate_status : null
}

# Useful information for DNS setup
output "website_url" {
  description = "The URL of the website"
  value       = "https://${var.domain_name}"
}

output "cloudfront_url" {
  description = "The CloudFront distribution URL"
  value       = "https://${module.cloudfront.cloudfront_distribution_domain_name}"
}

# Security Headers Policy
output "security_headers_policy_id" {
  description = "The ID of the CloudFront security headers policy"
  value       = var.enable_security_headers ? aws_cloudfront_response_headers_policy.security_headers[0].id : null
}

