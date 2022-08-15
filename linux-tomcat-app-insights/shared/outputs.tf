output "la_id" {
  value = azurerm_log_analytics_workspace.example.id
}

output "instrumentation_key" {
  value = azurerm_application_insights.example.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.example.id
}

output "sa_id" {
  value = azurerm_storage_account.example.id
}