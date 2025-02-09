resource "azurerm_user_assigned_identity" "UserAssignedIdentity" {
  for_each            = var.kv_details
  name                = each.value.ai_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_key_vault" "kv" {
  for_each                   = var.kv_details
  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = data.azurerm_client_config.client_config.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.client_config.tenant_id
    object_id = data.azurerm_client_config.client_config.object_id

    key_permissions     = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"]
    secret_permissions  = ["List", "Get", "Set", "Delete", "Purge", "Recover"]
    storage_permissions = ["List", "Get"]
  }

  access_policy {
    tenant_id = azurerm_user_assigned_identity.UserAssignedIdentity[each.key].tenant_id
    object_id = azurerm_user_assigned_identity.UserAssignedIdentity[each.key].principal_id

    key_permissions = ["Get", "WrapKey", "UnwrapKey"]
  }
}

resource "random_password" "ranpas" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "kvs-usr" {
  for_each     = var.kv_details
  name         = each.value.uname
  value        = "demouser"
  key_vault_id = azurerm_key_vault.kv[each.key].id

}

resource "azurerm_key_vault_secret" "kvs-pass" {
  for_each     = var.kv_details
  name         = each.value.upass
  value        = random_password.ranpas.result
  key_vault_id = azurerm_key_vault.kv[each.key].id
}

resource "azurerm_key_vault_key" "example" {
  for_each = var.kv_details
  name         = each.value.kv_name
  key_vault_id = azurerm_key_vault.kv[each.key].id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = ["unwrapKey", "wrapKey"]
}
