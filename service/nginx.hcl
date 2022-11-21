# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  host_vars = read_terragrunt_config(find_in_parent_folders("host.hcl"))


  # Extract out common variables for reuse
  name = local.environment_vars.locals.name
  port = local.environment_vars.locals.port
  path_site = local.environment_vars.locals.path_site

  host_ip =  local.host_vars.locals.ip
  host_user =  local.host_vars.locals.user
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:xiashura/terragrunt-simple//modules/nginx"
}


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name              = "nginx-${local.name}"
  port = local.port
  path_site = local.path_site

  host = local.host_ip 
  uset = local.host_user 

  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}

