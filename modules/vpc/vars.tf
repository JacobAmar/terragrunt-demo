variable "cidr_block" {}

variable "region" {}
variable "environment" {}
variable "extra_tags" {
  default = {}
  description = "extra tags to add to the resources"
}
variable "subnets" {
  description = "map of subents to use"
  type = map
}