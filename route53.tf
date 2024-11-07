#aqui va el route 53
resource "aws_route53_zone" "internal_zone" {
  name = "laboratorio4-vpc.internal"  # Ajusta según el dominio de tu VPC
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "internal_alb_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "alb.laboratorio4-vpc.internal"  # Subdominio para el ALB interno
  type    = "A"
  alias {
    name                   = aws_lb.alb-lab4.dns_name
    zone_id                = aws_lb.alb-lab4.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rds_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "rds.laboratorio4.internal"  # Subdominio para el RDS
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.rds-lab4.endpoint]  
}

resource "aws_route53_record" "efs_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "efs.laboratorio4.internal"  # Nombre del subdominio para EFS
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_efs_file_system.efs-lab4.id}.efs.${var.aws_region}.amazonaws.com"]
}


resource "aws_route53_record" "s3_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "s3.laboratorio4.internal"  # Nombre de subdominio para el bucket S3
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_s3_bucket.cms_images_bucket-lab4.bucket_regional_domain_name}"]
}

resource "aws_route53_record" "redis_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "redis.laboratorio4.internal"  
  type    = "CNAME"
  ttl     = 300
  records = [aws_elasticache_replication_group.redis-lab4.primary_endpoint_address]
}

