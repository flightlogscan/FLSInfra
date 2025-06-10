# terraform {
#   required_providers {
#     hcloud = {
#       source  = "hetznercloud/hcloud"
#       version = "1.49.1"
#     }
#   }
# }
#
# # fill beta out later
# resource "hcloud_server" "beta" {
#   name        = "beta-ash1-fls"
#   server_type = "cpx11"
#   location    = "ash"
#   image       = "ubuntu-24.04"
#   backups     = true
#   ssh_keys    = [hcloud_ssh_key.default.name]
#   public_net {
#     ipv4_enabled = true
#     ipv6_enabled = true
#   }
#   user_data = file("${path.module}/../../cloud-init/base.yaml")
# }