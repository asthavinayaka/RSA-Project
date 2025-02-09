data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
    for_each = var.db_details
    name = each.value.key_vault_name
    resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "psec" {
  for_each = var.db_details
  name = "password"
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}