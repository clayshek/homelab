Post-Install Config Steps:

- Via GUI, enable no-subscription repositories, disable enterprise repositories
- Via GUI (Datacenter -> Storage -> Add), add network shares (pveshare & labfiles)
- Via GUI (Datacenter -> Storage -> Add), add LVM storage for vm-store existing volume group.
- Add 2FA auth key (Datacenter -> Permissions - Two Factor)
- Certificate
- Add 'packer-build' account (PVE realm)
- Via GUI (Datacenter -> Permissions), add permission for packer-build account to / path with appropriate role
- Create API token for packer-build account
- Via GUI, do same permission as above for API token if required.
