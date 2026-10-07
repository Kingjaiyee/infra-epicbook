terraform {
  required_version = ">= 1.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Subscription comes from ARM_SUBSCRIPTION_ID (lab.env locally, the service connection in the pipeline)
provider "azurerm" {
  features {}
}
