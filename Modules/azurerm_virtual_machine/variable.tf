variable "vms" {
  description = "Configuration for Azure Linux Virtual Machines"
  type = map(object({
    # NIC
    nic_name             = optional(string)
    subnet_name          = optional(string)
    virtual_network_name = optional(string)
    pip_name             = optional(string)
    ip_configuration = optional(object({
      ip_config_name                = optional(string)
      private_ip_address_allocation = optional(string)
      subnet_id                     = optional(string)
      public_ip_address_id          = optional(string)
    }))


    #VM
    vm_name             = string
    location            = string
    resource_group_name = string
    # network_interface_ids = list(string)
    size            = string
    key_vault_name  = optional(string)
    secret_name     = optional(string)
    secret_password = optional(string)
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
