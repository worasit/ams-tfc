terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

resource "docker_image" "ams-server" {
  name = "worasit501/ams-server:latest"
  keep_locally = false
}

resource "docker_image" "postgres" {
  name = "postgres:latest"
  keep_locally = false
}