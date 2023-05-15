locals {
  tags = {
    region      = var.region
    environment = var.environment
    created_by  = "terraform"
  }
}