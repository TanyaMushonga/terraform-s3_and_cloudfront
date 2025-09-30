# terraform.tfvars
# Your actual configuration values

# AWS region where you want to deploy your S3 bucket
region = "us-west-2"

# Globally unique S3 bucket name - include your name/timestamp to make it unique
bucket_name = "tanya-static-site-2025-09-29"

# Your domain name (the subdomain you'll create in Namecheap)
domain_name = "static.devmetrics.dev"

# Environment
environment = "dev"

# Additional tags
tags = {
  Project   = "My Static Site"
  ManagedBy = "Terraform"
  Owner     = "Tanya"
}