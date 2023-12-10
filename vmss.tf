resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                 = "${var.prefix}-vmss"
  resource_group_name  = azurerm_resource_group.rg_vnet2.name
  location             = azurerm_resource_group.rg_vnet2.location
  sku                  = "Standard_D2s_v3"
  instances            = 3
  admin_password       = data.azurerm_key_vault_secret.vmss_password_secret[0].value
  admin_username       = "azureadmin"
  computer_name_prefix = "${var.prefix}-"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.prefix}-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.vnet2_subnet2.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss_bpepool.id]
    }
  }

  tags = {
    environment = "${var.prefix}-vmss"
  }
}