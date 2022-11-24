output "docker_ip" {
  value = docker_container.backend.network_data.*.ip_address
}

output "docker_run" {
  value = docker_container.backend.must_run
}
