variable "environment" {
  description = "Environment name"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}