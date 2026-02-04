output "website_url" {
  description = "URL del website"
  value       = module.website_s3_with_cloudfront.website_url
}

output "cloudfront_url" {
  description = "URL de CloudFront"
  value       = module.website_s3_with_cloudfront.cloudfront_url
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = module.website_s3_with_cloudfront.s3_bucket_id
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = module.website_s3_with_cloudfront.cloudfront_distribution_id
}

output "certificate_arn" {
  description = "ARN del certificado ACM"
  value       = module.website_s3_with_cloudfront.acm_certificate_arn
}

output "deployment_instructions" {
  description = "Instrucciones para subir contenido"
  value = <<-EOT
    Para subir tu website al bucket S3:
    
    1. Construir tu aplicación:
       cd app && npm run build
    
    2. Subir archivos a S3:
       aws s3 sync ./app/out s3://${module.website_s3_with_cloudfront.s3_bucket_id}/ --delete
    
    3. Invalidar cache de CloudFront:
       aws cloudfront create-invalidation \
         --distribution-id ${module.website_s3_with_cloudfront.cloudfront_distribution_id} \
         --paths "/*"
    
    Tu website estará disponible en: ${module.website_s3_with_cloudfront.website_url}
  EOT
}