module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  project      = var.project
}

module "secrets" {
  source = "./modules/secrets"
  project = var.project
  db_username = var.db_username
}

module "rds" {
  source = "./modules/rds"
  project = var.project
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username = var.db_username
  allocated_storage = var.db_allocated_storage
  secret_arn = module.secrets.rds_secret_arn
}

module "ecs" {
  source = "./modules/ecs"
  project = var.project
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets = module.vpc.public_subnet_ids
  rds_endpoint = module.rds.endpoint
  rds_port = module.rds.port
  secret_arn = module.secrets.rds_secret_arn
  microservice_image = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/microservice:latest" # set after pushing to ECR
  alb_tg_arn = "" # set from alb module
}

module "alb" {
  source = "./modules/alb"
  project = var.project
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_certificate_arn = "arn:aws:acm:ap-south-1:123456789012:certificate/example-arn" # Create / assign ACM cert ARN for your domain here
  domain_name = var.domain_name
}

module "ec2" {
  source = "./modules/ec2"
  project = var.project
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  key_pair_name = var.key_pair_name
  domain_name = var.domain_name
  instance_type = var.ec2_instance_type
}
