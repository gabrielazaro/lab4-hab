terraform {
  required_providers {
    aws {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "project-lab4" {
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "state-bucket-lab4"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}