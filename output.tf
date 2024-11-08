output "vpc_id" {
  description = "ID del VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs de las subredes públicas"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs de las subredes privadas"
  value       = module.vpc.private_subnets
}

output "nat_gateway_ids" {
  description = "IDs del NAT Gateway"
  value       = module.vpc.nat_ids
}

output "url" {
  value = aws_s3_bucket.cms_images_bucket-lab4.bucket_domain_name
  description = "URL"
}

output "redis_endpoint" {
  description = "El endpoint de Redis en ElastiCache"
  value       = aws_elasticache_replication_group.redis-lab4.primary_endpoint_address
}

output "alb_dns_name" {
  description = "DNS público del Application Load Balancer"
  value       = aws_lb.alb-lab4.dns_name
}