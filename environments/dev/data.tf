### Data sources
# MGMT State
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    region = var.tfstate_region
    bucket = var.tfstate_bucket
    key    = "environments/shared-dev/shared/terraform.tfstate"
  }
}