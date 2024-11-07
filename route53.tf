#aqui va el route 53
# Configurar el dominio principal usando Route 53
resource "aws_route53_zone" "internal-zone-lab4" {
  name = "${var.domain}" 
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# Registro A para el ALB 
resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = "alb.${var.project}.${var.domain}"  # Subdominio para el ALB 
  type    = "A"
  alias {
    name                   = aws_lb.alb-lab4.dns_name
    zone_id                = aws_lb.alb-lab4.zone_id
    evaluate_target_health = true
  }
}

# Registro CNAME para RDS
resource "aws_route53_record" "rds_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = "rds.${var.project}.${var.domain}"  # Subdominio para el RDS
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.rds-lab4.endpoint]
}

# Registro CNAME para EFS
resource "aws_route53_record" "efs_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = "efs.${var.project}.${var.domain}"  # Subdominio para EFS
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_efs_file_system.efs-lab4.id}.efs.${var.aws_region}.amazonaws.com"]
}

# Registro CNAME para S3
resource "aws_route53_record" "s3_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = "s3.${var.project}.${var.domain}"  # Subdominio para el bucket S3
  type    = "CNAME"
  ttl     = 300
  records = [aws_s3_bucket.cms_images_bucket-lab4.bucket_regional_domain_name]
}

# Registro CNAME para Redis
resource "aws_route53_record" "redis_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = "redis.${var.project}.${var.domain}"  # Subdominio para Redis
  type    = "CNAME"
  ttl     = 300
  records = [aws_elasticache_replication_group.redis-lab4.primary_endpoint_address]
}


# Registro A para el subdominio principal 
resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id
  name    = var.subdomain
  type    = "A"
  alias {
    name                   = aws_lb.alb-lab4.dns_name
    zone_id                = aws_lb.alb-lab4.zone_id
    evaluate_target_health = true
  }
}

# Registro de Route 53 a CloudFront
resource "aws_route53_record" "cdn_record" {
  zone_id = aws_route53_zone.internal-zone-lab4.zone_id  
  name    = "${var.project}-${var.environment}.${var.domain}"  # Alias del dominio de CloudFront
  type    = "A"

  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

