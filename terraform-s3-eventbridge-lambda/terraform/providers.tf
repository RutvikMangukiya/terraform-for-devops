terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }

    archive = {
      source = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
  profile = "default"
}