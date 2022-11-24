locals {
  backend = {
    env = "develop"
    port = 8080
  }
  network = {
    name = "terragrunt-simple"
  }
  name = "dev"
  port = 8089
  path_site = "/var/terragrunt-simple"
}