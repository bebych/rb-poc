### Data sources
# Availability zones
data "aws_availability_zones" "aws_azs" {}

### Handy locals
locals {
  zone_names = slice(data.aws_availability_zones.aws_azs.names, 0, var.total_azs)
  zone_ids   = slice(data.aws_availability_zones.aws_azs.zone_ids, 0, var.total_azs)
}

### Outputs
# Pass some common values to all other environments to speed up refresh stage
output "zone_names" { value = local.zone_names }
output "zone_ids" { value = local.zone_ids }

# vim:filetype=terraform ts=2 sw=2 et:
