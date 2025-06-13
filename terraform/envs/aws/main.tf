module "aws_infra" {
  source                   = "../../modules/aws"
  domain_name              = "flightlogscan.com."
  hetzner_server_ip_list   = var.hetzner_server_ip_list
}
