# outputs.tf

# S3 Bucket Information
output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static site"
  value       = aws_s3_bucket.static_site.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.static_site.arn
}

output "s3_website_endpoint" {
  description = "S3 website endpoint (not used directly, but useful for testing)"
  value       = aws_s3_bucket_website_configuration.static_site.website_endpoint
}

# CloudFront Distribution Information
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.static_site.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.static_site.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (point your DNS here)"
  value       = aws_cloudfront_distribution.static_site.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID (for DNS alias records)"
  value       = aws_cloudfront_distribution.static_site.hosted_zone_id
}

# SSL Certificate Information
output "acm_certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = aws_acm_certificate.static_site.arn
}

output "acm_certificate_domain_validation_options" {
  description = "Domain validation options for the SSL certificate (add these DNS records to Namecheap)"
  value       = aws_acm_certificate.static_site.domain_validation_options
  sensitive   = false
}

# Deployment Information
output "deployment_instructions" {
  description = "Next steps to complete your setup"
  value = <<-EOT
    
    🚀 DEPLOYMENT INSTRUCTIONS:
    
    1. DNS SETUP (Namecheap):
       - Add a CNAME record for your subdomain pointing to: ${aws_cloudfront_distribution.static_site.domain_name}
       - Example: subdomain.yourdomain.com -> ${aws_cloudfront_distribution.static_site.domain_name}
    
    2. SSL CERTIFICATE VALIDATION:
       - Add the DNS validation records shown in 'acm_certificate_domain_validation_options' to your Namecheap DNS
       - This validates that you own the domain
    
    3. UPLOAD YOUR SITE:
       - Upload your static files to the S3 bucket: ${aws_s3_bucket.static_site.id}
       - Make sure you have an index.html file
       - Optionally add an error.html file for 404 errors
    
    4. INVALIDATE CLOUDFRONT (when updating content):
       - aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.static_site.id} --paths "/*"
    
    Your site will be available at: https://${var.domain_name}
  EOT
}
