variable "hetzner_server_ip_list" {
  type        = list(string)
  description = "List of Hetzner server IPv4 addresses passed from CI"
}
