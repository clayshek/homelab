#cloud-config
autoinstall:
  version: 1
  locale: en_US
  keyboard:
    layout: us
  identity:
    hostname: ${vm_name}
    username: ${vm_username}
    password: ${vm_password_hashed}
  ssh:
    install-server: true
    allow-pw: true
  package-update: true
  package-upgrade: true
  packages:
    - qemu-guest-agent
    - ansible-core
  #late-commands:
    #- echo 'packer ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/packer