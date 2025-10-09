data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu official account)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Upload SSH key
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/terraform-key.pub")
}

# Public EC2 (Nginx reverse proxy)
resource "aws_instance" "public" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform_key.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true
  iam_instance_profile       = var.instance_profile
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              # Ansible will configure Nginx later
              EOF

  tags = { Name = "${var.name_prefix}-public" }
}

# Private EC2 (Django backend)
resource "aws_instance" "private" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform_key.key_name
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_sg_id]
  associate_public_ip_address = false
  iam_instance_profile       = var.instance_profile
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              # Ansible will handle Django container setup
              EOF

  tags = { Name = "${var.name_prefix}-private-backend" }
}
