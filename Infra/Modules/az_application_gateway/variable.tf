variable "ag_details" {
  type = map(object({
    name               = string
    resource_group_name = string
    location           = string
    subnet_name        = string
    nic_name           = string
    virtual_network_name = string
  }))
}