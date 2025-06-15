terraform {
  backend "s3" {
    bucket  = "flightlogscan-terraform-state"
    key     = "cloudflare/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}