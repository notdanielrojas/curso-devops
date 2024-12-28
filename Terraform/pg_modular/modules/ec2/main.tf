# Creación de una instancia EC2 usando la AMI obtenida
resource "aws_instance" "example_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  tags = {
    Name = var.instance_name
  }

  associate_public_ip_address = true

  security_groups = [var.sg_id]

}