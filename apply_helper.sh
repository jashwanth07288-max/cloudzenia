#!/usr/bin/env bash
# Small helper to init/plan/apply terraform in terraform/ directory
set -euo pipefail
cd terraform
terraform init -input=false
terraform fmt -recursive
terraform validate || true
terraform plan -var-file=terraform.tfvars -out=tfplan
echo "To apply, run: terraform apply tfplan"
