output "asg_name" {
  description = "Name of the auto scaling group"
  value       = aws_autoscaling_group.web.name
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.web.id
}