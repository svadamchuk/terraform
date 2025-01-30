terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state-bucket-owqc5vdf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = lookup({
      dev     = "arn:aws:iam::${var.dev_account_id}:role/terraform-role",
      staging = "arn:aws:iam::${var.staging_account_id}:role/terraform-role",
      prod    = "arn:aws:iam::${var.prod_account_id}:role/terraform-role"
    }, terraform.workspace)
  }
}
}