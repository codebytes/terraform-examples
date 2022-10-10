
resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo-${var.env}"
  location = var.location
}