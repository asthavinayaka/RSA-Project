variable "vnet_details" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnet     = map(object({
      name             = string
      address_prefixes = list(string)
    }))
  }))
}