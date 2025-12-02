# CloudZenia Hands-On Submission

This repository contains Terraform modules, scripts, and a microservice to satisfy the CloudZenia hands-on requirements:
- ECS (Fargate) with ALB and RDS for WordPress and a Node.js microservice
- Secrets Manager for DB credentials
- EC2 instances with NGINX, Docker and domain mapping
- HTTPS via ACM/Let's Encrypt
- CloudWatch metrics & logs
- GitHub Actions CI/CD for microservice

## Quick start
1. Edit `terraform/terraform.tfvars` with your domain and aws_region
2. Create ACM certificate for `*.yourdomain` and put ARN in `module.alb` variable
3. `cd terraform`
4. `terraform init`
5. `terraform apply -var-file=terraform.tfvars`
6. Add DNS A/ALIAS records pointing to ALB and EC2 Elastic IPs
7. For EC2 Let's Encrypt: run certbot on instance after DNS resolves

## Build microservice manually
```
cd microservice
docker build -t microservice:latest .
```

## Clean up
```
terraform destroy -var-file=terraform.tfvars
```


## Added Modules
- CloudFront + S3 module (modules/cloudfront)
- Route53 + ACM automation (modules/route53)

Documentation PDF: CloudZenia_Submission_Documentation.pdf
