provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""
}
terraform {
  required_version = ">= 1.0.0"
}
