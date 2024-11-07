data "aws_cloudfront_cache_policy" "cache-disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "request-all-viewer" {
  name = "Managed-AllViewer"
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.4.0"

  aliases             = ["${var.project}-${var.environment}.${var.domain}"]
  comment             = "CloudFront ${var.project}-${var.environment}"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  http_version        = "http2"

  create_origin_access_identity = true

  origin = {
    alb = {
      domain_name = aws_lb.alb-lab4.dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id         = "alb"
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache-disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.request-all-viewer.id
    use_forwarded_values     = false
    compress                 = true
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "DELETE", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
  }

  viewer_certificate = {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
