
data "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}


data "aws_subnet" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["subnet-curso-devops-private"]
  }
}