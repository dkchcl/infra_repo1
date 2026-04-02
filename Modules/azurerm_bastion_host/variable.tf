variable "bastion_hosts" {
  description = "Map of Bastion Hosts to create"
  type = map(object({
    bastion_host_name         = string
    resource_group_name       = string
    location                  = string
    virtual_network_name      = optional(string)
    subnet_name               = optional(string)
    pip_name                  = optional(string)
    copy_paste_enabled        = optional(bool, true)
    file_copy_enabled         = optional(bool, false)     # Optional (Only for Standard/Premium)
    sku                       = optional(string, "Basic") # Optional (Developer, Basic, Standard, Premium)
    ip_connect_enabled        = optional(bool, false)     # Optional (Only for Standard/Premium)
    kerberos_enabled          = optional(bool, false)     # Optional (Only for Standard/Premium)
    scale_units               = optional(number, 2)       # Optional (Only for Standard/Premium)
    shareable_link_enabled    = optional(bool, false)     # Optional (Only for Standard/Premium)
    tunneling_enabled         = optional(bool, false)     # Optional (Only for Standard/Premium)
    session_recording_enabled = optional(bool, false)     # Optional (Only for Premium)
    tags                      = optional(map(string), {})
    zones                     = optional(list(string), null)
    ip_configuration = object({
      name = string
    })
  }))
}
