#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "keyvault"
}

#Accesses configuration of AzureRM provider - Current argument retrevies current client configuration
data "azurerm_client_config" "current" {}
#Keyvault Creation
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg_vnet1]
  name                        = random_id.kvname.hex
  location                    = azurerm_resource_group.rg_vnet1.location
  resource_group_name         = azurerm_resource_group.rg_vnet1.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

#Create KeyVault VM password
resource "random_password" "vm_one_password" {
  length  = 20
  special = true
}

resource "random_password" "vm_two_password" {
  length  = 20
  special = true
}

resource "random_password" "vmss_password" {
  length  = 20
  special = true
}

#Create Key Vault Secret
resource "azurerm_key_vault_secret" "vm_one_password_secret" {
  name         = "${var.prefix}-VM-ONE-IIS-Secret"
  value        = random_password.vm_one_password.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}

resource "azurerm_key_vault_secret" "vm_two_password_secret" {
  name         = "${var.prefix}-VM-TWO-SECRET"
  value        = random_password.vm_two_password.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}

resource "azurerm_key_vault_secret" "vmss_password_secret" {
  count        = 3
  name         = "${var.prefix}-vmss-password-${count.index}"
  value        = random_password.vmss_password.result
  key_vault_id = azurerm_key_vault.kv1.id
}

data "azurerm_key_vault_secret" "vmss_password_secret" {
  count        = 3
  name         = azurerm_key_vault_secret.vmss_password_secret[count.index].name
  key_vault_id = azurerm_key_vault.kv1.id
}