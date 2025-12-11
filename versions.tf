terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.60"  # old version 3.75.2
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}
