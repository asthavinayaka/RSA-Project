variable "rg_details" {
  type = map(object({
    name     = string
    location = string
  }))
}