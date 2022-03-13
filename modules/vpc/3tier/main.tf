### Variables
# General parameters
variable "name" { type = string }
variable "cidr" { type = string }

# NAT
variable "one_nat" { default = false }

# Public subnet parameters: availability zones to cover, base and bits
variable "public_zones" { type = list(string) }
variable "public_base"  { default = 0 }
variable "public_bits"  { default = 8 }

# Tags for all resources
variable "tags" { type = map(string) }

# Additional tags to assign to VPC itself
variable "vpc_tags" {
  type    = map(string)
  default = {}
}

# Additional tags to assign to public subnets
variable "public_tags" {
  type    = map(string)
  default = {}
}

### VPC: VPC with public subnets
module "vpc" {
  source = "../public/"

  name = var.name
  cidr = var.cidr

  public_zones = var.public_zones
  public_base  = var.public_base
  public_bits  = var.public_bits
  public_tags  = var.public_tags

  vpc_tags = var.vpc_tags
  tags     = var.tags
}

### Route Table: Private
resource "aws_route_table" "private" {
  count = var.one_nat ? 1:length(var.public_zones)

  vpc_id = module.vpc.id
  tags = merge(var.tags, {
    Name = var.one_nat ? "${var.name}-Private-RT":"${var.name}-Private-RT-${count.index}"
    Tier = "Private"
  })
}

# Elastic IP
resource "aws_eip" "natgw" {
  count = var.one_nat ? 1:length(var.public_zones)

  vpc = true

  tags = merge(var.tags, {
    Name = "${var.name}-NATGW-EIP-${count.index}"
    Tier = "Private"
  })
}

# NAT Gateway itself
resource "aws_nat_gateway" "natgw" {
  count = var.one_nat ? 1:length(var.public_zones)

  subnet_id     = module.vpc.public_subnets.ids[count.index]
  allocation_id = aws_eip.natgw[count.index].id

  tags = merge(var.tags, {
    Name = "${var.name}-Private-NATGW-${count.index}"
    Tier = "Private"
  })
}

# Route via NAT GW
resource "aws_route" "private-natgw" {
  count = var.one_nat ? 1:length(var.public_zones)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
}

### Outputs
output "id"             { value = module.vpc.id }
output "name"           { value = module.vpc.name }

output "rt_default"     { value = module.vpc.rt_default }
output "rt_public"      { value = module.vpc.rt_public }
output "rts_private"     { value = aws_route_table.private.*.id }

output "public_subnets" { value = module.vpc.public_subnets }

output "natgw_ip"       { value = aws_eip.natgw.*.public_ip }

# vim:filetype=terraform ts=2 sw=2 et:
