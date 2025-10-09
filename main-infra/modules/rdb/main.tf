# 🔹 Create a subnet group for the DB
# RDS needs to know which subnets it can use inside your VPC.
# Best practice = use private subnets so DB is not publicly exposed.
resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids   # IDs of private subnets where DB will run

  tags = {
    Name = "rds-subnet-group"
  }
}

# 🔹 Create the actual RDS instance
resource "aws_db_instance" "this" {
  identifier              = var.db_identifier       # Unique name for DB in AWS console
  db_name                    = var.db_name             # Name of initial DB to create (optional)
  engine                  = var.db_engine           # "postgres" or "mysql"
  engine_version          = var.db_engine_version   # Example: "15.5" for PostgreSQL
  instance_class          = var.db_instance_class   # Type of EC2 under the hood (Free Tier = db.t3.micro)
  allocated_storage       = var.db_allocated_storage # Storage in GB (minimum 20GB for Free Tier)
  max_allocated_storage   = var.db_max_storage      # Max storage if autoscaling is enabled
  username                = var.db_username         # Master admin username
  password                = var.db_password         # Master admin password (sensitive)
  db_subnet_group_name    = aws_db_subnet_group.this.name # Attach to the private subnet group
  vpc_security_group_ids  = var.vpc_security_group_ids    # SG that allows only app EC2 to connect
  publicly_accessible     = false                   # ✅ Keep DB private (no internet)
  skip_final_snapshot     = true                    # ✅ Don’t force snapshot on destroy (dev only)
  deletion_protection     = false                   # ✅ Allow destroy (disable in prod!)
}
