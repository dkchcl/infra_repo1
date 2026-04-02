data "azurerm_mssql_server" "sql_server" {
  for_each            = var.sql_databases
  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
}

