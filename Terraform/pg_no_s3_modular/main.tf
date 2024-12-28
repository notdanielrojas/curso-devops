
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.0"
}


terraform {
  backend "s3" {
    bucket         = "bkt-terraform-backup-tfstate"
    key            = "cursodevops/terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "db-dynamo-terraform-backup-tfstate"
    encrypt        = true
    profile = "desafiolatam"
  }
}

# Proveedor de AWS
provider "aws" {
  region = var.aws_region
  profile = "desafiolatam"
}






locals {
  instance_name = "ec2-instance-curso-devops"
  internet_gw_name = "igw-curso-devops"
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

resource "aws_internet_gateway" "gw_curso_devops" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = local.internet_gw_name
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "route_internet_access" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw_curso_devops.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.public_route_table.id
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
  depends_on    = [aws_vpc.main_vpc,aws_security_group.instance_sg]
  ami           = "ami-0ca9fb66e076a6e32"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = var.key_name
  tags = {
    Name = local.instance_name
  }

  associate_public_ip_address = true

  security_groups = [aws_security_group.instance_sg.id]

}

# Definición de un grupo de seguridad para la instancia EC2
resource "aws_security_group" "instance_sg" {
  name        = "sgp-terraform-curso-devops"
  description = "Security group for EC2 instance"
  vpc_id = aws_vpc.main_vpc.id

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
output "s3_bucket" {
  value = aws_s3_bucket.example_bucket.arn
}

# Salida del ARN VPC
output "vpc_id" {
  value = aws_vpc.main_vpc.arn
}

# Salida del ARN SubNet
output "subnet_id" {
  value = aws_subnet.main_subnet.arn
}
