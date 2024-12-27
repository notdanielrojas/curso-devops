# Proveedor de AWS
provider "aws" {
  region = var.aws_region
  profile = "desafiolatam"
}
locals {
  instance_name = "ec2-instance-curso-devops"
  region        = "us-east-1"
}

# Obtención de una AMI existente utilizando Data
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filters = {
    name = "amzn2-ami-hvm-*-x86_64-gp2"
  }
}

# Creación de la VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Creación de una Subred en la VPC
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.subnet_availability_zone
  map_public_ip_on_launch = true
}

# Creación de un Bucket S3
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.s3_bucket_name
  lifecycle {
    prevent_destroy = false
  }
}

# Creación de una instancia EC2 usando la AMI obtenida
resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = var.key_name
  tags = {
    Name = local.instance_name
  }

  associate_public_ip_address = true

  security_groups = [aws_security_group.instance_sg.name]

  monitoring {
    enabled = true
  }
}

# Definición de un grupo de seguridad para la instancia EC2
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Salida del ID de la instancia EC2 creada
output "instance_id" {
  value = aws_instance.example_instance.id
}

# Salida de la URL del bucket S3
output "s3_bucket_url" {
  value = aws_s3_bucket.example_bucket.bucket
}
