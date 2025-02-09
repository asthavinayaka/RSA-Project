data "azurerm_subnet" "frontend_subnet" {
    for_each = var.frontend_vm_details
    name = each.value.subnet_name
    resource_group_name = each.value.resource_group_name
    virtual_network_name = each.value.virtual_network_name
}

data "azurerm_key_vault" "kv" {
    for_each = var.frontend_vm_details
    name = each.value.key_vault_name
    resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "usec" {
  for_each = var.frontend_vm_details
  name = "demouser"
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_key_vault_secret" "psec" {
  for_each = var.frontend_vm_details
  name = "password"
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}