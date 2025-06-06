source "proxmox-iso" "ubuntu" {
  # Proxmox:
  proxmox_url      = "https://${var.proxmox_host}:8006/api2/json"
  node             = var.proxmox_host
  username         = var.proxmox_user
  password         = var.proxmox_password
  # VM Template:
  vm_name          = var.vm_name
  template_name    = var.vm_name
  boot_iso {
    type           = "scsi"
    iso_file       = var.iso_file
    unmount        = true
    iso_checksum   = var.iso_checksum
  }
  disks {
    storage_pool   = var.storage_pool
    disk_size      = "20G"
    type           = "scsi"
  } 
  memory           = 2048
  cores            = 2
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout = "30m"
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  http_directory   = "ubuntu/24.04/config"
  boot_wait    = "10s"
  boot_command = [
    "<esc><wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<enter>",
    "initrd /casper/initrd<enter>",
    "boot<enter>"
  ]
}

build {
  sources = ["source.proxmox.ubuntu"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y qemu-guest-agent"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '${var.ssh_username} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
    ]
  }
}