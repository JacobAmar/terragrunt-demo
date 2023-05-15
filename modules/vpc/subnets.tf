resource "aws_subnet" "this" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = lookup(each.value, "public", "false") == "false" ? false : true
  // will lookup in the map for a key called public, if the key not found then the value is false meaning that the subnet should be private by default
  tags                    = merge({
    Name = "${var.environment}-${each.key}"
  }, local.tags, var.extra_tags)
}

resource "aws_route_table" "private" {
  for_each = {for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == false}
  vpc_id   = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.value.nat_gateway_subnet].id
    // we will pass for each private subnet a nat gateway name to use for the subnet route table
  }
  tags = merge({
    Name = "${var.environment}-${each.key}-rtb"
  }, local.tags, var.extra_tags)
}

resource "aws_route_table" "public" {
  for_each = {for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == true}
  vpc_id   = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge({
    Name = "${var.environment}-${each.key}-rtb"
  }, local.tags, var.extra_tags)
}

resource "aws_route_table_association" "private" {
  for_each       = {for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == false}
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = {for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == true}
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}