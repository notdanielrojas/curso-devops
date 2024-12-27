# Salidas
output "instance_id" {
  value = module.ec2.instance_id
}

output "vpc" {
  value = data.aws_vpc.vpc.id
}

output "subnet" {
  value = data.aws_subnet.vpc_subnets.id
}


output "ami_ec2" {
  value = data.aws_ami.latest_amazon_linux.id
}