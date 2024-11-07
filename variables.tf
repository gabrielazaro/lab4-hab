#SSH

variable "access_key" {
    description = "access_key"
    type = string
    sensitive = true
}

variable "secret_key" {
    description = "secret_key"
    type = string
    sensitive = true
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

#VPC

variable "vpc_name" {
  description = "Vpc lab4"
  type        = string
  default     = "vpc-lab4"
}

variable "vpc_cidr" {
  description = "Bloque CIDR para el VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad donde crear subredes"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Lista de bloques CIDR para las subredes públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Lista de bloques CIDR para las subredes privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_nat_gateway" {
  description = "Indica si se debe habilitar el NAT Gateway para acceso a internet en subredes privadas"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "test"
}

variable "project" {
  description = "Proyecto en curso"
  type        = string
  default     = "lab4"
}

variable "domain" {
  description = "Dominio"
  type = string
  default = "masterinterraform.com"
}

variable "subdomain" {
  default = "www"
 description = "Subdominio"
  type  = string
}

variable "rds_password" {}
