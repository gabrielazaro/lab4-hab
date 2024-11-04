resource "aws_db_instance" "postgres_db" {
  identifier              = "db-lab4"
  engine                 = "postgres"
  engine_version         = "16.3"  # Cambia a la versión deseada de PostgreSQL
  instance_class         = "db.t4g.micro"
  allocated_storage       = 20
  db_name                = "db_laboratorio"
  username               = "admin"
  password               = "123456789"
  /*username = var.db_username
  password = var.db_password*/ 
  port                   = 5432
  iam_database_authentication_enabled = true

  vpc_security_group_ids = [
    aws_security_group.rds-sg-lab4.id
  ]

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name 
  multi_az               = true
  storage_type           = "gp3"
  backup_retention_period = 7 
  maintenance_window     = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier = "db-lab4-final-snapshot" 
  deletion_protection     = true 

  tags = {
    Name        = "db-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [ aws_subnet.rds-subnet-1.id, aws_subnet.rds-subnet-2.id]

  tags = {
    Name        = "RDS Subnet Group"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}
