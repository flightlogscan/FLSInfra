# FLSInfra
Contains IaC for FLS. Using Hetzner cloud-init, Terraform, Ansible, Github Actions.

# SSH
An SSH public key is required by Hetzner for provisioning servers, even if SSH is later disabled.

### Install Terraform locally
1. `brew tap hashicorp/tap`
2. `brew install hashicorp/tap/terraform`

Format: `terraform fmt -recursive`