locals {
  instance_name     = "prod-ash1-fls"
  deploy_script     = file("${path.module}/../../../scripts/deploy.sh")
  deploy_script_b64 = base64encode(local.deploy_script)
  cloud_config      = file("${path.module}/../../../cloud-init/base.yaml")
  config_hash       = sha1(join("", [local.deploy_script, local.cloud_config]))
}

resource "hcloud_ssh_key" "default" {
  name       = "gha-key"
  public_key = file("${path.module}/../../ssh/gha_ed25519.pub")
}

resource "hcloud_server" "prod" {
  count        = var.server_count
  name         = "${local.instance_name}-${count.index}"
  server_type  = "cpx11"
  location     = "ash"
  image        = "ubuntu-24.04"
  backups      = true
  ssh_keys     = [hcloud_ssh_key.default.name]
  firewall_ids = [hcloud_firewall.web.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = templatefile("${path.module}/../../../cloud-init/base.yaml", {
    deploy_script_b64    = local.deploy_script_b64
    github_runner_token  = var.github_runner_token
    config_hash          = local.config_hash
    grafana_loki_api_key = var.grafana_loki_api_key
    hostname             = "${local.instance_name}-${count.index}"
  })
}

resource "hcloud_firewall" "web" {
  name = "web-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}