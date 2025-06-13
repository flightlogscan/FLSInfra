terraform {
  backend "s3" {
    bucket  = "flightlogscan-terraform-state"
    key     = "aws/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}