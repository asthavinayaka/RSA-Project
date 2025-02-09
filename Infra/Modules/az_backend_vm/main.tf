resource "azurerm_network_interface" "nic" {
    for_each = var.backend_vm_details
    name = each.value.nic_name
    location = each.value.location
    resource_group_name = each.value.resource_group_name

    dynamic "ip_configuration" {
      for_each = each.value.ip_configuration
      content {
        name = ip_configuration.value.name
        subnet_id = data.azurerm_subnet.backend_subnet[each.key].id
        private_ip_address_allocation = "Dynamic"
      }
    }
}

resource "azurerm_linux_virtual_machine" "linvm" {
  for_each = var.backend_vm_details
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  size = each.value.size
  admin_username = data.azurerm_key_vault_secret.usec[each.key].value
  admin_password = data.azurerm_key_vault_secret.psec[each.key].value
  disable_password_authentication = false
  network_interface_ids = [ azurerm_network_interface.nic[each.key].id ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
}