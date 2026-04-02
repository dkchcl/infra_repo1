variable "load_balancers" {
  description = "Map of Load Balancers"
  type = map(object({
    lb_name             = string
    resource_group_name = string
    location            = string
    edge_zone           = optional(string)
    sku                 = optional(string, "Standard")
    sku_tier            = optional(string, "Regional")
    tags                = optional(map(string))
    # subnet_name         = optional(string)
    pip_name            = optional(string)
    frontend_ip_configuration = optional(map(object({
      name                                               = string
      zones                                              = optional(list(string))
      subnet_id                                          = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      private_ip_address                                 = optional(string)
      private_ip_address_allocation                      = optional(string)
      private_ip_address_version                         = optional(string)
      public_ip_address_id                               = optional(string)
      public_ip_prefix_id                                = optional(string)
    })))

    # Variable for Backend Address Pools
    ba_pool_name     = string
    synchronous_mode = optional(string)
    # virtual_network_id = optional(string)
    virtual_network_name = optional(string)
    tunnel_interface = optional(map(object({
      identifier = string
      type       = string
      protocol   = string
      port       = number
    })))

    # Variable for lb_probes
    lb_probes_name      = string
    port                = number
    probe_protocol      = optional(string, "Tcp")
    probe_threshold     = optional(number, 1)
    request_path        = optional(string)
    interval_in_seconds = optional(number, 15)
    number_of_probes    = optional(number, 2)

    # Variable for lb_rules
    lb_rules_name                  = string
    frontend_ip_configuration_name = string
    lbrule_protocol                = string
    frontend_port                  = number
    backend_port                   = number
    floating_ip_enabled            = optional(bool, false)
    idle_timeout_in_minutes        = optional(number, 4)
    load_distribution              = optional(string, "Default")
    disable_outbound_snat          = optional(bool, false)
    tcp_reset_enabled              = optional(bool, false)
  }))
}




















