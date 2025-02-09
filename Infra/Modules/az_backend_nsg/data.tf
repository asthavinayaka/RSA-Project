data "azurerm_subnet" "backend_subnet" {
    for_each = var.backend_nsg_details
    name = each.value.subnet_name
    resource_group_name = each.value.resource_group_name
    virtual_network_name = each.value.virtual_network_name
}