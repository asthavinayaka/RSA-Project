variable "frontend_vm_details" {
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