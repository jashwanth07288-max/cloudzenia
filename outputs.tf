output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_url" {
  value = module.alb.alb_dns_name
}
