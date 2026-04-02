variable "key_vaults" {
  description = "Azure Key Vault configurations"
  type = map(object({
    key_vault_name      = string
    location            = string
    resource_group_name = string
    sku_name            = string
    # tenant_id                       = string
    enabled_for_disk_encryption     = optional(bool, false)
    soft_delete_retention_days      = optional(number, 90)
    purge_protection_enabled        = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    rbac_authorization_enabled      = optional(bool, false)
    tags                            = optional(map(string), {})

    access_policy = optional(object({
      # tenant_id               = string
      # object_id               = string
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      storage_permissions     = optional(list(string))
    }))

    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)

  }))
}




