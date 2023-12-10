resource "azurerm_network_security_group" "nsg_vnet1" {
  name                = "${var.prefix}-vnet1-NSG"
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name
}

resource "azurerm_network_security_group" "nsg_vnet2" {
  name                = "${var.prefix}-vnet2-vmss-NSG"
  location            = azurerm_resource_group.rg_vnet2.location
  resource_group_name = azurerm_resource_group.rg_vnet2.name
}

resource "azurerm_subnet_network_security_group_association" "vnet1_sub1" {
  subnet_id                 = azurerm_subnet.vnet1_subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_vnet1.id
}

resource "azurerm_subnet_network_security_group_association" "vnet2_sub2" {
  subnet_id                 = azurerm_subnet.vnet2_subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg_vnet2.id
}

resource "azurerm_network_security_rule" "AllowRDP_vnet1" {
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

resource "azurerm_network_security_rule" "AllowHTTP_vnet1" {
  name                        = "AllowHTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_vnet1.name
  network_security_group_name = azurerm_network_security_group.nsg_vnet1.name
}

resource "azurerm_network_security_rule" "AllowRDP_vnet2" {
  name                        = "Custom-Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_vnet2.name
  network_security_group_name = azurerm_network_security_group.nsg_vnet2.name
}