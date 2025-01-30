resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-database"
  allocated_storage    = var.allocated_storage
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "15.10"
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "${var.environment}-database"
    Environment = var.environment
  }
}