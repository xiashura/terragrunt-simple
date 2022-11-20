resource "local_file" "nginx-html-site" {

  content = templatefile(
    "${path.module}/template/simple-site.tpl",
    {
      name = var.name
    }
  )
  filename = var.path_site
}

resource "docker_container" "nginx" {

  lifecycle {
    ignore_changes = [
      image
    ]
  }

  name  = "nginx-${var.name}"
  image = "nginx"

  ports {
    internal = 80
    external = var.port
  }
  volumes {
    container_path = "/etc/nginx/site-enabled/default"
    host_path      = var.path_site
  }

}
