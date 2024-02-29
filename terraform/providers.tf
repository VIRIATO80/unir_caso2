terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "49cc1690-063d-4466-b8df-9464021b1605"
  client_id = "1cd9b581-e451-4131-bdaa-effc6ca712ae"
  client_secret = "1Wc8Q~kQTCzAogaPRmvERL62rF7s~iZClo4locP6"
  tenant_id = "899789dc-202f-44b4-8472-a6d40f9eb440"
}