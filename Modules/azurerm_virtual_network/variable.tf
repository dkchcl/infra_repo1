# Variable for virtual networks using a map
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
    tags                           = optional(map(string))
    # Optional IP address pool (alternative to address_space)
    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))

    ddos_protection_plan = optional(object({
      id     = string
      enable = string
    }))

    encryption = optional(object({
      enforcement = string
    }))

  }))
}



