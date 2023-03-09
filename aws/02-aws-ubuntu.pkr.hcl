# adapted from HashiCorp Packer
# https://developer.hashicorp.com/packer/tutorials/aws-get-started/aws-get-started-build-image
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "wecloud-packer-ubuntu-02"
  instance_type = "t2.micro"
  region        = "ca-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-*-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "wecloud-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo updating system",
      "sudo apt update",
      "sudo apt upgrade -y",
      "echo installing nginx",
      "sudo apt install -y nginx",
      "echo starting nginx server",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
