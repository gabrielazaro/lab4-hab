data "aws_cloudfront_cache_policy" "cache-disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "request-all-viewer" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_cache_policy" "cache_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "request_all_viewer" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project}-${var.environment} CloudFront Distribution"
  price_class         = "PriceClass_100"
  http_version        = "http2"

  origin {
    domain_name = aws_lb.alb-lab4.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443  
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]  
    }
  }

  default_cache_behavior {
    target_origin_id         = "alb-origin"
    viewer_protocol_policy   = "allow-all"
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.request_all_viewer.id
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "DELETE", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    compress                 = true
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}