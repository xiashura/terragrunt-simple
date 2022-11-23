
resource "docker_container" "nginx" {


  lifecycle {
    ignore_changes = [
      image
    ]
  }

  name  = "terragrunt-backend-simple-${var.name}"
  image = "terragrunt-backend-simple"

  env = [
    "ENV=${var.env}"
  ]

  ports {
    internal = 1323
    external = var.port
  }

}
