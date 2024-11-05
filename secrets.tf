/*resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials_lab4"  
  description = "Credenciales de la base de datos para la aplicación lab4"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username  
    password = var.db_password  
  })
}
*/