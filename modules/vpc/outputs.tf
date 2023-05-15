output "private_subnets" {
  value = toset([for key, val in var.subnets : aws_subnet.this[key].id if tobool(lookup(val, "public", false)) == false])
}

output "public_subnets" {
  value = toset([for key, val in var.subnets : aws_subnet.this[key].id if tobool(lookup(val, "public", false)) == true])
}

output "vpc_id" {
  value = aws_vpc.this.id
}