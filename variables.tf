variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "Master password for RDS instance"
  type        = string
  sensitive   = true
}

variable "environment_configs" {
  description = "Environment specific configurations"
  type = map(object({
    instance_type     = string
    min_size         = number
    max_size         = number
    db_instance_class = string
  }))
  default = {
    dev = {
      instance_type     = "t2.micro"
      min_size         = 1
      max_size         = 2
      db_instance_class = "db.t3.micro"
    }
    staging = {
      instance_type     = "t2.small"
      min_size         = 2
      max_size         = 4
      db_instance_class = "db.t3.small"
    }
    prod = {
      instance_type     = "t2.medium"
      min_size         = 3
      max_size         = 6
      db_instance_class = "db.t3.medium"
    }
  }
}

variable "dev_account_id" {
  description = "AWS Account ID for Development environment"
  type        = string
}

variable "staging_account_id" {
  description = "AWS Account ID for Staging environment"
  type        = string
}

variable "prod_account_id" {
  description = "AWS Account ID for Production environment"
  type        = string
}