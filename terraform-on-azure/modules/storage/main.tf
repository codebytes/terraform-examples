
resource "azurerm_storage_account" "state-demo" {
  name                     = "statedemocayers${var.environment}"
  resource_group_name      = azurerm_resource_group.state-demo-secure.name
  location                 = azurerm_resource_group.state-demo-secure.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}