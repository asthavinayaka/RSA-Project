variable "kv_details" {
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