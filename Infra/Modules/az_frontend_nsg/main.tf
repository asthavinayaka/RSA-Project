resource "azurerm_network_security_group" "frontend_nsg" {
    for_each = var.frontend_nsg_details
    name                = each.value.nsg_name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "allow_http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = join(",", var.allowed_front_end_ips)
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

resource "azurerm_subnet_network_security_group_association" "frontend_nsg_association" {
    for_each = var.frontend_nsg_details
    subnet_id                 = data.azurerm_subnet.frontend_subnet[each.key].id
    network_security_group_id = azurerm_network_security_group.frontend_nsg[each.key].id
}