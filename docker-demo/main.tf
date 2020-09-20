terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

resource "docker_network" "ams-network" {
  name = "ams-network"
}

resource "docker_image" "ams-server" {
  name         = "worasit501/ams-server:latest"
  keep_locally = false
}

resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = false
}

resource "docker_container" "ams-database" {
  image = docker_image.postgres.name
  name  = "ams-database"
  networks_advanced {
    name = docker_network.ams-network.name
  }
  ports {
    internal = 5432
    external = 5432
  }
  env = ["POSTGRES_PASSWORD=admin"]
}

resource "docker_container" "ams-server" {
  image = docker_image.ams-server.name
  name  = "ams-server"
  networks_advanced {
    name = docker_network.ams-network.name
  }
  depends_on = [docker_container.ams-database]
  ports {
    internal = 80
    external = 3000
  }
}