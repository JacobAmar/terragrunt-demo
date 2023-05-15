resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge({
    Name = "${var.environment}-igw"
  }, local.tags, var.extra_tags)
}

resource "aws_eip" "this" {
  depends_on = [aws_internet_gateway.this]
  for_each   = {
    for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == true && tobool(lookup(val, "create_nat_gateway", false)) == true
  }
  // only create eip for nat gateway if the subnet map contains a public subnet and a value called create_nat_gateway = true which all of them are false by default
  vpc  = true
  tags = merge({
    Name = "${var.environment}-${each.key}-ngw-eip"
  }, local.tags, var.extra_tags)
}

resource "aws_nat_gateway" "this" {
  for_each = {
    for key, val in var.subnets : key => val if tobool(lookup(val, "public", false)) == true && tobool(lookup(val, "create_nat_gateway", false)) != false
  }
  // only create nat gateway if the subnet map contains a public subnet and a value called create_nat_gateway = true which all of them are false by default
  depends_on    = [aws_internet_gateway.this]
  subnet_id     = aws_subnet.this[each.key].id
  allocation_id = aws_eip.this[each.key].id
  tags          = merge({
    Name = "${var.environment}-${each.key}-ngw"
  }, local.tags, var.extra_tags)
}