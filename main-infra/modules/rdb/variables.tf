# Which subnets DB will live in (should be private subnets)
variable "subnet_ids" {
  description = " private subnet IDs for the DB subnet group"
  type        = list(string)
}

# Security groups allowed to access DB (e.g. EC2 app server SG)
variable "vpc_security_group_ids" {
  description = "Security group IDs to attach to the DB instance"
  type        = list(string)
}

# Unique DB instance name
variable "db_identifier" {
  description = "Unique name for the DB instance"
  type        = string
  default     = "django-rds"
}

# Database engine
variable "db_engine" {
  description = "Database engine (postgres/mysql)"
  type        = string
  default     = "postgres"   # ✅ Recommended for Django
}

# Database engine version
variable "db_engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "12"       # ✅ PostgreSQL  (Free Tier eligible)
}

# Instance size (EC2 type for DB)
variable "db_instance_class" {
  description = "Instance type (Free Tier = db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

# Initial storage
variable "db_allocated_storage" {
  description = "Initial storage in GB (min 20GB for Free Tier)"
  type        = number
  default     = 20
}

# Max storage for autoscaling
variable "db_max_storage" {
  description = "Max storage autoscaling (keep small in dev)"
  type        = number
  default     = 20
}

# Master admin username
variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "django_admin"
}

# Master admin password
variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "django_ecommerc_db"
}