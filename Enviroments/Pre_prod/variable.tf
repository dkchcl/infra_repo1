# Variable for RGs
variable "rg_name" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

# Variable for virtual networks 

variable "vnet_name" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

    bgp_community                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string) # Edge zone (for latency-sensitive workloads)
    flow_timeout_in_minutes        = optional(number)
    private_endpoint_vnet_policies = optional(string)

    ddos_protection_plan = optional(object({
      id     = string
      enable = string
    }))

    encryption = optional(object({
      enforcement = string
    }))

    ip_address_pool = optional(object({ # Optional IP address pool (alternative to address_space)
      id                     = string
      number_of_ip_addresses = string
    }))
    tags = optional(map(string))
  }))
}

# Variable for Subnets

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    subnet_name                                   = string
    resource_group_name                           = string
    virtual_network_name                          = string
    address_prefixes                              = optional(list(string))
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    sharing_scope                                 = optional(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))

    delegation = optional(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = optional(list(string))
      }))
    }))

    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))

  }))
}

# Variable for Public IPs

variable "public_ip" {
  description = "Arguments for creating an Azure Public IP resource."
  type = map(object({
    pip_name                = string
    resource_group_name     = string
    location                = string
    allocation_method       = string
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string)
    edge_zone               = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ip_version              = optional(string)
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    sku                     = optional(string)
    sku_tier                = optional(string)
    tags                    = optional(map(string))
  }))
}

#Variable for NSGs

variable "nsgs" {
  type = map(object({
    nsg_name            = string
    location            = string
    resource_group_name = string

    security_rule = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      description                  = optional(string)
      source_port_range            = optional(string)
      destination_port_range       = optional(string)
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_ranges      = optional(list(string))
      source_address_prefixes      = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })))
    tags = optional(map(string))
  }))
}

# Variable for Subnet_nsg_association

variable "subnet_nsg_assoc" {

}

# Variable for Bastion Host

# variable "bastion_hosts" {
#   description = "Map of Bastion Hosts to create"
#   type = map(object({
#     bastion_host_name         = string 
#     resource_group_name       = string 
#     location                  = string 
#     virtual_network_name      = optional(string)
#     subnet_name               = optional(string)
#     pip_name                  = optional(string)
#     copy_paste_enabled        = optional(bool, true)         
#     file_copy_enabled         = optional(bool, false)        
#     sku                       = optional(string, "Basic")    
#     ip_connect_enabled        = optional(bool, false)        
#     kerberos_enabled          = optional(bool, false)        
#     scale_units               = optional(number, 2)         
#     shareable_link_enabled    = optional(bool, false)       
#     tunneling_enabled         = optional(bool, false)        
#     session_recording_enabled = optional(bool, false)        
#     tags                      = optional(map(string), {})    
#     zones                     = optional(list(string), null) 
#     ip_configuration = object({
#       name = string 
#     })
#   }))
# }

# Variable for Key Vaults & Key Vault Secrets

variable "key_vaults" {
  description = "Azure Key Vault configurations"
  type = map(object({
    key_vault_name      = string
    location            = string
    resource_group_name = string
    sku_name            = string
    enabled_for_disk_encryption     = optional(bool, false)
    soft_delete_retention_days      = optional(number, 90)
    purge_protection_enabled        = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    rbac_authorization_enabled      = optional(bool, false)
    tags                            = optional(map(string), {})

    access_policy = optional(object({
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

# Variable for NICs & VMs 

variable "vms" {
  # NIC -  
  description = "Configuration for Azure Linux Virtual Machines"
  type = map(object({
    nic_name             = optional(string)
    subnet_name          = optional(string)
    virtual_network_name = optional(string)
    pip_name             = optional(string)
    # network_interface_ids = optional(string)
    ip_configuration = optional(object({
      ip_config_name                = optional(string)
      private_ip_address_allocation = optional(string)
      subnet_id                     = optional(string)
      public_ip_address_id          = optional(string)
    }))

    # Virtual Machine
    vm_name             = string
    location            = string
    resource_group_name = string
    # network_interface_ids = list(string)
    size           = string
    key_vault_name = optional(string)
    secret_name    = optional(string)
    secret_value   = optional(string)
    os_disk = object({
      caching                          = string
      storage_account_type             = optional(string)
      name                             = optional(string)
      disk_size_gb                     = optional(number)
      disk_encryption_set_id           = optional(string)
      secure_vm_disk_encryption_set_id = optional(string)
      security_encryption_type         = optional(string)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }))
      write_accelerator_enabled = optional(bool)
    })

    # Optional Arguments
    disable_password_authentication = optional(bool)
    computer_name                   = optional(string)
    custom_data                     = optional(string)
    allow_extension_operations      = optional(bool)
    availability_set_id             = optional(string)
    admin_ssh_key = optional(list(object({
      username   = string
      public_key = string
    })))
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    license_type                                           = optional(string)
    capacity_reservation_group_id                          = optional(string)
    dedicated_host_id                                      = optional(string)
    dedicated_host_group_id                                = optional(string)
    encryption_at_host_enabled                             = optional(bool)
    eviction_policy                                        = optional(string)
    max_bid_price                                          = optional(number)
    patch_mode                                             = optional(string)
    patch_assessment_mode                                  = optional(string)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool)
    reboot_setting                                         = optional(string)
    priority                                               = optional(string)
    secure_boot_enabled                                    = optional(bool)
    vtpm_enabled                                           = optional(bool)
    user_data                                              = optional(string)
    zone                                                   = optional(string)
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool)
      hibernation_enabled = optional(bool)
    }))
    tags = optional(map(string))

    # Extra Optional Arguments from Docs
    disk_controller_type   = optional(string)
    edge_zone              = optional(string)
    extensions_time_budget = optional(string)
    gallery_application = optional(list(object({
      version_id                                  = string
      automatic_upgrade_enabled                   = optional(bool)
      configuration_blob_uri                      = optional(string)
      order                                       = optional(number)
      tag                                         = optional(string)
      treat_failure_as_deployment_failure_enabled = optional(bool)
    })))
    platform_fault_domain        = optional(number)
    provision_vm_agent           = optional(bool)
    proximity_placement_group_id = optional(string)
    secret = optional(list(object({
      key_vault_id = string
      certificate = list(object({
        url = string
      }))
    })))
    source_image_id = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    os_image_notification = optional(object({
      timeout = optional(string)
    }))
    os_managed_disk_id = optional(string)
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }))
    virtual_machine_scale_set_id = optional(string)
  }))
}

# VARIABLE FOR STORAGE ACCOUNTS

variable "storage_accounts" {
  description = "Azure Storage Accounts with every supported argument and child block."
  type = map(object({

    # ---------- REQUIRED ----------
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string

    # ---------- OPTIONAL ----------
    account_kind                      = optional(string, "StorageV2")
    provisioned_billing_model_version = optional(string)
    cross_tenant_replication_enabled  = optional(bool, false)
    access_tier                       = optional(string, "Hot")
    edge_zone                         = optional(string)
    https_traffic_only_enabled        = optional(bool, true)
    min_tls_version                   = optional(string, "TLS1_2")
    allow_nested_items_to_be_public   = optional(bool, true)
    shared_access_key_enabled         = optional(bool, true)
    public_network_access_enabled     = optional(bool, true)
    default_to_oauth_authentication   = optional(bool, false)
    is_hns_enabled                    = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    large_file_share_enabled          = optional(bool, false)
    local_user_enabled                = optional(bool, true)
    queue_encryption_key_type         = optional(string, "Service")
    table_encryption_key_type         = optional(string, "Service")
    infrastructure_encryption_enabled = optional(bool, false)
    allowed_copy_scope                = optional(string)
    sftp_enabled                      = optional(bool, false)
    dns_endpoint_type                 = optional(string, "Standard")
    tags                              = optional(map(string), {})

    # ---------- CHILD BLOCKS ----------
    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id          = optional(string)
      managed_hsm_key_id        = optional(string)
      user_assigned_identity_id = string
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    }))

    blob_properties = optional(object({
      versioning_enabled            = optional(bool)
      change_feed_enabled           = optional(bool)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool)

      delete_retention_policy = optional(object({
        days                     = optional(number)
        permanent_delete_enabled = optional(bool)
      }))

      restore_policy = optional(object({
        days = number
      }))

      container_delete_retention_policy = optional(object({
        days = optional(number)
      }))

      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))
    }))

    queue_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))

      logging = optional(object({
        delete                = bool
        read                  = bool
        write                 = bool
        version               = string
        retention_policy_days = optional(number)
      }))

      minute_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))

      hour_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
    }))

    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))

    share_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))

      retention_policy = optional(object({
        days = optional(number)
      }))

      smb = optional(object({
        versions                        = optional(list(string))
        authentication_types            = optional(list(string))
        kerberos_ticket_encryption_type = optional(list(string))
        channel_encryption_type         = optional(list(string))
        multichannel_enabled            = optional(bool)
      }))
    }))

    immutability_policy = optional(object({
      allow_protected_append_writes = bool
      state                         = string
      period_since_creation_in_days = number
    }))

    sas_policy = optional(object({
      expiration_period = string
      expiration_action = optional(string)
    }))

    azure_files_authentication = optional(object({
      directory_type                 = string
      default_share_level_permission = optional(string)
      active_directory = optional(object({
        domain_name         = string
        domain_guid         = string
        domain_sid          = optional(string)
        storage_sid         = optional(string)
        forest_name         = optional(string)
        netbios_domain_name = optional(string)
      }))
    }))

    routing = optional(object({
      publish_internet_endpoints  = optional(bool)
      publish_microsoft_endpoints = optional(bool)
      choice                      = optional(string)
    }))
  }))
}


# Variable for SQL Server

variable "sql_servers" {
  description = "Map of SQL Servers to create"
  type = map(object({
    # Required
    name                = string
    resource_group_name = string
    location            = string
    version             = string

    # Optional
    administrator_login                          = optional(string)
    administrator_login_password                 = optional(string)
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


variable "sql_databases" {
  description = "Map of SQL databases to create with all required and optional arguments"
  type = map(object({
    db_name                     = string
    sql_server_name             = optional(string)
    resource_group_name         = optional(string)
    auto_pause_delay_in_minutes = optional(number)
    create_mode                 = optional(string)
    import = optional(object({
      storage_uri                  = string
      storage_key                  = string
      storage_key_type             = string
      administrator_login          = string
      administrator_login_password = string
      authentication_type          = string
      storage_account_id           = optional(string)
    }))
    creation_source_database_id    = optional(string)
    collation                      = optional(string)
    elastic_pool_id                = optional(string)
    enclave_type                   = optional(string)
    geo_backup_enabled             = optional(bool)
    maintenance_configuration_name = optional(string)
    ledger_enabled                 = optional(bool)
    license_type                   = optional(string)
    long_term_retention_policy = optional(object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(number)
    }))
    max_size_gb                           = optional(number)
    min_capacity                          = optional(number)
    restore_point_in_time                 = optional(string)
    recover_database_id                   = optional(string)
    recovery_point_id                     = optional(string)
    restore_dropped_database_id           = optional(string)
    restore_long_term_retention_backup_id = optional(string)
    read_replica_count                    = optional(number)
    read_scale                            = optional(bool)
    sample_name                           = optional(string)
    short_term_retention_policy = optional(object({
      retention_days           = number
      backup_interval_in_hours = optional(number)
    }))
    sku_name             = optional(string)
    storage_account_type = optional(string)
    threat_detection_policy = optional(object({
      state                      = optional(string)
      disabled_alerts            = optional(list(string))
      email_account_admins       = optional(string)
      email_addresses            = optional(list(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))
    transparent_data_encryption_enabled                        = optional(bool)
    transparent_data_encryption_key_vault_key_id               = optional(string)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
    zone_redundant                                             = optional(bool)
    secondary_type                                             = optional(string)
    tags                                                       = optional(map(string))
  }))
  default = {}
}


























