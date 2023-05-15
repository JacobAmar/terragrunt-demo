variable "environment" {}
variable "vpc_id" {}
variable "self_managed_node_groups" {
  type = map
}
variable "subnet_ids" {
  type = set(string)
}
variable "region" {}