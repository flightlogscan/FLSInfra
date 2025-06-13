output "prod_server_ipv4_list" {
  value = [for s in hcloud_server.prod : s.ipv4_address]
}
