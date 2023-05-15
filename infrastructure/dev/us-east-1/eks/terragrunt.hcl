include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs                            = {
    private_subnets = ["fake-subnet-id", "fake-subnet-id2"],
    vpc_id          = "fake-vpc-id"
  }
}

terraform {
  source = "${get_path_to_repo_root()}//modules/eks"
}

inputs = {
  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  self_managed_node_groups = {
    ng-a = {
      instance_type = "t3.medium"
      min_size      = "1"
      max_size      = "2"
      desired_size  = "1"
    }
    ng-b = {
      instance_type = "t3.medium"
      min_size      = "1"
      max_size      = "2"
      desired_size  = "1"
    }
  }
}