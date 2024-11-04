module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=5.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = var.availability_zones
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Environment = var.environment
    Owner = "gabriela"
    Project = "lab4"
  }
}

resource "aws_subnet" "rds-subnet-1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.5.0/24"  
  availability_zone = "us-east-1a"   

  tags = {
    Name        = "rds-subnet-1"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

resource "aws_subnet" "rds-subnet-2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.6.0/24"  
  availability_zone = "us-east-1b"   

  tags = {
    Name        = "rds-subnet-2"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}