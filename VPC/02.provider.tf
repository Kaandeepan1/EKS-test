provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.11"

  backend "s3" {
    bucket       = "deepan-tfstate-255945442255"
    key          = "eks-infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
