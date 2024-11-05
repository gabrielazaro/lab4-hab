#aqui va el route 53
resource "aws_route53_zone" "internal_zone" {
  name = "laboratorio4-vpc.internal.com"  # Ajusta según el dominio de tu VPC
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "internal_alb_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "laboratorio4-vpc.internal.com"  # Subdominio para el ALB interno
  type    = "A"
  alias {
    name                   = aws_lb.alb-internal.dns_name
    zone_id                = aws_lb.alb-internal.zone_id
    evaluate_target_health = true
  }
}

/// add cache, rds, s3 y efs 