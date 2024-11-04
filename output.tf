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
