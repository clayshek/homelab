# windows-server-2025.pkr.hcl

/*
source "file" "generate-user-data" {
    content = local.rendered_user_data
    target = "ubuntu/24.04/config/user-data"
  }
*/

source "proxmox-iso" "windows" {
  # Proxmox Data:
  proxmox_url      = "https://${var.proxmox_fqdn_or_ip}:8006/api2/json"
  node             = var.proxmox_node
  username         = var.proxmox_user
  password         = var.proxmox_password
  token            = var.proxmox_apitoken 
  # VM Template Data:
  vm_name          = var.vm_name
  template_name    = var.vm_name
  # cloud_init = true to add an empty cloud-init drive to the template
  #cloud_init       = true
  #cloud_init_storage_pool = var.storage_pool
  boot_iso {
    type           = "scsi"
    iso_file       = var.iso_file
    unmount        = true
    #iso_checksum   = var.iso_checksum
  }
  disks {
    storage_pool   = var.storage_pool
    disk_size      = "20G"
    type           = "scsi"
  } 
  memory           = 2048
  cores            = 2
  ssh_username     = var.vm_username
  ssh_password     = var.vm_password
  ssh_clear_authorized_keys = true
  ssh_timeout = "30m"
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  insecure_skip_tls_verify = true
  /*
  http_directory   = "ubuntu/24.04/config"
  boot_wait    = "10s"

  boot_command = [
    "<wait>c<wait>",
    "linux /casper/vmlinuz --- ",
    "autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]  
  */
}

/*
build {
  sources = ["source.file.generate-user-data"]
}
*/

build {
  sources = ["source.proxmox-iso.windows"]
}