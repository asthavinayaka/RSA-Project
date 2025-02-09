module "resource_group" {
    source = "../Modules/az_resource_group"
    rg_details = var.rg_map  
}

module "azurerm_virtual_network" {
    depends_on = [ module.resource_group ]
    source = "../Modules/az_virtual_network"
    vnet_details = var.vnet_map  
}

module "frontend_nsg" {
    depends_on = [ module.azurerm_virtual_network ]
    source = "../Modules/az_frontend_nsg"
    frontend_nsg_details = var.frontend_nsg_map
    allowed_front_end_ips = var.allowed_front_end_ips  
}

module "backend_nsg" {
    depends_on = [ module.azurerm_virtual_network ]
    source = "../Modules/az_backend_nsg"
    backend_nsg_details = var.backend_nsg_map  
}

module "db_nsg" {
    depends_on = [ module.azurerm_virtual_network ]
    source = "../Modules/az_db_nsg"
    db_nsg_details = var.db_nsg_map   
}

module "key_vault" {
    depends_on = [ module.resource_group ]
    source = "../Modules/az_key_vault"
    kv_details = var.kv_map  
}

module "bastion_host" {
    depends_on = [ module.resource_group, module.azurerm_virtual_network ]
    source = "../Modules/az_bastion_host"
    bas_details = var.bas_map   
}

module "frontend_vm" {
    depends_on = [ module.resource_group, module.azurerm_virtual_network, module.frontend_nsg ]
    source = "../Modules/az_frontend_vm"
    frontend_vm_details = var.frontend_vm_map  
}

module "backend_vm" {
    depends_on = [ module.resource_group, module.azurerm_virtual_network, module.backend_nsg, module.key_vault ]
    source = "../Modules/az_backend_vm"
    backend_vm_details = var.backend_vm_map    
}

module "db_server" {
    depends_on = [ module.resource_group, module.azurerm_virtual_network, module.db_nsg ]
    source = "../Modules/az_db_server"
    db_details = var.db_map  
}

module "application_gateway" {
    depends_on = [ module.resource_group, module.azurerm_virtual_network, module.frontend_nsg ]
    source = "../Modules/az_application_gateway"
    ag_details = var.ag_map  
  
}