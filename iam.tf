#S3
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "EC2S3AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_s3_access_policy" {
  name = "EC2S3AccessPolicy"
  description = "Policy to allow EC2 instances to access the CMS S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.cms_images_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}
