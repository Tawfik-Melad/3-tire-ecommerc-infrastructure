# SG for public EC2s
resource "aws_security_group" "public_ec2" {
  name        = "${var.name_prefix}-public-ec2-sg"
  description = "Allow SSH + HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-public-ec2-sg" }
}

# SG for private EC2s
resource "aws_security_group" "private_ec2" {
  name        = "${var.name_prefix}-private-ec2-sg"
  description = "Allow HTTP from private LB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from reverse proxy to django container"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-private-ec2-sg" }
}

# SG for RDS

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}


resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow Postgres from private_sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2.id]
  }

  # Allow laptop
  ingress {
    description = "Postgres from my laptop"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
