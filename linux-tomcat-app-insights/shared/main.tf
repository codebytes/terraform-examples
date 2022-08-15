resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-tomcat-${var.suffix}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.la_sku
  retention_in_days   = 30
}

resource "azurerm_application_insights" "example" {
  name                = "tomcat-appinsights-${var.suffix}"
  location            = var.location
  resource_group_name = var.rg_name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"
}

resource "azurerm_storage_account" "example" {
  name                     = "tomcatsa${var.suffix}"
  location                 = var.location
  resource_group_name      = var.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
