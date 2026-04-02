resource "azurerm_key_vault" "kv" {
  for_each                        = var.key_vaults
  name                            = each.value.key_vault_name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  sku_name                        = each.value.sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  purge_protection_enabled        = each.value.purge_protection_enabled
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  rbac_authorization_enabled      = each.value.rbac_authorization_enabled
  public_network_access_enabled   = each.value.public_network_access_enabled
  tags                            = each.value.tags

  dynamic "access_policy" {
    for_each = each.value.access_policy == null ? [] : [each.value.access_policy]

    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      application_id          = lookup(access_policy.value, "application_id", null)
      key_permissions         = lookup(access_policy.value, "key_permissions", [])
      secret_permissions      = lookup(access_policy.value, "secret_permissions", [])
      storage_permissions     = lookup(access_policy.value, "storage_permissions", [])
      certificate_permissions = lookup(access_policy.value, "certificate_permissions", [])
    }
  }

  dynamic "network_acls" {
    for_each = each.value.network_acls == null ? [] : [each.value.network_acls]

    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
}



