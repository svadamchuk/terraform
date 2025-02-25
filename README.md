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
|---.gitignore
|---.pre-commit-config.yaml
|---backend.sh
|---locals.tf
|---main.tf
|---outputs.tf
|---providers.tf
|---README.md
|---variables.tf
|---.github
|   `---workflows
|       `---terraform.yml
|---backend-setup
|   |---backend-setup.tf
|   `---providers.tf
|---modules
|   |---compute
|   |   |---main.tf
|   |   |---outputs.tf
|   |   |---providers.tf
|   |   `---variables.tf
|   |---database
|   |   |---main.tf
|   |   |---outputs.tf
|   |   |---providers.tf
|   |   `---variables.tf
|   |---networking
|   |   |---main.tf
|   |   |---outputs.tf
|   |   |---providers.tf
|   |   `---variables.tf
|   |---security
|   |   |---main.tf
|   |   |---outputs.tf
|   |   |---providers.tf
|   |   `---variables.tf
|   `---storage
|       |---main.tf
|       |---outputs.tf
|       |---providers.tf
|       `---variables.tf
`---site
    `---index.html
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
chmod +x backend.sh
./backend.sh
```

3. Configure AWS credentials:
```bash
aws configure
```

## Development Setup

### Pre-commit Hooks

The project uses pre-commit hooks to maintain code quality and consistency. These hooks run automatically before each commit to ensure code meets the defined standards.

#### Installation

1. Install pre-commit:
```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install pre-commit

# For MacOS
brew install pre-commit

# Using pip
pip install pre-commit
```

2. Install terraform-related tools:
```bash
# Install tflint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install checkov
pip install checkov
```

3. Setup pre-commit hooks in the repository:
```bash
# Install the pre-commit hooks
pre-commit install

# Verify installation
pre-commit --version
```

#### Configuration

The project includes a pre-commit configuration file (.pre-commit-config.yaml):
```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_fmt
      - id: terraform_tflint
      - id: terraform_validate
      - id: terraform_checkov

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: check-merge-conflict
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: check-yaml
      - id: check-added-large-files
```

#### Available Hooks

1. Terraform-specific:
- `terraform_fmt`: Formats Terraform code according to standard conventions
- `terraform_tflint`: Lints Terraform code for possible errors
- `terraform_validate`: Validates Terraform configurations
- `terraform_checkov`: Scans for security issues

2. General:
- `check-merge-conflict`: Checks for merge conflict markers
- `end-of-file-fixer`: Ensures files end with a newline
- `trailing-whitespace`: Removes trailing whitespace
- `check-yaml`: Validates YAML files
- `check-added-large-files`: Prevents large files from being committed

#### Usage

1. Automatic checks:
```bash
# Hooks run automatically on git commit
git commit -m "Your commit message"
```

2. Manual runs:
```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run terraform_fmt
pre-commit run terraform_validate
```

3. Skip hooks (not recommended):
```bash
git commit -m "Your message" --no-verify
```

#### Troubleshooting Pre-commit

1. Hook installation issues:
```bash
# Clean and reinstall hooks
pre-commit uninstall
pre-commit clean
pre-commit install
```

2. Specific hook failures:
```bash
# Run with verbose output
pre-commit run --verbose

# Update hooks to latest versions
pre-commit autoupdate
```

3. Common issues:
- Terraform formatting: Run `terraform fmt -recursive` to format all files
- Documentation: Ensure proper Terraform documentation blocks exist
- YAML validation: Check YAML file syntax
- Large files: Keep committed files under size limit

#### Best Practices

1. Always run hooks before pushing:
```bash
# Run hooks manually before push
pre-commit run --all-files
```

2. Keep hooks updated:
```bash
# Update hooks regularly
pre-commit autoupdate
```

3. Regular maintenance:
- Review and update hook versions
- Add new hooks as needed
- Remove unused hooks
- Adjust hook configurations based on project needs

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
# Create S3 backend
./backend.sh

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Automated Deployment (GitHub Actions)
The project includes CI/CD pipeline with GitHub Actions:
- Automatic planning for dev environment on pull requests
- Plan output as PR comment
- Automatic deployment to dev environment after
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
