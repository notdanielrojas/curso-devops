variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "El bloque CIDR para la subred"
  type        = string
}

variable "region" {
  description = "La región de AWS"
  type        = string
}
