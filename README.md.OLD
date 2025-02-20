# Cloud Infrastructure Automation

This repository contains Terraform configurations for managing cloud infrastructure in AWS.

## Architecture

The infrastructure is organized into the following modules:

- **Networking**: VPC, subnets, and routing configuration
- **Security**: Security groups and IAM roles
- **Compute**: EC2 instances and Auto Scaling groups
- **Database**: RDS instances
- **Storage**: S3 buckets

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- Pre-commit installed

## Getting Started

1. Initialize Terraform:
```bash
terraform init
```

2. Install pre-commit hooks:
```bash
pre-commit install
```

3. Select workspace:
```bash
terraform workspace select dev
```

4. Plan the changes:
```bash
terraform plan
```

5. Apply the changes:
```bash
terraform apply
```

## Module Documentation

### Networking Module
Creates a VPC with public and private subnets across multiple availability zones.

**Inputs:**
- `vpc_cidr`: CIDR block for VPC
- `public_subnets`: List of public subnet CIDR blocks
- `private_subnets`: List of private subnet CIDR blocks
- `availability_zones`: List of availability zones

### Security Module
Manages security groups and IAM roles.

**Inputs:**
- `vpc_id`: ID of the VPC
- `environment`: Environment name (dev/staging/prod)

[Continue documentation for other modules...]

## Working with Workspaces

The project uses Terraform workspaces to manage different environments:

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new staging

# Switch workspace
terraform workspace select prod
```

## Contributing

1. Create a new branch
2. Make your changes
3. Run pre-commit hooks
4. Submit a pull request

## State Management

The Terraform state is stored in S3 with the following configuration:
- Bucket: terraform-state-bucket
- Key: terraform.tfstate
- Region: eu-central-1
- Encryption: Enabled
- State Locking: Using DynamoDB
