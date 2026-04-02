variable "sql_servers" {
  description = "Map of SQL Servers to create"
  type = map(object({
    # Required
    name                = string
    resource_group_name = string
    location            = string
    version             = string
    key_vault_name      = optional(string)
    secret_name         = optional(string)
    secret_password     = optional(string)
    # Optional
    administrator_login_password_wo              = optional(string)
    administrator_login_password_wo_version      = optional(number)
    connection_policy                            = optional(string)
    express_vulnerability_assessment_enabled     = optional(bool)
    transparent_data_encryption_key_vault_key_id = optional(string)
    minimum_tls_version                          = optional(string)
    public_network_access_enabled                = optional(bool)
    outbound_network_restriction_enabled         = optional(bool)
    primary_user_assigned_identity_id            = optional(string)
    tags                                         = optional(map(string))

    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool)
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

  }))
}



