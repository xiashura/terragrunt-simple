

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  host_vars = read_terragrunt_config(find_in_parent_folders("host.hcl"))

  name = local.environment_vars.locals.network.name

  host_ip =  local.host_vars.locals.ip
  host_user =  local.host_vars.locals.user
  base_source_url = "git::git@github.com:xiashura/terragrunt-simple//modules/network"
}


inputs = {
  name              = local.name

  host = local.host_ip 
  uset = local.host_user 
}



