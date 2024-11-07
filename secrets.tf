
# Secret for AWS credentials
resource "aws_secretsmanager_secret" "aws_credentials" {
  name = "aws-credentials"
}

resource "aws_secretsmanager_secret_version" "aws_credentials_version" {
  secret_id = aws_secretsmanager_secret.aws_credentials.id
  secret_string = jsonencode({
    access_key = var.access_key
    secret_key = var.secret_key
  })
}

# Secret for RDS credentials
resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds-password"
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    password = var.rds_password
  })
}
