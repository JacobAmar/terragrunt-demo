terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply","destroy"]

    arguments = [
      "-var-file=${get_terragrunt_dir()}/../../account.tfvars",
      "-var-file=${get_terragrunt_dir()}/../region.tfvars"
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "jacob-tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = var.region
}
EOF
}