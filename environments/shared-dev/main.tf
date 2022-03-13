### General blurb
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      version = "~> 3.63.0"
    }
    random = {
      version = "~> 3.1.0"
    }
    null = {
      version = "~> 3.1.0"
    }
    archive = {
      version = "~> 2.1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Default tags to be set for all the resources created by the AWS provider
  default_tags {
    tags = local.provider_base_tags
  }
}
# vim:filetype=terraform ts=2 sw=2 et:
