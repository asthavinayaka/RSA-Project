variable "db_details" {
  type = map(object({
    name = string
    ua_name = string
    location = string
    resource_group_name = string
    key_vault_name = string
  }))
}