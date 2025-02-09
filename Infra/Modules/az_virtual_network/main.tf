resource "azurerm_virtual_network" "vnet_details" {
    for_each = var.vnet_details
    name = each.value.name
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    address_space = each.value.address_space

    dynamic "subnet" {
        for_each = each.value.subnet
        content {
            name = subnet.value.name
            address_prefixes = subnet.value.address_prefixes
        }
      
    }
    tags = {
        environment = "Dev"
    }
}

