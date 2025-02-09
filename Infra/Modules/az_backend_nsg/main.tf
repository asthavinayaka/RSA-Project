resource "azurerm_network_security_group" "backend_nsg" {
    for_each = var.backend_nsg_details
    name                = each.value.nsg_name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "allow_backend_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.116.5.0/24"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                  = "*"
    source_port_range         = "*"
    destination_port_range    = "*"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }

    tags = {
        environment = "Dev"
    }
  
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg_association" {
    for_each = var.backend_nsg_details
    subnet_id                 = data.azurerm_subnet.backend_subnet[each.key].id
    network_security_group_id = azurerm_network_security_group.backend_nsg[each.key].id
  
}