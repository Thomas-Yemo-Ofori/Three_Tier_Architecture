####################################################################
########################### Provider AWS  ##############################
####################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Choose the region you want to provision your resources
provider "aws" {
  region = var.region
}