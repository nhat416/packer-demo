source "vmware-iso" "basic-example" {
  iso_url = "https://cdimage.ubuntu.com/releases/focal/release/ubuntu-20.04.5-live-server-arm64.iso"
  iso_checksum = "sha256:e42d6373dd39173094af5c26cbf2497770426f42049f8b9ea3e60ce35bebdedf"
  ssh_username = "packer"
  ssh_password = "packer"
  shutdown_command = "shutdown -P now"
}

build {
  sources = ["sources.vmware-iso.basic-example"]
}
