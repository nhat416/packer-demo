packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "docker_image" {
  type    = string
  default = "nhat416/waypoint"
}

source "docker" "waypoint" {
  image  = var.docker_image
  commit = true
}

build {
  name = "packer-demo-docker-waypoint"
  sources = [
    "source.docker.waypoint"
  ]

  provisioner "shell" {
    environment_vars = [
      "CLASS=WeCloud",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"Class is $CLASS\" > class.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo Running ${var.docker_image} Docker iamge."]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "nhat416/waypoint"
      tags       = ["0.0.2", "latest"]
    }

    post-processor "docker-push" {}
  }
}

