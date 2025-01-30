resource "aws_launch_template" "web" {
  name_prefix   = "${var.environment}-web-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [var.security_group_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  )

  tags = {
    Name        = "${var.environment}-web-template"
    Environment = var.environment
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = var.min_size
  max_size           = var.max_size
  min_size           = var.min_size
  target_group_arns  = [var.target_group_arn]
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value              = "${var.environment}-web-asg"
    propagate_at_launch = true
  }
}