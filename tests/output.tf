
output "name" {
  value = module.backend.docker_ip[0]
}
