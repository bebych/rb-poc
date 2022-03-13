### Binary compatibility settings
### Terraform/Terragrunt Version Mapping

terraform_version_constraint = ">= 1.1"
terragrunt_version_constraint = ">= 0.35"

### Project identification
locals {
  aws_region     = "eu-west-1"
  aws_account    = "394106777563"
  project_name   = "rb"
  project_domain = "rb"

  tfstate_region = local.aws_region
  tfstate_bucket = lower("tfstate.${local.aws_region}.${local.project_domain}")
  tfstate_table  = lower("tfstate-locks.${local.aws_region}.${local.project_domain}")
}

### Automatic input variables
inputs = {
  # Must be overriden in environments
  project_env    = ""

  prefix         = "${get_env("ENV_NAME")}"

  # Can be overriden in environments
  aws_region     = local.aws_region

  # Same for all environments
  aws_account    = local.aws_account
  project_name   = local.project_name
  project_domain = local.project_domain

  # State parameters
  tfstate_region = local.tfstate_region
  tfstate_bucket = local.tfstate_bucket
  tfstate_table  = local.tfstate_table
}

### Terraform configuration
terraform {
  extra_arguments "custom_vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_parent_terragrunt_dir()}/common.tfvars",
    ]

    # Ensure that terraform.tfvars is loaded *after* common.tfvars
    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
    ]
  }
}

### Remote state S3/DynamoDB configuration
remote_state {
  backend = "s3"
  config = {
    region  = local.tfstate_region
    bucket  = local.tfstate_bucket
    key     = "${path_relative_to_include()}/${get_env("ENV_NAME")}/terraform.tfstate"
    encrypt = true

    dynamodb_table = local.tfstate_table
  }
}

# vim:filetype=terraform ts=2 sw=2 et:
