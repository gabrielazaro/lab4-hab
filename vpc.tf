resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name  = "VPC TERRAFORM"
    ENV   = "TEST"
    OWNER = "GEZR"
  }
}