terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  subscription_id = "c0748677-9808-4356-8816-dc8088c5bb59"
}