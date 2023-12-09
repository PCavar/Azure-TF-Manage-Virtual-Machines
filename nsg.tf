resource "azurerm_network_security_group" "nsg_vnet1" {
  name                = "${var.prefix}-NSG"
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name
}

resource "azurerm_subnet_network_security_group_association" "vnet1_sub1" {
  subnet_id                 = azurerm_subnet.vnet1_subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_vnet1.id
}

resource "azurerm_network_security_rule" "AllowRDP" {
  name                        = "AllowRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_vnet1.name
  network_security_group_name = azurerm_network_security_group.nsg_vnet1.name
}