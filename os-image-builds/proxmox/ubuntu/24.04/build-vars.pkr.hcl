variable "vm_name" {
  default = "ubuntu-24-04-tpl"
}

variable "iso_file" {
  default = "pveshare:iso/ubuntu-24.04.2-live-server-amd64.iso"
}

variable "iso_checksum" {
  default = "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
  # Ref: https://releases.ubuntu.com/noble/SHA256SUMS
}

variable "ssh_username" {
  default = "packer"
}

variable "ssh_password" {
  default = "packer-password"
}

variable "storage_pool" {
  default = "pveshare"
}