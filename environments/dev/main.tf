module "networking" {
  source = "../../modules/networking"

  environment        = "dev"
  vpc_cidr          = "10.0.0.0/16"
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
}

module "security" {
  source = "../../modules/security"

  environment = "dev"
  vpc_id     = module.networking.vpc_id
}

module "compute" {
  source = "../../modules/compute"

  environment       = "dev"
  ami_id           = "ami-0c55b159cbfafe1f0"
  instance_type    = "t2.micro"
  security_group_id = module.security.web_security_group_id
  subnet_ids       = module.networking.private_subnet_ids
  min_size         = 2
  max_size         = 4
}

module "database" {
  source = "../../modules/database"

  environment       = "dev"
  allocated_storage = 20
  instance_class    = "db.t3.micro"
  db_name          = "myapp"
  db_username      = "admin"
  db_password      = var.db_password
  security_group_id = module.security.db_security_group_id
  subnet_ids       = module.networking.private_subnet_ids
}

module "storage" {
  source = "../../modules/storage"

  environment  = "dev"
  bucket_name = "terraform-state-bucket-owqc5vdf"
}