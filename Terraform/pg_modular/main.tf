# Proveedor de AWS
provider "aws" {
  region = local.region
  profile = "desafiolatam"
}

/*
# Módulo VPC
module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
  region     = var.aws_region
}

# Módulo Subnet
module "subnet" {
  source             = "./modules/subnet"
  vpc_id             = module.vpc.vpc_id
  subnet_cidr_block = var.subnet_cidr_block
  region            = var.aws_region
}

 */

# Módulo EC2
module "ec2" {
  source       = "./modules/ec2"
  ami_id       = "ami-0ca9fb66e076a6e32"
  instance_type = var.instance_type
  subnet_id    = data.aws_subnet.vpc_subnets.id
  region       = var.aws_region
}

