#!/usr/bin/env bash
# Usage: ./patch_placeholders.sh DOMAIN AWS_REGION KEYPAIR ACM_ARN ECR_URI
set -euo pipefail
if [ "$#" -lt 5 ]; then
  echo "Usage: $0 DOMAIN AWS_REGION KEYPAIR ACM_ARN ECR_URI"
  exit 1
fi
DOMAIN=$1
AWS_REGION=$2
KEYPAIR=$3
ACM_ARN=$4
ECR_URI=$5

echo "Patching files with:"
echo " DOMAIN=$DOMAIN"
echo " AWS_REGION=$AWS_REGION"
echo " KEYPAIR=$KEYPAIR"
echo " ACM_ARN=$ACM_ARN"
echo " ECR_URI=$ECR_URI"

# Replace in terraform.tfvars
sed -i "s|domain_name = ".*"|domain_name = "${DOMAIN}"|" terraform/terraform.tfvars || true
sed -i "s|aws_region = ".*"|aws_region = "${AWS_REGION}"|" terraform/terraform.tfvars || true
sed -i "s|key_pair_name = ".*"|key_pair_name = "${KEYPAIR}"|" terraform/terraform.tfvars || true

# Set ACM ARN in terraform main
sed -i "s|alb_certificate_arn = "arn:aws:acm:ap-south-1:123456789012:certificate/example-arn"|alb_certificate_arn = "${ACM_ARN}"|" terraform/main.tf || true

# Set microservice ECR image
sed -i "s|microservice_image = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/microservice:latest"|microservice_image = "${ECR_URI}"|" terraform/main.tf || true

# Also replace any remaining helloworld.com or my-keypair occurrences
grep -Rl "helloworld.com" . || true | xargs -r sed -i "s|helloworld.com|${DOMAIN}|g"
grep -Rl "my-keypair" . || true | xargs -r sed -i "s|my-keypair|${KEYPAIR}|g"

echo "Patching complete. Run 'git status' to review changes."
