variable "rg_map" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "vnet_map" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnet = map(object({
      name             = string
      address_prefixes = list(string)
    }))
  }))
}

variable "allowed_front_end_ips" {
  description = "List of IP addresses allowed to access the front-end"
  type        = list(string)
  default     = ["203.0.113.0/24", "198.51.100.0/24"]  # Example IP ranges
}


variable "frontend_nsg_map" {
    type = map(object({
        nsg_name            = string
        location            = string
        resource_group_name = string
        subnet_name         = string
        virtual_network_name = string
    }))  
}

variable "backend_nsg_map" {
    type = map(object({
        nsg_name            = string
        location            = string
        resource_group_name = string
        subnet_name         = string
        virtual_network_name = string
    }))  
}
variable "db_nsg_map" {
    type = map(object({
        nsg_name            = string
        location            = string
        resource_group_name = string
        subnet_name         = string
        virtual_network_name = string
    }))  
  
}

variable "kv_map" {
  type = map(object({
    name = string
    location = string
    resource_group_name = string
    uname = string
    upass = string
    ai_name = string
    kv_name = string
  }))
}

variable "bas_map" {
  type = map(object({
    name = string
    pip_name = string
    resource_group_name = string
    location = string
    subnet_name = string
    virtual_network_name = string
    ip_configuration = map(object({
      name = string
    }))
  }))
}

variable "frontend_vm_map" {
  type = map(object({
    name = string
    nic_name = string
    location = string
    resource_group_name = string
    virtual_network_name = string
    subnet_name = string
    key_vault_name = string
    size = string
    ip_configuration = map(object({
      name = string
    }))
  }))
}

variable "backend_vm_map" {
  type = map(object({
    name = string
    nic_name = string
    location = string
    resource_group_name = string
    virtual_network_name = string
    subnet_name = string
    key_vault_name = string
    size = string
    ip_configuration = map(object({
      name = string
    }))
  }))
}

variable "db_map" {
  type = map(object({
    name = string
    ua_name = string
    location = string
    resource_group_name = string
    key_vault_name = string
  }))
}

variable "ag_map" {
  type = map(object({
    name               = string
    resource_group_name = string
    location           = string
    subnet_name        = string
    nic_name           = string
    virtual_network_name = string
  }))
}