data "azurerm_key_vault" "kv" {
  for_each = var.sql_servers
  name     = each.value.key_vault_name
  #   resource_group_name = each.value.resource_group_name
  resource_group_name = "dev_rg_01"
}

data "azurerm_key_vault_secret" "kvs" {
  for_each     = var.sql_servers
  name         = each.value.secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_key_vault_secret" "kvs1" {
  for_each     = var.sql_servers
  name         = each.value.secret_password
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}



