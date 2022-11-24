
resource "docker_container" "backend" {


  lifecycle {
    ignore_changes = [
      image
    ]
  }

  name     = "terragrunt-simple-${var.name}"
  hostname = var.name
  image    = "terragrunt-backend-simple"

  env = [
    "ENV=${var.env}",
    "PORT=${var.port}"
  ]

  ports {
    internal = var.port
    external = var.port
    ip       = "127.0.0.1"
  }

}
