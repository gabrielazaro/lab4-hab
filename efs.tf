resource "aws_efs_file_system" "efs-lab4" {
  creation_token = "my-efs"
  encrypted      = true
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name = "lab4-efs"
    Environment = var.environment
    Owner = "gabriela"
    Project = "lab4"
  }
}

resource "aws_efs_mount_target" "mt_az1" {
  file_system_id = aws_efs_file_system.efs-lab4.id
  subnet_id      = module.vpc.public_subnets[0]   # Primer subnet (AZ 1)
  security_groups = [aws_security_group.efs-sg-lab4.id]
}

resource "aws_efs_mount_target" "mt_az2" {
  file_system_id = aws_efs_file_system.efs-lab4.id
  subnet_id      = module.vpc.public_subnets[1]   # Segundo subnet (AZ 2)
  security_groups = [aws_security_group.efs-sg-lab4.id]
}
