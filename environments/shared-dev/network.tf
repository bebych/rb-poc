### VPC: MGMT
module "vpc" {
  source = "../../modules/vpc/3tier/"

  name = local.basename
  cidr = var.vpc_cidr
  tags = local.base_tags

  one_nat = true

  public_zones = local.zone_names
}

### VPC Subnets: Private
module "private-subnets" {
  source = "../../modules/vpc/subnets/"

  vpc_id   = module.vpc.id
  basename = "${local.basename}-Private"

  zones  = local.zone_names
  prefix = var.vpc_cidr
  base   = 16

  route_tables = module.vpc.rts_private

  tags = merge(local.base_tags, {
    Tier = "Private"
  })
}

### Outputs
output "vpc" {
  value = {
    id   = module.vpc.id
    name = module.vpc.name
    cidr = var.vpc_cidr

    rt_default = module.vpc.rt_default
    rt_public  = module.vpc.rt_public
    rts_private = module.vpc.rts_private

    natgw_ip = module.vpc.natgw_ip
  }
}

output "priv_subnets" {
  value = module.private-subnets.ids
}

# vim:filetype=terraform ts=2 sw=2 et:
