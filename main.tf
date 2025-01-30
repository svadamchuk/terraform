# Networking module
module "networking" {
  source = "./modules/networking"

  environment        = var.environment
  vpc_cidr          = "10.0.0.0/16"
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
}

# Security module
module "security" {
  source = "./modules/security"

  environment = var.environment
  vpc_id     = module.networking.vpc_id
  allowed_cidr_blocks = ["0.0.0.0/0"]
}

# Compute module
module "compute" {
  source = "./modules/compute"

  environment       = var.environment
  ami_id           = "ami-0669b163befffbdfc"  # Amazon Linux 2 AMI ID для eu-central-1
  instance_type    = "t2.micro"
  security_group_id = module.security.web_security_group_id
  subnet_ids       = module.networking.private_subnet_ids
  min_size         = 2
  max_size         = 4
  target_group_arn = ""  # Если будете использовать ALB, добавьте ARN
}

# Database module
module "database" {
  source = "./modules/database"

  environment       = var.environment
  allocated_storage = 20
  instance_class    = "db.t3.micro"
  db_name          = "myappdb"
  db_username      = "dbadmin"
  db_password      = var.db_password
  security_group_id = module.security.db_security_group_id
  subnet_ids       = module.networking.private_subnet_ids
}

# Storage module
module "storage" {
  source = "./modules/storage"

  environment     = var.environment
  bucket_name     = "my-app-storage"
  versioning_enabled = true
}