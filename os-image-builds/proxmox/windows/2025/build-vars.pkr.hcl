variable "proxmox_node" {
  default = "pve1"
}
variable "proxmox_fqdn_or_ip" {
  default = "pve1.example.com"
}
variable "proxmox_user" {
  default = "packer-build@pve!buildtoken" 
}

variable "proxmox_password" {
  default = env("VAR_proxmox_password")
  sensitive = true
} 

variable "proxmox_apitoken" {
  default = env("VAR_proxmox_api_token")
  sensitive = true
} 

variable "vm_name" {
  default = "tpl-win-2025"
}

variable "iso_file" {
  default = "pveshare:iso/Server-2025_26100.1742.240906-0331_EVAL_x64FRE_en-us.iso"
}

/*
variable "iso_checksum" {
  default = "file:https://releases.ubuntu.com/noble/SHA256SUMS"
}
*/

variable "vm_username" {
  default = "administrator"
}

variable "vm_password_hashed" {
  default = "$6$.xWrYI1ZS0Xxsaz8$aFXrjsvX74D8LI2uIkqqlH9NqV6XYLeU1X/fnDJgV1xLOs2tOF7iLwAu.6TqzI3hwTaMXezPM1jmK0nBTPhkH0"
}

variable "vm_password" {
  default = "packer-password"
}

variable "storage_pool" {
  default = "vm-store"
}
/*
# Render cloud-init user-data from template
locals {
  rendered_user_data = templatefile("./config/user-data.pkrtpl.hcl", {
    vm_name     = var.vm_name
    vm_username = var.vm_username
    vm_password_hashed = var.vm_password_hashed
  })
}
*/