# Zona pública
resource "aws_route53_zone" "public_zone" {
  name = var.domain  # "masterinterraform.com"
  
  tags = {
    Name        = "${var.domain}-public-zone"
    Environment = var.environment
    Project     = var.project
  }
}

# Registro A para el ALB en la zona pública
resource "aws_route53_record" "alb_public" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "wordpress.${var.domain}"  # wordpress.masterinterraform.com
  type    = "A"

  alias {
    name                   = aws_lb.alb-lab4.dns_name
    zone_id                = aws_lb.alb-lab4.zone_id
    evaluate_target_health = true
  }
}

# Zona privada para servicios internos
resource "aws_route53_zone" "private_zone" {
  name = "internal.${var.domain}"  # internal.masterinterraform.com
  
  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name        = "${var.domain}-private-zone"
    Environment = var.environment
    Project     = var.project
  }
}

# Registros internos para servicios
resource "aws_route53_record" "rds_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "rds.internal.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.rds-lab4.endpoint]
}

resource "aws_route53_record" "redis_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "redis.internal.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_replication_group.redis-lab4.primary_endpoint_address]
}

resource "aws_route53_record" "efs_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "efs.internal.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_efs_file_system.efs-lab4.id}.efs.${var.aws_region}.amazonaws.com"]
}

