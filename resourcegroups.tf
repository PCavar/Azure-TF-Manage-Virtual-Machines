resource "azurerm_resource_group" "rg_vnet1" {
  name     = "${var.prefix}-Terraform-RG"
  location = var.region
}