resource "azurerm_public_ip" "pip" {
  for_each = var.bas_details
  name = each.value.pip_name
  resource_group_name = each.value.resource_group_name
  location = each.value.location
  allocation_method = "Static"
}


resource "azurerm_bastion_host" "bastion" {
    for_each = var.bas_details
    name = each.value.name
    location = each.value.location
    resource_group_name = each.value.resource_group_name

    dynamic "ip_configuration" {
        for_each = each.value.ip_configuration
        content {
            name = ip_configuration.value.name
            subnet_id = data.azurerm_subnet.bassub[each.key].id
            public_ip_address_id = azurerm_public_ip.pip[each.key].id
        }    
    }
}