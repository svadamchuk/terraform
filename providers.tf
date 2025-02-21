terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  # Используем assume_role только если это не default environment
  dynamic "assume_role" {
    for_each = local.environment == "default" ? [] : [1]
    content {
      role_arn = format(
        "arn:aws:iam::%s:role/terraform-role",
        var.aws_account_ids[local.environment]
      )
    }
  }
}
