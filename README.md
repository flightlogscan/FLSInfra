# FLSInfra
Contains IaC for FLS. Using Hetzner cloud-init, Terraform, Ansible, Github Actions.

### SSH
An SSH public key is required by Hetzner for provisioning servers, even if SSH is later disabled.

### Install Terraform locally
1. `brew tap hashicorp/tap`
2. `brew install hashicorp/tap/terraform`

Format: `terraform fmt -recursive`

### bootstrap
* One time command for setting up s3/ddb for terraform state
* S3 Stores tf state in a file
* DDB stores lock so if multiple ppl kick off job it avoids racing
* Already done and shouldn't need to be run again
* If for some reason new account:
  * In terraform/bootstrap/infra/ run:
  * `terraform init`
  * `terraform apply -auto-approve`