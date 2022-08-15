
resource "azurerm_virtual_network" "vnet_default" {
  name                = "vnet-default"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "vm" {
  name                 = "snet-vm"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_default.name
  address_prefixes     = ["10.0.0.0/16"]
}

resource "azurerm_public_ip" "tomcat_vm" {
  name                = "pip-tomcat-${var.vm_suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tomcat_vm" {
  name                = "nic-tomcat-${var.vm_suffix}"
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tomcat_vm.id
  }
}

resource "azurerm_network_security_group" "tomcat" {
  # Workaround https://github.com/hashicorp/terraform/issues/24663
  depends_on = [
    azurerm_network_interface.tomcat_vm,
  ]
  name                = "nsg-tomcat"
  resource_group_name = var.rg_name
  location            = var.location

  security_rule {
    name                       = "tomcat"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_tomcat" {
  # Workaround https://github.com/hashicorp/terraform/issues/24663
  depends_on = [
    azurerm_network_interface.tomcat_vm,
    azurerm_network_security_group.tomcat
  ]
  network_interface_id      = azurerm_network_interface.tomcat_vm.id
  network_security_group_id = azurerm_network_security_group.tomcat.id
}

resource "azurerm_linux_virtual_machine" "tomcat_vm" {
  # Workaround https://github.com/hashicorp/terraform/issues/24663
  depends_on = [
    azurerm_network_interface.tomcat_vm,
    azurerm_network_interface_security_group_association.nic_tomcat
  ]
  name                            = "vm-tomcat-${var.vm_suffix}"
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_user
  disable_password_authentication = true
  allow_extension_operations      = true
  network_interface_ids = [
    azurerm_network_interface.tomcat_vm.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.vm_admin_user
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "vm-tomcat-${var.vm_suffix}"
  virtual_machine_id         = azurerm_linux_virtual_machine.tomcat_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  // Required for Terraform, but optional for the extensions
  settings = <<SETTINGS
    {
        "dummy": "dummy"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "vmext" {
  name                = "${azurerm_linux_virtual_machine.tomcat_vm.name}-vmext"
  depends_on = [
    azurerm_virtual_machine_extension.ama
  ]
  virtual_machine_id  = azurerm_linux_virtual_machine.tomcat_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROT
    {
        "script": "${base64encode(templatefile("./vm/init.tftpl", {app_insights_conn_string = var.app_insights_conn_string}))}"
    }
    PROT
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_default.name
  address_prefixes     = ["10.1.0.0/26"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-tomcat" {
  name                = "bastion-tomcat"
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
