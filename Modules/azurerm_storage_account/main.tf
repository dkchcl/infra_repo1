resource "azurerm_storage_account" "stg" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  account_kind                      = try(each.value.account_kind, "StorageV2")
  provisioned_billing_model_version = try(each.value.provisioned_billing_model_version, null)
  cross_tenant_replication_enabled  = try(each.value.cross_tenant_replication_enabled, false)
  access_tier                       = try(each.value.access_tier, "Hot")
  edge_zone                         = try(each.value.edge_zone, null)
  https_traffic_only_enabled        = try(each.value.https_traffic_only_enabled, true)
  min_tls_version                   = try(each.value.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public   = try(each.value.allow_nested_items_to_be_public, true)
  shared_access_key_enabled         = try(each.value.shared_access_key_enabled, true)
  public_network_access_enabled     = try(each.value.public_network_access_enabled, true)
  default_to_oauth_authentication   = try(each.value.default_to_oauth_authentication, false)
  is_hns_enabled                    = try(each.value.is_hns_enabled, false)
  nfsv3_enabled                     = try(each.value.nfsv3_enabled, false)
  large_file_share_enabled          = try(each.value.large_file_share_enabled, false)
  local_user_enabled                = try(each.value.local_user_enabled, true)
  queue_encryption_key_type         = try(each.value.queue_encryption_key_type, "Service")
  table_encryption_key_type         = try(each.value.table_encryption_key_type, "Service")
  infrastructure_encryption_enabled = try(each.value.infrastructure_encryption_enabled, false)
  allowed_copy_scope                = try(each.value.allowed_copy_scope, null)
  sftp_enabled                      = try(each.value.sftp_enabled, false)
  dns_endpoint_type                 = try(each.value.dns_endpoint_type, "Standard")
  tags                              = try(each.value.tags, {})


  dynamic "custom_domain" {
    for_each = each.value.custom_domain != null ? [each.value.custom_domain] : []
    content {
      name          = custom_domain.value.name
      use_subdomain = try(custom_domain.value.use_subdomain, null)
    }
  }

  dynamic "customer_managed_key" {
    for_each = each.value.customer_managed_key != null ? [each.value.customer_managed_key] : []
    content {
      key_vault_key_id          = try(customer_managed_key.value.key_vault_key_id, null)
      managed_hsm_key_id        = try(customer_managed_key.value.managed_hsm_key_id, null)
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  dynamic "network_rules" {
    for_each = each.value.network_rules != null ? [each.value.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = try(network_rules.value.bypass, null)
      ip_rules                   = try(network_rules.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, null)

      dynamic "private_link_access" {
        for_each = try(network_rules.value.private_link_access, [])
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = each.value.blob_properties != null ? [each.value.blob_properties] : []
    content {
      versioning_enabled            = try(blob_properties.value.versioning_enabled, null)
      change_feed_enabled           = try(blob_properties.value.change_feed_enabled, null)
      change_feed_retention_in_days = try(blob_properties.value.change_feed_retention_in_days, null)
      default_service_version       = try(blob_properties.value.default_service_version, null)
      last_access_time_enabled      = try(blob_properties.value.last_access_time_enabled, null)

      dynamic "delete_retention_policy" {
        for_each = try([blob_properties.value.delete_retention_policy], [])
        content {
          days                     = try(delete_retention_policy.value.days, null)
          permanent_delete_enabled = try(delete_retention_policy.value.permanent_delete_enabled, null)
        }
      }

      dynamic "restore_policy" {
        for_each = try([blob_properties.value.restore_policy], [])
        content {
          days = restore_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try([blob_properties.value.container_delete_retention_policy], [])
        content {
          days = try(container_delete_retention_policy.value.days, null)
        }
      }

      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = each.value.queue_properties != null ? [each.value.queue_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = try(queue_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = try([queue_properties.value.logging], [])
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          write                 = logging.value.write
          version               = logging.value.version
          retention_policy_days = try(logging.value.retention_policy_days, null)
        }
      }

      dynamic "minute_metrics" {
        for_each = try([queue_properties.value.minute_metrics], [])
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = try(minute_metrics.value.include_apis, null)
          retention_policy_days = try(minute_metrics.value.retention_policy_days, null)
        }
      }

      dynamic "hour_metrics" {
        for_each = try([queue_properties.value.hour_metrics], [])
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = try(hour_metrics.value.include_apis, null)
          retention_policy_days = try(hour_metrics.value.retention_policy_days, null)
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = each.value.static_website != null ? [each.value.static_website] : []
    content {
      index_document     = try(static_website.value.index_document, null)
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }

  dynamic "share_properties" {
    for_each = each.value.share_properties != null ? [each.value.share_properties] : []
    content {

      dynamic "cors_rule" {
        for_each = try(share_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = try([share_properties.value.retention_policy], [])
        content {
          days = try(retention_policy.value.days, null)
        }
      }

      dynamic "smb" {
        for_each = try([share_properties.value.smb], [])
        content {
          versions                        = try(smb.value.versions, null)
          authentication_types            = try(smb.value.authentication_types, null)
          kerberos_ticket_encryption_type = try(smb.value.kerberos_ticket_encryption_type, null)
          channel_encryption_type         = try(smb.value.channel_encryption_type, null)
          multichannel_enabled            = try(smb.value.multichannel_enabled, null)
        }
      }
    }
  }

  dynamic "immutability_policy" {
    for_each = each.value.immutability_policy != null ? [each.value.immutability_policy] : []
    content {
      allow_protected_append_writes = try(immutability_policy.value.allow_protected_append_writes, null)
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }

  dynamic "sas_policy" {
    for_each = each.value.sas_policy != null ? [each.value.sas_policy] : []
    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = try(sas_policy.value.expiration_action, null)
    }
  }

  dynamic "azure_files_authentication" {
    for_each = each.value.azure_files_authentication != null ? [each.value.azure_files_authentication] : []
    content {
      directory_type                 = azure_files_authentication.value.directory_type
      default_share_level_permission = try(azure_files_authentication.value.default_share_level_permission, null)

      dynamic "active_directory" {
        for_each = try([azure_files_authentication.value.active_directory], [])
        content {
          domain_name         = active_directory.value.domain_name
          domain_guid         = active_directory.value.domain_guid
          domain_sid          = try(active_directory.value.domain_sid, null)
          storage_sid         = try(active_directory.value.storage_sid, null)
          forest_name         = try(active_directory.value.forest_name, null)
          netbios_domain_name = try(active_directory.value.netbios_domain_name, null)
        }
      }
    }
  }

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []
    content {
      publish_internet_endpoints  = try(routing.value.publish_internet_endpoints, null)
      publish_microsoft_endpoints = try(routing.value.publish_microsoft_endpoints, null)
      choice                      = try(routing.value.choice, null)
    }
  }
}






