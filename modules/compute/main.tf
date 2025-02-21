# modules/compute/main.tf

resource "aws_launch_template" "web" {
  name_prefix   = "${var.environment}-web-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash

              # Включаем логирование установки
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              echo "Starting user_data script..."

              # Update system
              yum update -y
              echo "System updated"

              # Install Apache and additional tools
              yum install -y httpd curl
              echo "Apache installed"

              # Create health check page
              echo "OK" > /var/www/html/health
              echo "Health check page created"

              # Create website directories
              mkdir -p /var/www/html
              echo "Website directories created"

              # Copy website files
              cat << 'INDEXEOF' > /var/www/html/index.html
              ${var.website_content}
              INDEXEOF
              echo "Website files copied"

              # Set correct permissions
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html
              echo "Permissions set"

              # Start and enable Apache
              systemctl start httpd
              systemctl enable httpd
              echo "Apache started and enabled"

              # Verify Apache is running
              if systemctl is-active httpd; then
                echo "Apache is running"
              else
                echo "Apache failed to start"
                systemctl status httpd
              fi

              # Test local access
              echo "Testing local access..."
              curl -v http://localhost/health

              # Check Apache error log
              echo "Apache error log:"
              tail -n 20 /var/log/httpd/error_log

              # Check Apache access log
              echo "Apache access log:"
              tail -n 20 /var/log/httpd/access_log

              echo "User data script completed"
              EOF
  )

  tags = {
    Name        = "${var.environment}-web-template"
    Environment = var.environment
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity          = var.min_size
  max_size                  = var.max_size
  min_size                  = var.min_size
  target_group_arns         = [var.target_group_arn]
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-web-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Добавляем автомасштабирование
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_description = "Scale up if CPU > 80% for 10 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.environment}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.environment}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_description = "Scale down if CPU < 20% for 10 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
