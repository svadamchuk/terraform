variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# variable "allowed_cidr_blocks" {
#   description = "List of CIDR blocks allowed to access the resources"
#   type        = list(string)
#   default     = ["0.0.0.0/0"]
# }
