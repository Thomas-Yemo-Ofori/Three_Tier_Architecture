terraform {
  backend "s3" {
    bucket = "three-tier-tfstate"
    key    = "three-tier/terraform/terraform.tfstate"
    region = var.region
  }
}
