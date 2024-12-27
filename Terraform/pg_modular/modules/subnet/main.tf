resource "aws_subnet" "main_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.region == "us-east-1" ? "us-east-2a" : "us-east-1a"
  map_public_ip_on_launch = true
}
