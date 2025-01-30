output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "db_endpoint" {
  description = "Database connection endpoint"
  value       = module.database.db_instance_endpoint
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.storage.bucket_id
}