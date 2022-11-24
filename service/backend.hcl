
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  host_vars = read_terragrunt_config(find_in_parent_folders("host.hcl"))


  # Extract out common variables for reuse
  env =  local.environment_vars.locals.backend.env
  port = local.environment_vars.locals.backend.port
  name = local.environment_vars.locals.name
  path_site = local.environment_vars.locals.path_site

  host_ip =  local.host_vars.locals.ip
  host_user =  local.host_vars.locals.user
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:xiashura/terragrunt-simple//modules/backend"
}



// dependency "network" {
//   config_path = "${find_in_parent_folders("network")}"
// }

inputs = {
  env = local.env
  name              = "backend-${local.name}"
  port = local.port
  path_site = local.path_site


  // docker_network_id = dependency.network.outputs.id
  host = local.host_ip 
  uset = local.host_user 

  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}

