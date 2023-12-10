resource "azurerm_resource_group" "rg_vnet1" {
  name     = "${var.prefix}-Terraform-RG-1"
  location = var.region
}

resource "azurerm_resource_group" "rg_vnet2" {
  name     = "${var.prefix}-Terraform-RG-2"
  location = var.region
}