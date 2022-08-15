output "la_id" {
  value = azurerm_log_analytics_workspace.tomcat.id
}

output "app_insights_conn_string" {
  value = azurerm_application_insights.tomcat.connection_string
}

output "app_id" {
  value = azurerm_application_insights.tomcat.id
}

output "sa_id" {
  value = azurerm_storage_account.tomcat.id
}