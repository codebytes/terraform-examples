resource "azurerm_log_analytics_workspace" "tomcat" {
  name                = "law-tomcat-${var.suffix}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.la_sku
  retention_in_days   = 30
}

resource "azurerm_application_insights" "tomcat" {
  name                = "tomcat-appinsights-${var.suffix}"
  location            = var.location
  resource_group_name = var.rg_name
  workspace_id        = azurerm_log_analytics_workspace.tomcat.id
  application_type    = "web"
}

resource "azurerm_storage_account" "tomcat" {
  name                     = "tomcatsa${var.suffix}"
  location                 = var.location
  resource_group_name      = var.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_action_group" "tomcat" {
  name                = var.action_group_name
  resource_group_name = var.rg_name
  short_name          = "action"
}