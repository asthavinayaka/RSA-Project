resource "azurerm_network_security_group" "db-nsg" {
    for_each = var.db_nsg_details
    name                = each.value.nsg_name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name

    security_rule {
    name                       = "AllowBackendToDB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "3306"  # For MySQL or your DB port
    source_address_prefix     = "10.116.10.0/24"  # Backend subnet IP range
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

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
    for_each = var.db_nsg_details
    subnet_id                 = data.azurerm_subnet.db_subnet[each.key].id
    network_security_group_id = azurerm_network_security_group.db-nsg[each.key].id
  
}