resource "azurerm_public_ip" "ag-pip" {
  for_each            = var.ag_details
  name                = "${each.value.name}-pip"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_application_gateway" "appgw" {
  for_each            = var.ag_details
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
  }
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = data.azurerm_subnet.agsubnet[each.key].id
  }
  frontend_port {
    name = "port80"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = azurerm_public_ip.ag-pip[each.key].id
  }
  backend_address_pool {
    name = "appGatewayBackendPool"
  }
  backend_http_settings {
    name                  = "appGatewayBackendHttpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }
  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_port_name             = "fportip"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    protocol                       = "Http"

  }
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    priority                   = 10
    http_listener_name         = "appGatewayHttpListener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "appGatewayBackendHttpSettings"
  }

}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "fip-asso1" {
  for_each                = var.ag_details
  network_interface_id    = data.azurerm_network_interface.vmnic1[each.key].id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgw[each.key].backend_address_pool).0.id
}
