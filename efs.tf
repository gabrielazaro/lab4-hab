resource "aws_efs_file_system" "efs-lab4" {
  creation_token = "my-efs"
  encrypted      = true
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name = "lab4-efs"
    Environment = var.environment
    Owner = "gabriela"
    Project = var.project
  }
}

resource "aws_efs_mount_target" "efs_mount_targets" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.efs-lab4.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs-sg-lab4.id]
}