terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.76.0"
    }
  }

  backend "s3" {
    bucket = "az-app-backend"
    key = "build-agent-tf/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "azurerm" {
  features {}
}
