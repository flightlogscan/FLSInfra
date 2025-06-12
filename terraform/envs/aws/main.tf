module "aws_infra" {
  source             = "../../modules/aws"
  hetzner_state_path = "../../prod/terraform.tfstate"
  domain_name        = "flightlogscan.com."
}
