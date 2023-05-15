include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//modules/vpc"
}

inputs = {
  cidr_block = "10.0.0.0/16"
  subnets    = {
    pri-a = {
      cidr_block         = "10.0.0.0/20"
      availability_zone  = "us-east-1a"
      nat_gateway_subnet = "pub-a"
      public             = "false"
    }
    pri-b = {
      cidr_block         = "10.0.16.0/20"
      availability_zone  = "us-east-1b"
      nat_gateway_subnet = "pub-a"
      public             = "false"
    }
    pri-c = {
      cidr_block         = "10.0.32.0/20"
      availability_zone  = "us-east-1c"
      nat_gateway_subnet = "pub-a"
      public             = "false"
    }
    pub-a = {
      cidr_block         = "10.0.48.0/24"
      availability_zone  = "us-east-1a"
      public             = "true"
      create_nat_gateway = "true"
    }
    pub-b = {
      cidr_block        = "10.0.49.0/24"
      availability_zone = "us-east-1b"
      public            = "true"
    }
    pub-c = {
      cidr_block        = "10.0.50.0/24"
      availability_zone = "us-east-1c"
      public            = "true"
    }
  }
}