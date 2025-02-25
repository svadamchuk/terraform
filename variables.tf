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

variable "environment_configs" {
  description = "Environment specific configurations"
  type = map(object({
    instance_type     = string
    min_size          = number
    max_size          = number
    db_instance_class = string
  }))
  default = {
    default = {
      instance_type     = "t2.micro"
      min_size          = 1
      max_size          = 2
      db_instance_class = "db.t3.micro"
    }
    dev = {
      instance_type     = "t2.micro"
      min_size          = 1
      max_size          = 2
      db_instance_class = "db.t3.micro"
    }
    staging = {
      instance_type     = "t2.small"
      min_size          = 2
      max_size          = 4
      db_instance_class = "db.t3.small"
    }
    prod = {
      instance_type     = "t2.medium"
      min_size          = 3
      max_size          = 6
      db_instance_class = "db.t3.medium"
    }
  }
}

variable "environment_name" {
  description = "Environment name to use"
  type        = string
  default     = "default"
}
