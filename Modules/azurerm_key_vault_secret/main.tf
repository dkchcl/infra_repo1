resource "azurerm_key_vault_secret" "kvs_users" {
  for_each     = var.key_vault_secrets
  name         = each.value.secret_name
  value        = each.value.secret_value
  key_vault_id = data.azurerm_key_vault.kv[each.key].id

  value_wo         = lookup(each.value, "value_wo", null)
  value_wo_version = lookup(each.value, "value_wo_version", null)
  content_type     = lookup(each.value, "content_type", null)
  not_before_date  = lookup(each.value, "not_before_date", null)
  expiration_date  = lookup(each.value, "expiration_date", null)
  tags             = lookup(each.value, "tags", null)
}

# resource "azurerm_key_vault_secret" "kvs_password" {
#   for_each     = var.key_vault_secrets
#   name         = each.value.kv_secret_password
#   value        = each.value.kv_secret_password_value
#   key_vault_id = data.azurerm_key_vault.kv[each.key].id

#   value_wo         = lookup(each.value, "value_wo", null)
#   value_wo_version = lookup(each.value, "value_wo_version", null)
#   content_type     = lookup(each.value, "content_type", null)
#   not_before_date  = lookup(each.value, "not_before_date", null)
#   expiration_date  = lookup(each.value, "expiration_date", null)
#   tags             = lookup(each.value, "tags", null)
# }






