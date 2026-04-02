terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
  backend "azurerm" {
    
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9d325e94-6a7f-4733-b0d4-5a951d0f78b8"
}










