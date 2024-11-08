#S3


resource "aws_iam_role" "ec2-access-role" {
  name = "EC2-access-role"
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

resource "aws_iam_policy" "ec2_s3_policy" {
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
        Resource = "${aws_s3_bucket.cms_images_bucket-lab4.arn}/*"
      }
    ]
  })
}

/* Me hubiese encantado aplicarlo pero no hubo tiempo.
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "EC2SecretsAccessPolicy"
  description = "Policy to allow EC2 instances to access specific secrets in Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "secretsmanager:GetSecretValue",
        Resource = [
          aws_secretsmanager_secret.aws_credentials.arn,
          aws_secretsmanager_secret.rds_password.arn
        ]
      }
    ]
  })
}
*/ 
resource "aws_iam_policy" "efs_access" {
  name        = "WordPress-EFS-Access"
  description = "Permite acceso a EFS para almacenamiento compartido"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess"
        ]
        Resource = aws_efs_file_system.efs-lab4.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy_attachment" {
  role       = aws_iam_role.ec2-access-role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_access_policy" {
  role      = aws_iam_role.ec2-access-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "efs_policy_attach" {
  policy_arn = aws_iam_policy.efs_access.arn
  role       = aws_iam_role.ec2-access-role.name
}
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2-access-role.name
}