resource "aws_s3_bucket" "cms_images_bucket-lab4" {
  bucket = "cms-images-lab4" 
  object_lock_enabled = true

  tags = {
    Name        = "CMS Images Bucket"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

resource "aws_s3_object" "image_1" {
  bucket = aws_s3_bucket.cms_images_bucket-lab4.bucket
  key    = "image1.jpg"
  source = "aws-image.jpg"  # Ruta local de la imagen
  acl    = "private"
}

resource "aws_s3_object" "image_2" {
  bucket = aws_s3_bucket.cms_images_bucket-lab4.bucket
  key    = "image2.jpg"
  source = "banner-hackaboss.png"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "cms_images_bucket_policy" {
  bucket = aws_s3_bucket.cms_images_bucket-lab4.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.cms_images_bucket-lab4.arn}/*",
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = aws_iam_role.ec2-access-role.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_metric" "cms_bucket_metrics" {
  bucket = aws_s3_bucket.cms_images_bucket-lab4.id
  name   = "EntireBucket"
}
