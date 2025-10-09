variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "my_ip" {
  description = "Your public IP for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Change to your IP for more security
}
