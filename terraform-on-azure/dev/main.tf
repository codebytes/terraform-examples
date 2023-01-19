# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }
  backend "azurerm" {}

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-demo-${var.environment}"
  location = var.location

}

resource "azurerm_management_lock" "rg" {
  name       = "DoNotDelete"
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group is Read-Only, please contact support if need further information !"
}