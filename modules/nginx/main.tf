resource "null_resource" "load-config" {

  connection {
    type = "ssh"
    user = var.user
    host = var.host
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.path_site}"
    ]
  }
  provisioner "file" {
    content = templatefile(
      "${path.module}/template/index.html",
      {
        name = var.name
      }
    )

    destination = "${var.path_site}/index.html"
  }

  provisioner "file" {
    content     = file("${path.module}/template/nginx.conf")
    destination = "${var.path_site}/nginx.conf"
  }

  provisioner "file" {
    content     = file("${path.module}/template/default.conf")
    destination = "${var.path_site}/default.conf"
  }
}

resource "docker_container" "nginx" {

  depends_on = [
    null_resource.load-config
  ]

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

  mounts {
    target = "/etc/nginx/site-enabled/default.conf"
    type   = "bind"
    source = "${var.path_site}/default.conf"
  }

  mounts {
    target = "/etc/nginx/nginx.conf"
    type   = "bind"
    source = "${var.path_site}/nginx.conf"
  }


  mounts {
    target = "/var/www/html/index.html"
    type   = "bind"
    source = "${var.path_site}/index.html"
  }

}

resource "null_resource" "set-permissions" {

  depends_on = [
    docker_container.nginx
  ]

  provisioner "local-exec" {
    command = <<EOF
    ssh -o StrictHostKeyChecking=no \
    ${var.user}@${var.host} docker exec \
     -i ${docker_container.nginx.name} chown -R nginx:nginx /var/www/html
    EOF
  }
}
