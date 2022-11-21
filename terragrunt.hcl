
locals {

  host_vars = read_terragrunt_config(find_in_parent_folders("host.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  host_user = local.host_vars.locals.user
  host_ip = local.host_vars.locals.ip
}


remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "my-bucket"
    key     = "terragrunted/${path_relative_to_include()}.tfstate"
    region  = "eu-west-1"
    encrypt = false
    endpoint       = "http://s3.localhost.localstack.cloud:4566"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    dynamodb_table              = "terraform_state"
    dynamodb_endpoint           = "http://s3.localhost.localstack.cloud:4566"

    skip_bucket_versioning         = true # use only if the object store does not support versioning
    skip_bucket_ssencryption       = true # use only if non-encrypted Terraform State is required and/or the object store does not support server-side encryption
    skip_bucket_root_access        = true # use only if the AWS account root user should not have access to the remote state bucket for some reason
    skip_bucket_enforced_tls       = true # use only if you need to access the S3 bucket without TLS being enforced
    // enable_lock_table_ssencryption = true # 
  }
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }
  }
}


provider "docker" {
  host     = "ssh://${local.host_user}@${local.host_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}


EOF
}

inputs = merge(
  local.host_vars.locals,
  local.environment_vars.locals,
)



// terraform {
//   extra_arguments "common_vars" {
//     commands = get_terraform_commands_that_need_vars()
//     optional_var_files = [
//       find_in_parent_folders("regional.tfvars"),
//     ]
//   }
// }
// generate "providers" {
//   path      = "providers.tf"
//   if_exists = "overwrite"
//   contents  = <<EOF
// provider "aws" {
//   region = var.aws_region
// }
// variable "aws_region" {
//   description = "AWS region to create infrastructure in"
//   type        = string
// }
// terraform {
//   backend "s3" {
//   }
// }
// EOF
// }