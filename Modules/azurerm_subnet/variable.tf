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






