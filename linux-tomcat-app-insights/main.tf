data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "shared_rg" {
  name     = local.shared_rg
  location = local.location
}
resource "azurerm_resource_group" "vm_rg" {
  name     = local.vm_rg
  location = local.location
}

module "shared" {
  source = "./shared"
  rg_name = azurerm_resource_group.shared_rg.name
}

module "vm" {
  source = "./vm"
  rg_name = azurerm_resource_group.vm_rg.name
}