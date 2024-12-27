variable "ami_id" {
  description = "ID de la AMI"
  type        = string
}

variable "instance_type" {
  description = "El tipo de instancia EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se lanzará la instancia EC2"
  type        = string
}

variable "region" {
  description = "La región de AWS"
  type        = string
}
