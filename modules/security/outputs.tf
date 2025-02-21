output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db.id
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
