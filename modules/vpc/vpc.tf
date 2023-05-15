resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge({
    Name = "${var.environment}-vpc"
  }, local.tags, var.extra_tags)
}
