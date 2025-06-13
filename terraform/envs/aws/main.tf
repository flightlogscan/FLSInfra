data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = "flightlogscan-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  ip_list = data.terraform_remote_state.prod.outputs.prod_server_ipv4_list

  valid_ip_list = length(local.ip_list) > 0 ? local.ip_list : []
}

resource "null_resource" "fail_if_empty" {
  count = length(local.ip_list) == 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: No Hetzner IPs found in prod remote state.' && exit 1"
  }
}

module "aws_infra" {
  source                 = "../../modules/aws"
  domain_name            = "flightlogscan.com."
  hetzner_server_ip_list = local.valid_ip_list
}
