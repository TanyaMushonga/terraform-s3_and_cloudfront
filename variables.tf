# variables.tf
variable "region" {
  description = "AWS region for resources (except CloudFront certificate which must be in us-east-1)"
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  # Example: "my-static-site-bucket-12345"
}

variable "domain_name" {
  description = "Domain name for the site (e.g., blog.yourdomain.com)"
  type        = string
  # This should match the subdomain you'll create in Namecheap
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project   = "Static Site"
    ManagedBy = "Terraform"
  }
}
