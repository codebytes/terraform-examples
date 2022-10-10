terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    use_oidc             = true
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate13329"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  use_oidc = true
  features {}
}
