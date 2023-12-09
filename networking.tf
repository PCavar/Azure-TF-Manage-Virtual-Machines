resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet1"
  address_space       = [var.virtual_network_one]
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name
}

resource "azurerm_subnet" "vnet1_subnet1" {
  name                 = "${var.prefix}-subnet1"
  resource_group_name  = azurerm_resource_group.rg_vnet1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.subnet_one]
}
