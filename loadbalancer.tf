##PIP for Loadbalancer - VMSS
resource "azurerm_public_ip" "vmss_pip_lb" {
  name                = "${var.prefix}-PublicIPForLB"
  location            = azurerm_resource_group.rg_vnet2.location
  resource_group_name = azurerm_resource_group.rg_vnet2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

##Loadbalancer - VMSS
resource "azurerm_lb" "vmss_lb" {
  name                = "${var.prefix}-vmss-lb"
  location            = azurerm_resource_group.rg_vnet2.location
  resource_group_name = azurerm_resource_group.rg_vnet2.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.prefix}-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss_pip_lb.id
  }
}

##Loadbalancer BackendPool
resource "azurerm_lb_backend_address_pool" "vmss_be_pool" {
  loadbalancer_id    = azurerm_lb.vmss_lb.id
  name               = "${var.prefix}-BackEndAddressPool"
}

// Probe is cheking health of backend resources
resource "azurerm_lb_probe" "vmss_probe" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "TCP-probe"
  protocol        = "Tcp"
  port            = 80
}

// Rule/s for loadbalancer
resource "azurerm_lb_rule" "lb_rule_http" {
  name                           = "AllowHTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.vmss_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.vmss_probe.id
  loadbalancer_id                = azurerm_lb.vmss_lb.id
}