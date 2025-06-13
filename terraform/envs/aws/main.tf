data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = "flightlogscan-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

module "aws_infra" {
  source                 = "../../modules/aws"
  domain_name            = "flightlogscan.com."
  hetzner_server_ip_list = data.terraform_remote_state.prod.outputs.prod_server_ipv4_list
}
