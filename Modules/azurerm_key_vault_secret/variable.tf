variable "key_vault_secrets" {
  type = map(object({
    secret_name         = string
    secret_value        = string
    key_vault_name      = optional(string)
    resource_group_name = optional(string)
    value_wo            = optional(string)
    value_wo_version    = optional(number)
    content_type        = optional(string)
    not_before_date     = optional(string)
    expiration_date     = optional(string)
    tags                = optional(map(string))
  }))
}


