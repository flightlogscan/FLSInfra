variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
}

variable "github_runner_token" {
  type        = string
  description = "GitHub Actions self-hosted runner registration token"
}

variable "server_count" {
  type        = number
  description = "Number of Hetzner servers to create"
  default     = 1
}