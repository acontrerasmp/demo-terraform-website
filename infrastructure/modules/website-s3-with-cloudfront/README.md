## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 6.3.0 |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | terraform-aws-modules/cloudfront/aws | 6.4.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_response_headers_policy.security_headers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_route53_record.cloudfront_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cloudfront_alias_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket_policy.cloudfront_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_cloudfront_cache_policy.caching_optimized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.cors_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternative_domain_names"></a> [alternative\_domain\_names](#input\_alternative\_domain\_names) | Alternative domain names (SANs) for the website (e.g., [www.example.com]) | `list(string)` | `[]` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | Allow bucket to be destroyed even if it contains objects | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket (if not provided, will be generated) | `string` | `null` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of existing ACM certificate (required if create\_certificate is false) | `string` | `null` | no |
| <a name="input_create_certificate"></a> [create\_certificate](#input\_create\_certificate) | Whether to create ACM certificate (set to false if you already have one) | `bool` | `true` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | Custom error responses for CloudFront | <pre>list(object({<br/>    error_code            = number<br/>    response_code         = optional(number)<br/>    response_page_path    = optional(string)<br/>    error_caching_min_ttl = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "error_code": 404,<br/>    "response_code": 404,<br/>    "response_page_path": "/404.html"<br/>  },<br/>  {<br/>    "error_code": 403,<br/>    "response_code": 404,<br/>    "response_page_path": "/404.html"<br/>  }<br/>]</pre> | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Default root object for CloudFront | `string` | `"index.html"` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default amount of time objects stay in CloudFront cache | `number` | `3600` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary domain name for the website (e.g., example.com) | `string` | n/a | yes |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6 for CloudFront distribution | `bool` | `true` | no |
| <a name="input_enable_security_headers"></a> [enable\_security\_headers](#input\_enable\_security\_headers) | Enable security headers via CloudFront response headers policy | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning on the S3 bucket | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, stg, prd) | `string` | n/a | yes |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | Maximum HTTP version to support on the distribution (http1.1, http2, http2and3, http3) | `string` | `"http2"` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | Maximum amount of time objects stay in CloudFront cache | `number` | `86400` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | Minimum amount of time objects stay in CloudFront cache | `number` | `0` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront distribution price class (PriceClass\_All, PriceClass\_200, PriceClass\_100) | `string` | `"PriceClass_100"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name to use for resource naming | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 hosted zone ID for DNS validation (required if create\_certificate is true) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_wait_for_certificate_validation"></a> [wait\_for\_certificate\_validation](#input\_wait\_for\_certificate\_validation) | Wait for certificate validation to complete | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the ACM certificate |
| <a name="output_acm_certificate_status"></a> [acm\_certificate\_status](#output\_acm\_certificate\_status) | Status of the certificate |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name of the CloudFront distribution |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the CloudFront distribution |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The current status of the distribution |
| <a name="output_cloudfront_url"></a> [cloudfront\_url](#output\_cloudfront\_url) | The CloudFront distribution URL |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The bucket domain name |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the S3 bucket |
| <a name="output_s3_bucket_regional_domain_name"></a> [s3\_bucket\_regional\_domain\_name](#output\_s3\_bucket\_regional\_domain\_name) | The bucket regional domain name |
| <a name="output_security_headers_policy_id"></a> [security\_headers\_policy\_id](#output\_security\_headers\_policy\_id) | The ID of the CloudFront security headers policy |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | The URL of the website |