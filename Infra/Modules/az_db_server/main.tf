resource "azurerm_user_assigned_identity" "UserAssignedIdentity1" {
  for_each            = var.db_details
  name                = each.value.ua_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_mssql_server" "mssql" {
  for_each                     = var.db_details
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = "admindb"
  administrator_login_password = data.azurerm_key_vault_secret.psec[each.key].value
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = azurerm_user_assigned_identity.UserAssignedIdentity1[each.key].name
    object_id      = azurerm_user_assigned_identity.UserAssignedIdentity1[each.key].principal_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.UserAssignedIdentity1[each.key].id]
  }

  primary_user_assigned_identity_id            = azurerm_user_assigned_identity.UserAssignedIdentity1[each.key].id
  transparent_data_encryption_key_vault_key_id = data.azurerm_key_vault.kv[each.key].id

  tags = {
    environment = "dev"
  }
}
