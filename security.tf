resource "aws_security_group" "ec2-sg-lab4" {
  name        = "ec2-sg-lab4"
  description = "Security group for ec2 with HTTPS, PostgreSQL, and cache access"
  vpc_id      = module.vpc.vpc_id

  # Allow incoming HTTP traffic 
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [ aws_security_group.alb-sg-lab4.id ]
  }

  # Allow incoming PostgreSQL traffic 
  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [ aws_security_group.rds-sg-lab4.id ]
  }

  # Allow incoming cache traffic 
  ingress {
    description = "Cache Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.cache-sg-lab4.id]
  }

  ingress {
    description = "Cache Memcached"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.cache-sg-lab4.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-lab4"
    Environment = var.environment
    Owner = "gabriela"
    Project = "lab4"
  }
}

## SG para Balanceador

resource "aws_security_group" "alb-sg-lab4" {
  name        = "alb-sg-lab4"
  description = "Security group for ALB allowing HTTPS traffic from Auto Scaling group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow HTTPS from Auto Scaling group"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "Allow HTTPS from Auto Scaling group"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-lab4"
    Environment = var.environment
    Owner = "gabriela"
    Project = "lab4"
  }
}

## SG para RDS

resource "aws_security_group" "rds-sg-lab4" {
  name        = "rds-sg-lab4"
  description = "Security group for RDS allowing PostgreSQL traffic from Auto Scaling group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow PostgreSQL from Auto Scaling group"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-lab4"
    Environment = var.environment
    Owner = "gabriela"
    Project = "lab4"
  }
}

## SG para ambas Cache


resource "aws_security_group" "cache-sg-lab4" {
  name        = "cache-sg-lab4"
  description = "Security group for cache allowing access from Auto Scaling group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow Redis traffic from Auto Scaling group"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
  }
 
  ingress {
    description      = "Allow Memcached traffic from Auto Scaling group"
    from_port        = 11211
    to_port          = 11211
    protocol         = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cache-sg-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}
