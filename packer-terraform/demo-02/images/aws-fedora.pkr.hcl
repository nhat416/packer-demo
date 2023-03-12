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

locals { 
  os = "fedora"
  ssh_user = "fedora"
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "fedora" {
  ami_name      = "packer-terraform-demo-${local.os}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "Fedora-Cloud-Base-34-1.2.x86_64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "${local.ssh_user}"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name = "wecloud-packer"
  sources = [
    "source.amazon-ebs.fedora"
  ]

  provisioner "ansible" {
    playbook_file = "../playbooks/aws-amzn-playbook.yml"
    user          = "${local.ssh_user}"
    use_proxy     = false
    ansible_ssh_extra_args = [
      "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
  }

/**
  provisioner "file" {
    source      = "wecloud.pub"
    destination = "/tmp/wecloud.pub"
  }
  provisioner "shell" {
    script = "scripts/setup.sh"
  }
*/
}
