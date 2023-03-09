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
  default = "ubuntu:focal"
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

build {
  name = "packer-demo-docker"
  sources = [
    "source.docker.ubuntu"
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
      repository = "nhat416/ubuntu"
      tags       = ["focal", "20.04"]
    }

    post-processor "docker-push" {}
  }
}

