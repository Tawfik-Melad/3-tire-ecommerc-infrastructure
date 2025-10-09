variable "name_prefix" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_sg_id" {
  description = "Security group ID for public EC2 instances"
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for private EC2 instances"
  type        = string
}

variable "instance_profile" {
  description = "IAM instance profile to attach to EC2 instance"
  type        = string
}
