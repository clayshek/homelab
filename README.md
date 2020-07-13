# Home Lab

## Overview

This (WIP) page describes a home lab environment for evaluation and testing of various products. Basic setup & config of both supporting infrastructure and additional products is documented here (mostly so I remember how I did stuff). 

## Goals
- A stable base of hypervisors & container hosts on physical hardware, on which further virtualized or containerized product testing & evaluations can be done (quickly) without impact to the base lab.
- Simplicity (as much as possible anyway)
- Raspberry Pis always on, power-hungry servers powered on as needed - so any "critical" roles (dynamic DNS updater, etc) should reside on a Raspberry Pi.
- Totally separate lab env from home (don't want tinkering to impact "home" WiFi, DNS, storage, etc in any way).
- Codified & documented config leading to trivial re/deployments.
- Learning

## Software
- 3-node [Proxmox VE](https://www.proxmox.com/) cluster for KVM based virtual machines and LXC containers.
- 4-node Raspberry Pi [K3s](https://k3s.io/) / [Ubuntu Server](https://ubuntu.com/download/server) cluster for ARM-compatible containerized workloads
- Lots of [Ansible](https://www.ansible.com/) for automation of provisioning and configuration

## Gear / Roles
- Servers 
  - 5x Dell R610 1U rack servers. 
    - Ea: 96 GB RAM, 2x 73 GB HDD (RAID-1 for OS), 4x 450 GB HDD (local data storage)
    - Roles: 3x [Proxmox VE](https://www.proxmox.com/) hypervisors, 1x cold standby, 1x spare parts
- Rasberry Pis
  - 4x Model 3B, 1x Model 3B+
    - Ea: 1 GB RAM, 1x 32 GB MicroSD
    - Roles: 4x [K3s](https://k3s.io/) cluster members, 1x standalone running [Docker](https://www.docker.com/) and serving as an Ansible [control node](https://docs.ansible.com/ansible/2.5/network/getting_started/basic_concepts.html#control-node), all running [Ubuntu Server](ubuntu.com/download/raspberry-pi)
- Switches, Routers, APs
  - 1x Ubiquiti [EdgeRouter X](https://www.ui.com/edgemax/edgerouter-x/). Provides routing, firewall, DHCP, DNS to lab, as well as inbound VPN
  - 1x Netgear JGS524E 24-port managed switch
  - 1x Netgear 8-port unmanaged switch
  - 1x Ubiquiti [Unifi AP AC Pro](ui.com/unifi/unifi-ap-ac-pro/)
- Storage
  - 1x Buffalo 500 GB NAS (backups, image storage, etc). Old, and requires SMB v1, target for replacement.
  - Otherwise locally attached storage (R610 RAID controller limitation not allowing JBOD passthrough restricts ability to use Ceph and other cluster storage technologies)
- Power
  - 1x APC BX1500M 1500VA UPS

## Config
- Network
  - LAN: `192.168.2.0/24`
  - Gateway: `192.168.2.1`
  - DHCP: Range `192.168.2.150-.199`, provided by EgdeRouterX
  - DNS Resolver (default): EdgeRouterX to upstream ISP router to OpenDNS
  - Managed switch: currently no special config, but will likely implement VLANs in the future
- DNS Zones
  - layer8sys.com (Root zone. Authoritative DNS servers: Google DNS)
  - int.layer8sys.com (Purpose: private IP space / internal resource access by FQDN. Authoritative DNS: Primary home router)
  - ad.layer8sys.com (Purpose: Windows Active Directory. Authoritative DNS: AD domain controller VMs)
  - lab.layer8sys.com (TBD)

- Wireless


### **Raspberry Pi Provisioning & Config**

Raspberry Pis are each configured with an Ansible playbook, pulled at OS install from another of my GitHub repos: https://github.com/clayshek/raspi-ubuntu-ansible

Requires flashing SD card(s) with Ubuntu, and copying in the customizable CloudInit user-data file (included in repo) to the boot partition before inserting into and starting each Pi. After a few minutes, based on defined inventory role, provisioning is complete and ready for any further config. K3s cluster is provisioned with [Rancher's Ansible playbook](https://github.com/rancher/k3s-ansible). 

### **Proxmox Hypervisor Provisioning & Config**

Proxmox configuration requires installation of [Proxmox VE](https://www.proxmox.com/en/downloads) on each node, followed by running https://github.com/clayshek/ansible-proxmox-config Ansible playbook (after customization). Once complete, manually create cluster on one node, join other nodes to cluster, and configure cluster data storage specific to implementation details. 

## Metrics, Monitoring & Logging
- Prometheus / Grafana
- UPS power status & consumption monitoring
- ELK - Logzio?
- UptimeRobot for remote network monitoring


## Proxmox VM Templates

VM deployments based on a [template](https://pve.proxmox.com/wiki/VM_Templates_and_Clones) are much faster than running through a new install. The following repos use Ansible to create Proxmox template images (and handle OS / package updates) for my most frequently used VM operating systems. These templates are used for later infrastructure provisioning.

- Windows Server 2019: https://github.com/clayshek/ans-pve-win-templ 
- Ubuntu Server 20.04: 

## Lab Environment & Deployed Apps

### Microsoft Windows Server Lab:
- 2x Active Directory Domain Controllers (Proxmox VMs)
- 4-node Microsoft Hyper-V Cluster (Proxmox VMs)
- System Center Virtual Machine Manager (Proxmox VM)
- Windows Admin Center (Proxmox VM)

The base VMs for the Windows Server lab are provisioned (from the [Server 2019 template](https://github.com/clayshek/ans-pve-win-templ) above), using https://github.com/clayshek/ans-pve-win-provision. 
Once online, role assignment and final configuration is done using https://github.com/clayshek/ansible-lab-config 

### Apache CloudStack (Proxmox VMs)

### Kubernetes cluster, incl Windows worker node (Proxmox VMs)

### GitLab ([Proxmox Turnkey Linux Container](https://www.turnkeylinux.org/gitlab))

### InfoBlox Eval (Proxmox VM)

### [Caddy](https://caddyserver.com/)-based Lab Dashboard / Portal (K3s container)

### Dynamic DNS Updaters for Google & OpenDNS (K3s container)

### Unifi Network Controller (K3s container)

### Prometheus (K3s container)

### Grafana (Proxmox VM)

### Consul (K3s containers)

### APC UPS Monitor (K3s container)

## General To-Dos
- [ ] Identify better NAS storage solution, potentially with iSCSI, also providing persistent K3s storage.
- [ ] Update [Proxmox config repo](https://github.com/clayshek/ansible-proxmox-config) to automate cluster creation/join & storage setup. Possibly change to auto playbook pull?
- [ ] Check out the Ras Pi model 4

## Diagram & Photos
