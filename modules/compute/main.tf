# modules/compute/main.tf

resource "aws_launch_template" "web" {
  name_prefix   = "${var.environment}-web-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "IAC_portfolio"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
                # System update
                yum update -y

                # Install httpd
                yum install httpd -y

                # Start httpd
                systemctl start httpd

                # Enable httpd on boot
                systemctl enable httpd

                # Main page
                  cat << 'INDEXEOF' > /var/www/html/index.html
                  ${var.website_content}
                  INDEXEOF

                # Set permissions
                chmod 644 /var/www/html/index.html
                chown apache:apache /var/www/html/index.html
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
