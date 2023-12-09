resource "azurerm_public_ip" "vm1_pip" {
  name                = "${var.prefix}-vm1-pip1"
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm1_nic" {
  name                = "${var.prefix}-vm1-nic1"
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name

  ip_configuration {
    name                          = "${var.prefix}-config-nic1"
    subnet_id                     = azurerm_subnet.vnet1_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1_pip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "${var.prefix}-VM-One-IIS"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg_vnet1.name
  location            = azurerm_resource_group.rg_vnet1.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureadmin"
  admin_password      = azurerm_key_vault_secret.vm_one_password_secret.value

  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "powershell_script" {
  name                 = "Install-IIS"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/PCavar/Azure-TF-Manage-Virtual-Machines/main/install-IIS.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File routingScript.ps1"
    }
  SETTINGS

    tags = {
    environment = "${var.prefix}-ps1"
  }
}