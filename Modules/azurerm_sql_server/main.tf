resource "azurerm_mssql_server" "sql_server" {
  for_each            = var.sql_servers
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  version             = each.value.version

  administrator_login                          = data.azurerm_key_vault_secret.kvs[each.key].value
  administrator_login_password                 = data.azurerm_key_vault_secret.kvs1[each.key].value
  administrator_login_password_wo              = try(each.value.administrator_login_password_wo, null)
  administrator_login_password_wo_version      = try(each.value.administrator_login_password_wo_version, null)
  connection_policy                            = try(each.value.connection_policy, null)
  express_vulnerability_assessment_enabled     = try(each.value.express_vulnerability_assessment_enabled, null)
  transparent_data_encryption_key_vault_key_id = try(each.value.transparent_data_encryption_key_vault_key_id, null)
  minimum_tls_version                          = try(each.value.minimum_tls_version, null)
  public_network_access_enabled                = try(each.value.public_network_access_enabled, null)
  outbound_network_restriction_enabled         = try(each.value.outbound_network_restriction_enabled, null)
  primary_user_assigned_identity_id            = try(each.value.primary_user_assigned_identity_id, null)
  tags                                         = try(each.value.tags, null)

  dynamic "azuread_administrator" {
    for_each = try(each.value.azuread_administrator != null ? [each.value.azuread_administrator] : [], [])
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = try(azuread_administrator.value.tenant_id, null)
      azuread_authentication_only = try(azuread_administrator.value.azuread_authentication_only, false)
    }
  }

  dynamic "identity" {
    for_each = try(each.value.identity != null ? [each.value.identity] : [], [])
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
}
