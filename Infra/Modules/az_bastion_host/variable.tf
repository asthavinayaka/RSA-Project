variable "bas_details" {
  type = map(object({
    name = string
    pip_name = string
    resource_group_name = string
    virtual_network_name = string
    location = string
    subnet_name = string
    ip_configuration = map(object({
      name = string
    }))
  }))
}