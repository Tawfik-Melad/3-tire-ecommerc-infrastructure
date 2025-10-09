module "vpc" {
  source      = "./modules/vpc"
  name_prefix = var.name_prefix
  vpc_cidr    = var.vpc_cidr
}

module "public_subnets" {
  source              = "./modules/public-subnets"
  name_prefix         = var.name_prefix
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "private_backend_subnets" {
  source               = "./modules/private-subnets"
  name_prefix          = "${var.name_prefix} - backend "
  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = var.private_backend_subnet_cidrs
  nat_gateway_id       = module.public_subnets.nat_gateway_id
  availability_zones   = var.availability_zones
}


module "private_database_subnet_1" {
  source               = "./modules/private-subnets"
  name_prefix          = "${var.name_prefix} - database_1 "
  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = var.private_database1_subnet_cidrs
  nat_gateway_id       = module.public_subnets.nat_gateway_id
  availability_zones   = var.availability_zones
}


module "private_database_subnet_2" {
  source               = "./modules/private-subnets"
  name_prefix          = "${var.name_prefix} - database_2 "
  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = var.private_database2_subnet_cidrs
  nat_gateway_id       = module.public_subnets.nat_gateway_id
  availability_zones   = var.availability_zones2
}



module "security" {
  source      = "./modules/security"
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id
  my_ip       = var.my_ip
}

module "iam" {
  source = "./modules/iam"
}


module "ec2" {
  source             = "./modules/ec2"
  name_prefix        = var.name_prefix
  public_subnet_id  = module.public_subnets.public_subnet_id
  private_subnet_id = module.private_backend_subnets.private_subnet_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  instance_profile = module.iam.ec2_instance_profile_name
  public_sg_id    = module.security.public_ec2_sg
  private_sg_id   = module.security.private_ec2_sg
}


module "rdb" {
  source = "./modules/rdb"

  subnet_ids             = [module.private_database_subnet_1.private_subnet_id,module.private_database_subnet_2.private_subnet_id]     # Private subnets from your VPC module
  vpc_security_group_ids = [module.security.rdb_sg_id]    # SG from your security module

  db_identifier = "django-rdb"
  db_name       = "djangoEcommercRDB"      # Set in terraform.tfvars
  db_username   = var.db_username   # Set in terraform.tfvars
  db_password   = var.db_password   # Set in terraform.tfvars
}


module "s3_static" {
  source      = "./modules/s3"
  bucket_name = "django-ecommerc-static-bucket-2025-tawfik"
  environment = "dev"
}
