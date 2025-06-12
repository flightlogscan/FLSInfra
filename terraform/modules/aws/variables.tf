variable "hetzner_state_path" {
  description = "Path to the Hetzner Terraform state file."
  type        = string
}

variable "domain_name" {
  description = "The Route53 domain name to manage records for."
  type        = string
}