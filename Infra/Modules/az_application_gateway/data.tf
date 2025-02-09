data "azurerm_subnet" "agsubnet" {
    for_each = var.ag_details
    name = each.value.subnet_name
    resource_group_name = each.value.resource_group_name
    virtual_network_name = each.value.virtual_network_name
}

data "azurerm_network_interface" "vmnic1" {
  for_each = var.ag_details
  name = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}