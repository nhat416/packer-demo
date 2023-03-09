
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}


builder {
  type = "vmware-iso"

  iso_url = "https://cdimage.ubuntu.com/releases/focal/release/ubuntu-20.04.5-live-server-arm64.iso"
  iso_checksum_type = "sha256"
  iso_checksum = "e42d6373dd39173094af5c26cbf2497770426f42049f8b9ea3e60ce35bebdedf"
  
  output_directory = "output-vmware"
  
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_wait_timeout = "30m"
  
  boot_command = [
    "<tab> console=ttyS0<enter><wait>",
    "<esc><wait><wait><wait><wait>",
    "install<enter><wait>",
    "ubuntu<enter><wait>",
    "ubuntu<enter><wait>",
    "<enter><wait>",
    "<enter><wait>",
    "yes<enter><wait>",
    "yes<enter><wait>",
    "<wait><wait>",
    "ubuntu<enter><wait>",
    "ubuntu<enter><wait>",
    "<enter><wait>"
  ]

  
  
  disk_size = 204800
  headless = false
  vm_name = "ubuntu-20.04-vmware"
}

provisioner "shell" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y vagrant"
  ]
}
