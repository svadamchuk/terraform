variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size of the auto scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the auto scaling group"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
  default     = ""
}

variable "website_content" {
  description = "Content of the index.html file"
  type        = string
}
