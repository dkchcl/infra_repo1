resource "azurerm_mssql_database" "db" {
  for_each = var.sql_databases

  name      = each.value.db_name
  server_id = data.azurerm_mssql_server.sql_server[each.key].id

  auto_pause_delay_in_minutes                                = try(each.value.auto_pause_delay_in_minutes, null)
  create_mode                                                = try(each.value.create_mode, null)
  collation                                                  = try(each.value.collation, null)
  elastic_pool_id                                            = try(each.value.elastic_pool_id, null)
  enclave_type                                               = try(each.value.enclave_type, null)
  geo_backup_enabled                                         = try(each.value.geo_backup_enabled, null)
  maintenance_configuration_name                             = try(each.value.maintenance_configuration_name, null)
  ledger_enabled                                             = try(each.value.ledger_enabled, null)
  license_type                                               = try(each.value.license_type, null)
  max_size_gb                                                = try(each.value.max_size_gb, null)
  min_capacity                                               = try(each.value.min_capacity, null)
  restore_point_in_time                                      = try(each.value.restore_point_in_time, null)
  recover_database_id                                        = try(each.value.recover_database_id, null)
  recovery_point_id                                          = try(each.value.recovery_point_id, null)
  restore_dropped_database_id                                = try(each.value.restore_dropped_database_id, null)
  restore_long_term_retention_backup_id                      = try(each.value.restore_long_term_retention_backup_id, null)
  read_replica_count                                         = try(each.value.read_replica_count, null)
  read_scale                                                 = try(each.value.read_scale, null)
  sample_name                                                = try(each.value.sample_name, null)
  sku_name                                                   = try(each.value.sku_name, null)
  storage_account_type                                       = try(each.value.storage_account_type, null)
  transparent_data_encryption_enabled                        = try(each.value.transparent_data_encryption_enabled, null)
  transparent_data_encryption_key_vault_key_id               = try(each.value.transparent_data_encryption_key_vault_key_id, null)
  transparent_data_encryption_key_automatic_rotation_enabled = try(each.value.transparent_data_encryption_key_automatic_rotation_enabled, null)
  zone_redundant                                             = try(each.value.zone_redundant, null)
  secondary_type                                             = try(each.value.secondary_type, null)
  tags                                                       = try(each.value.tags, null)

  dynamic "import" {
    for_each = try(each.value.import != null ? [each.value.import] : [], [])
    content {
      storage_uri                  = try(import.value.storage_uri, null)
      storage_key                  = try(import.value.storage_key, null)
      storage_key_type             = try(import.value.storage_key_type, null)
      administrator_login          = try(import.value.administrator_login, null)
      administrator_login_password = try(import.value.administrator_login_password, null)
      authentication_type          = try(import.value.authentication_type, null)
      storage_account_id           = try(import.value.storage_account_id, null)
    }
  }

  dynamic "identity" {
    for_each = try(each.value.identity != null ? [each.value.identity] : [], [])
    content {
      type         = try(identity.value.type, null)
      identity_ids = try(identity.value.identity_ids, [])
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = try(each.value.short_term_retention_policy != null ? [each.value.short_term_retention_policy] : [], [])
    content {
      retention_days           = try(short_term_retention_policy.value.retention_days, null)
      backup_interval_in_hours = try(short_term_retention_policy.value.backup_interval_in_hours, null)
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = try(each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : [], [])
    content {
      weekly_retention  = try(long_term_retention_policy.value.weekly_retention, null)
      monthly_retention = try(long_term_retention_policy.value.monthly_retention, null)
      yearly_retention  = try(long_term_retention_policy.value.yearly_retention, null)
      week_of_year      = try(long_term_retention_policy.value.week_of_year, null)
    }
  }

  dynamic "threat_detection_policy" {
    for_each = try(each.value.threat_detection_policy != null ? [each.value.threat_detection_policy] : [], [])
    content {
      state                      = try(threat_detection_policy.value.state, null)
      disabled_alerts            = try(threat_detection_policy.value.disabled_alerts, null)
      email_account_admins       = try(threat_detection_policy.value.email_account_admins, null)
      email_addresses            = try(threat_detection_policy.value.email_addresses, null)
      retention_days             = try(threat_detection_policy.value.retention_days, null)
      storage_account_access_key = try(threat_detection_policy.value.storage_account_access_key, null)
      storage_endpoint           = try(threat_detection_policy.value.storage_endpoint, null)
    }
  }
}
