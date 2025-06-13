resource "hcloud_ssh_key" "gha" {
  name       = "gha-key"
  public_key = file("${path.module}/../../../modules/ssh/gha_ed25519.pub")
}

resource "hcloud_server" "prod" {
  count        = var.server_count
  name         = "prod-ash1-fls-${count.index}"
  server_type  = "cpx11"
  location     = "ash"
  image        = "ubuntu-24.04"
  backups      = true
  ssh_keys     = [hcloud_ssh_key.gha.id]
  firewall_ids = [hcloud_firewall.web.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = templatefile("${path.module}/../../../cloud-init/base.yaml", {
    deploy_script       = file("${path.module}/../../../scripts/deploy.sh")
    github_runner_token = var.github_runner_token
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