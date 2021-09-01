############################################
# Provider
############################################
terraform {
  required_version = ">= 0.13.4"
  required_providers {
    oci = {
      region = "us-phoenix-1"
      version = "~> 4.9.0"
    }
  }
}

