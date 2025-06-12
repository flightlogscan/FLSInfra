terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.49.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "gha-key"
  public_key = file("${path.module}/../../ssh/gha_ed25519.pub")
}

resource "hcloud_server" "prod" {
  name        = "prod-ash1-fls"
  server_type = "cpx11"
  location    = "ash"
  image       = "ubuntu-24.04"
  backups     = true
  ssh_keys    = [hcloud_ssh_key.default.name]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = templatefile("${path.module}/../../cloud-init/base.yaml", {
    deploy_script       = file("${path.root}/scripts/deploy.sh")
    github_runner_token = var.github_runner_token
  })
}