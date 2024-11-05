resource "aws_lb" "alb-internal" {
  name               = "alb-internal"
  internal           = true  # Define ALB como interno
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg-lab4.id]
  subnets            = module.vpc.private_subnets

  tags = {
    Name = "alb-internal"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "internal_alb_target_group" {
  name        = "internal-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"  

  health_check {
    enabled             = true
    path                = "/salud"  # Ruta para verificar estado, ajústalo según tu app
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "InternalALBTargetGroup"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb-internal.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.internal_alb_target_group.arn
  }
}
