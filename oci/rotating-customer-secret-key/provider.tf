terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.14"
    }
  }
  required_version = "~> 1.9"
}
