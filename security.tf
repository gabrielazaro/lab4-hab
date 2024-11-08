resource "aws_security_group" "ec2-sg-lab4" {
  name        = "ec2-sg-lab4"
  description = "Security group for EC2 with HTTP, PostgreSQL, and cache access"
  vpc_id      = module.vpc.vpc_id
 
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-lab4.id]
  }

  ingress {
    description     = "PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.rds-sg-lab4.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-sg-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

## SG para RDS

resource "aws_security_group" "rds-sg-lab4" {
  name        = "rds-sg-lab4"
  description = "Security group for RDS allowing PostgreSQL traffic from Auto Scaling group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow PostgreSQL from Auto Scaling group"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-sg-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

## SG para ambas Cache


resource "aws_security_group" "cache-sg-lab4" {
  name        = "cache-sg-lab4"
  description = "Security group cache"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow Redis traffic from Auto Scaling group"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Allow Memcached traffic from Auto Scaling group"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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


#EFS

resource "aws_security_group" "efs-sg-lab4" {
  name        = "efs-sg-lab4"
  description = "Security group for EFS allowing NFS access from EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow NFS from EC2"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [ aws_security_group.ec2-sg-lab4.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "efs-sg-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}
