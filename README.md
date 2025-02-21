# AWS Infrastructure as Code Project with Terraform

This project implements a complete AWS infrastructure using Terraform, featuring a scalable web application architecture with automated deployment through GitHub Actions.

## Architecture Overview

### Network Layer
- VPC with public and private subnets
- Internet Gateway for public subnets
- NAT Gateway for private subnet internet access
- Route tables for both subnet types

### Compute Layer
- Auto Scaling Group (ASG) with EC2 instances
- Launch Template with Amazon Linux 2023
- Apache web server with custom website
- Private subnet placement for enhanced security

### Load Balancing
- Application Load Balancer (ALB) in public subnets
- Target Groups with health checks
- SSL/TLS support (optional)

### Security
- Security Groups for all components
- Network ACLs
- IAM roles and policies
- Encrypted data in transit

## Prerequisites

### Local Development Environment
- Terraform >= 1.0.0
- AWS CLI >= 2.0.0
- Git
- GitHub account with repository access
- AWS account with administrative access

### AWS Requirements
- AWS account with appropriate permissions
- AWS access key and secret key
- Key pair named "IAC_portfolio" in your AWS account

## Project Structure
```
.
├── backend-setup/
│   ├── main.tf
│   └── outputs.tf
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── site/
│   └── index.html
├── .github/
│   └── workflows/
│       └── terraform.yml
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── README.md
```

## Initial Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Install backend infrastructure:
```bash
# Initialize backend infrastructure
chmod +x init-backend.sh
./init-backend.sh
```

3. Configure AWS credentials:
```bash
aws configure
```

4. Initialize Terraform:
```bash
terraform init -backend-config=backend.hcl
```

## Environment Management

The project uses Terraform workspaces for environment management:

1. Create and switch workspaces:
```bash
# Create dev workspace
terraform workspace new dev

# Create prod workspace
terraform workspace new prod

# List workspaces
terraform workspace list

# Switch workspace
terraform workspace select dev
```

2. Environment-specific configurations are maintained in variables.tf:
```hcl
variable "environment_configs" {
  type = map(object({
    instance_type     = string
    min_size         = number
    max_size         = number
    db_instance_class = string
  }))
  default = {
    dev = {
      instance_type     = "t2.micro"
      min_size         = 1
      max_size         = 2
      db_instance_class = "db.t3.micro"
    }
    prod = {
      instance_type     = "t2.medium"
      min_size         = 2
      max_size         = 4
      db_instance_class = "db.t3.small"
    }
  }
}
```

## Deployment

### Manual Deployment
```bash
# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Automated Deployment (GitHub Actions)
The project includes CI/CD pipeline with GitHub Actions:
- Automatic planning on pull requests
- Plan output as PR comment
- Automatic deployment to dev environment
- Manual approval for production deployment

## Web Application
The project deploys a web application that:
- Runs on Apache web server
- Displays instance metadata
- Includes health check endpoint
- Auto scales based on demand

## Security Features

### Network Security
- Private subnets for EC2 instances
- Public access only through ALB
- Security group rules for minimal access

### Access Management
- IAM roles for EC2 instances
- Separate security groups for each component
- Key pair authentication for EC2

## Monitoring

### Health Checks
- ALB health checks
- ASG instance health monitoring
- CloudWatch metrics

### Scaling
- Auto Scaling based on CPU utilization
- Configurable min/max instances
- Scale in/out policies

## Custom Website Deployment
To modify the website content:
1. Edit files in the `site/` directory
2. Commit changes
3. Deploy through normal workflow

## Troubleshooting

### Common Issues

1. Backend initialization fails:
```bash
# Check S3 bucket accessibility
aws s3 ls s3://your-terraform-state-bucket

# Verify DynamoDB table
aws dynamodb describe-table --table-name terraform-state-locks
```

2. EC2 instance health check fails:
```bash
# Check Apache status
sudo systemctl status httpd

# View Apache logs
sudo cat /var/log/httpd/error_log
```

3. Load Balancer issues:
```bash
# Verify target group health
aws elbv2 describe-target-health --target-group-arn <your-target-group-arn>
```

## Best Practices

1. Version Control
- Use meaningful commit messages
- Create feature branches
- Review changes before merge

2. Security
- Regularly update dependencies
- Review security group rules
- Rotate access keys

3. Monitoring
- Set up CloudWatch alarms
- Monitor error rates
- Track resource utilization

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Submit pull request



## Support
For support, please open an issue in the GitHub repository.

## Authors
Serhii Adamchuk
