
resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo-${var.env}"
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.state-demo-secure.name
  location                 = azurerm_resource_group.state-demo-secure.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.env
  }
}