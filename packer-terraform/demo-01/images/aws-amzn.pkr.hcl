# adapted from Hashicorp Packer
# https://developer.hashicorp.com/packer
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "region" {
  type    = string
  default = "ca-central-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "amzn" {
  ami_name      = "packer-terraform-demo-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name = "wecloud-packer"
  sources = [
    "source.amazon-ebs.amzn"
  ]

  provisioner "ansible" {
    playbook_file = "../../playbooks/aws-amzn-playbook.yml"
  }

  /**
  provisioner "file" {
    source      = "../.ssh/wecloud.pub"
    destination = "/tmp/wecloud.pub"
  }
  provisioner "shell" {
    script = "scripts/setup.sh"
  }
*/

}
