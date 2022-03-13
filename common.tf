### Common variables.
# Account info
variable "aws_region" { type = string }
variable "aws_account" { type = string }

# Terraform state S3 bucket and DynamoDB table (e.g., for remote_state)
variable "tfstate_region" { type = string }
variable "tfstate_bucket" { type = string }
variable "tfstate_table" { type = string }

# Project identification
variable "project_env" { type = string }
variable "project_name" { type = string }
variable "project_domain" { type = string }

# Network params
variable "vpc_cidr" { default = "" }
variable "total_azs" { default = 3 }

### Handy locals
locals {
  # Base name prefix
  basename = "${var.project_name}-${var.project_env}"

  # Base resource-independent tags. Left here for the back compatibility
  base_tags = {
  }
  # Base resource-independent tags
  provider_base_tags = {
    Project     = var.project_name
    Environment = var.project_env
    Managed_by  = "terraform"
  }
}

# vim:filetype=terraform ts=2 sw=2 et:
