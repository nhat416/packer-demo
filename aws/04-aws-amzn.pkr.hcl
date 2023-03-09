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

source "amazon-ebs" "amzn" {
  ami_name      = "wecloud-packer-amzn-02"
  instance_type = "t2.micro"
  region        = "ca-central-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  name = "wecloud-packer"
  sources = [
    "source.amazon-ebs.amzn"
  ]
  provisioner "shell" {
    environment_vars = [
      "CLASS=WeCloud",
    ]
    script = "install-nginx.sh" 
  }
}
