# This is an example terragrunt infrastructure

## In order to create the infrastructure

- modify the infrastructure/terrgrunt.hcl to change the s3 bucket name to your needs 
```hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "<put your own bucket name>"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "<your desired region>"
    encrypt        = true
  }
}
```
- run
```bash
cd infrastructure
terragrunt run-all apply
```