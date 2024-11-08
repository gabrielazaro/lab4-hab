resource "aws_lb" "alb-lab4" {
  name               = "alb-lab4"
  internal           = false  
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg-lab4.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "alb-lab4"
    Environment = var.environment
    Project = var.project
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"  

  health_check {
    enabled             = true
    path                = "/salud"  
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ALBTargetGroup"
    Environment = var.environment
    Project = var.project
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb-lab4.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_security_group" "alb-sg-lab4" {
  name        = "alb-sg-lab4"
  description = "Security group for ALB allowing HTTPS traffic from Auto Scaling group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTPS from Auto Scaling group"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}


resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period             = "300"
  statistic          = "Sum"
  threshold          = "10"
  alarm_description  = "This metric monitors ALB 5XX errors"
  
  dimensions = {
    LoadBalancer = aws_lb.alb-lab4.arn_suffix
  }
}
