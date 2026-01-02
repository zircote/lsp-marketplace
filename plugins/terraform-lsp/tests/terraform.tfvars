# Test Variable Values
# This file triggers tfvars-fmt-on-edit and tfvars-sensitive-check hooks

aws_region  = "us-west-2"
environment = "dev"

enable_versioning = true

tags = {
  Team      = "Platform"
  CostCenter = "Engineering"
}

allowed_account_ids = []
