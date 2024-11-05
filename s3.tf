resource "aws_s3_bucket" "cms_images_bucket" {
  bucket = "cms-images-lab4" 
  object_lock_enabled = true

  tags = {
    Name        = "CMS Images Bucket"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

resource "aws_s3_bucket_policy" "cms_images_bucket_policy" {
  bucket = aws_s3_bucket.cms_images_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.cms_images_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = aws_iam_role.ec2_s3_access_role.arn
          }
        }
      }
    ]
  })
}
