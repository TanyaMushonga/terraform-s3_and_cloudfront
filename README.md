# 🚀 AWS Static Site Infrastructure with Terraform

A production-ready Terraform configuration that deploys a **secure, scalable, and globally distributed static website** on AWS using S3, CloudFront, and Certificate Manager.

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=flat&logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.txt)

## ✨ Features

- 🌍 **Global CDN** - CloudFront distribution for lightning-fast content delivery worldwide
- 🔒 **SSL/TLS Encryption** - Automatic HTTPS with AWS Certificate Manager
- 🛡️ **Security Best Practices** - Origin Access Control (OAC), private S3 bucket, secure policies
- 💰 **Cost-Optimized** - Smart caching, compression, and PriceClass_100 for cost efficiency
- 🔄 **Version Control** - S3 bucket versioning enabled for content rollback capabilities
- 📱 **SPA-Ready** - Custom error handling for Single Page Applications
- 🏷️ **Resource Tagging** - Comprehensive tagging strategy for cost allocation and management
- 🔧 **Infrastructure as Code** - Fully reproducible and version-controlled infrastructure

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   User/Browser  │───▶│   CloudFront     │───▶│   S3 Bucket     │
│                 │    │   Distribution   │    │  (Private)      │
│  yourdomain.com │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │                         ▲
                              ▼                         │
                       ┌──────────────────┐           │
                       │  ACM Certificate │           │
                       │   (SSL/HTTPS)    │           │
                       └──────────────────┘           │
                                                       │
                       ┌──────────────────┐           │
                       │      OAC         │───────────┘
                       │ (Origin Access   │
                       │   Control)       │
                       └──────────────────┘
```

### What This Creates

| Resource                    | Purpose             | Key Features                                        |
| --------------------------- | ------------------- | --------------------------------------------------- |
| **S3 Bucket**               | Static file hosting | Private access, versioning, website configuration   |
| **CloudFront Distribution** | Global CDN          | HTTPS redirect, caching, compression, custom errors |
| **Origin Access Control**   | Secure S3 access    | Replaces legacy OAI, uses SigV4 signing             |
| **ACM Certificate**         | SSL/TLS encryption  | Free SSL certificate with DNS validation            |
| **S3 Bucket Policy**        | Access control      | Allows only CloudFront to access bucket content     |

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://terraform.io/downloads.html) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- A domain name (for SSL certificate and custom domain)

### AWS Permissions Required

Your AWS user/role needs the following permissions:

- `s3:*` (for S3 bucket management)
- `cloudfront:*` (for CloudFront distribution)
- `acm:*` (for SSL certificate management)
- `iam:GetRole`, `iam:PassRole` (for service roles)

### 1. Clone and Configure

```bash
git clone <your-repo-url>
cd aws-static-site
```

### 2. Set Up Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
# Your AWS region (S3 bucket location)
region = "us-west-2"

# Globally unique S3 bucket name
bucket_name = "my-awesome-site-2024"

# Your domain name
domain_name = "blog.yourdomain.com"

# Environment
environment = "prod"

# Custom tags
tags = {
  Project   = "My Awesome Blog"
  ManagedBy = "Terraform"
  Owner     = "Your Name"
  CostCenter = "Marketing"
}
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

### 4. Complete DNS Setup

After deployment, Terraform will output DNS records you need to add:

```bash
# Get your CloudFront domain and certificate validation records
terraform output
```

**Add these DNS records to your domain provider:**

1. **CNAME for your subdomain** (points to CloudFront):

   ```
   blog.yourdomain.com → d1234567890123.cloudfront.net
   ```

2. **CNAME for certificate validation** (validates domain ownership):
   ```
   _abc123...yourdomain.com → _def456...acm-validations.aws
   ```

### 5. Upload Your Site

Upload your static files to the S3 bucket:

```bash
# Using AWS CLI
aws s3 sync ./my-website/ s3://your-bucket-name/

# Or use the S3 console
# Make sure you have at least an index.html file
```

## 📁 Project Structure

```
aws-static-site/
├── main.tf                    # Main infrastructure configuration
├── variables.tf               # Input variables definition
├── outputs.tf                 # Output values (URLs, IDs, etc.)
├── terraform.tfvars           # Your variable values (not in git)
├── terraform.tfvars.example   # Example variable values
├── index.html                 # Sample homepage
├── error.html                 # Sample error page
├── LICENSE.txt                # MIT license
└── README.md                  # This file
```

## 🔧 Configuration Options

### Variables Reference

| Variable      | Description                         | Type          | Default          | Required |
| ------------- | ----------------------------------- | ------------- | ---------------- | -------- |
| `region`      | AWS region for S3 bucket            | `string`      | `us-west-2`      | No       |
| `bucket_name` | Globally unique S3 bucket name      | `string`      |                  | Yes      |
| `domain_name` | Domain name for your site           | `string`      |                  | Yes      |
| `environment` | Environment name (dev/staging/prod) | `string`      | `dev`            | No       |
| `tags`        | Common resource tags                | `map(string)` | See variables.tf | No       |

### Outputs Reference

After deployment, you'll get these useful outputs:

| Output                       | Description                | Usage                        |
| ---------------------------- | -------------------------- | ---------------------------- |
| `cloudfront_distribution_id` | CloudFront distribution ID | Cache invalidation           |
| `cloudfront_domain_name`     | CloudFront domain          | DNS CNAME target             |
| `s3_bucket_name`             | S3 bucket name             | File uploads                 |
| `acm_certificate_arn`        | SSL certificate ARN        | Reference in other resources |

## 🛠️ Common Operations

### Updating Site Content

1. **Upload new files:**

   ```bash
   aws s3 sync ./my-website/ s3://your-bucket-name/
   ```

2. **Invalidate CloudFront cache:**
   ```bash
   aws cloudfront create-invalidation \
     --distribution-id E1234567890123 \
     --paths "/*"
   ```

### Monitoring and Logs

- **CloudFront Access Logs**: Enable in CloudFront console if needed
- **S3 Access Logs**: Enable in S3 console for detailed access patterns
- **CloudWatch Metrics**: Available for both S3 and CloudFront

### Scaling Considerations

- **Price Class**: Currently set to `PriceClass_100` (US, Canada, Europe)
  - Change to `PriceClass_All` for global edge locations
- **Caching**: Configured for 1-hour default TTL
  - Adjust `default_ttl` and `max_ttl` in main.tf
- **Compression**: Enabled by default for better performance

## 🔒 Security Features

### What's Included

- ✅ **Private S3 Bucket** - No public access, CloudFront-only access
- ✅ **Origin Access Control (OAC)** - Modern replacement for OAI
- ✅ **HTTPS Enforced** - All HTTP traffic redirected to HTTPS
- ✅ **IAM Policies** - Least-privilege access principles
- ✅ **Resource Tagging** - Complete resource attribution

### Security Best Practices

- SSL certificate automatically renews
- S3 bucket policy restricts access to CloudFront only
- No public S3 bucket access
- All traffic encrypted in transit

## 💡 Troubleshooting

### Common Issues

**1. Certificate Validation Stuck**

- Ensure DNS records are correctly added to your domain provider
- DNS propagation can take up to 48 hours
- Check AWS Certificate Manager console for validation status

**2. CloudFront Distribution Not Working**

- Verify S3 bucket policy allows CloudFront access
- Check that OAC is properly configured
- Distribution deployment can take 15-20 minutes

**3. Custom Domain Not Working**

- Ensure CNAME record points to CloudFront domain
- Verify certificate is validated and attached
- Check that domain matches certificate exactly

**4. 403/404 Errors**

- Ensure `index.html` exists in S3 bucket root
- Check file permissions and bucket policy
- Verify CloudFront cache behavior settings

### Getting Help

```bash
# Check Terraform state
terraform show

# Validate configuration
terraform validate

# See detailed deployment logs
terraform apply -auto-approve 2>&1 | tee deploy.log
```

## 💰 Cost Optimization

### Estimated Monthly Costs (US-West-2)

| Service             | Usage         | Est. Cost        |
| ------------------- | ------------- | ---------------- |
| S3 Standard Storage | 1GB           | $0.023           |
| CloudFront          | 10GB transfer | $0.85            |
| Route 53            | DNS queries   | $0.40            |
| ACM Certificate     | SSL cert      | $0.00            |
| **Total**           |               | **~$1.27/month** |

### Cost-Saving Tips

- Use S3 Intelligent Tiering for infrequently accessed content
- Set appropriate CloudFront TTL values to reduce origin requests
- Monitor usage with AWS Cost Explorer
- Use CloudFront price class optimization

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add/update tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

## 🔗 Related Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS Certificate Manager](https://docs.aws.amazon.com/acm/)

---

**⭐ If this project helped you, please give it a star!**

Built with ❤️ using [Terraform](https://terraform.io) and [AWS](https://aws.amazon.com)
