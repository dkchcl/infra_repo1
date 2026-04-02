# Virtual Network 
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet_name
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

  # Optional configurations with 'lookup()' to avoid errors if values are missing
  bgp_community                  = lookup(each.value, "bgp_community", null)
  dns_servers                    = lookup(each.value, "dns_servers", null)
  edge_zone                      = lookup(each.value, "edge_zone", null)
  flow_timeout_in_minutes        = lookup(each.value, "flow_timeout_in_minutes", null)
  private_endpoint_vnet_policies = lookup(each.value, "private_endpoint_vnet_policies", null)
  tags                           = lookup(each.value, "tags", {})

  # Optional ip_address_pool block (mutually exclusive with address_space)
  dynamic "ip_address_pool" {
    for_each = lookup(each.value, "ip_address_pool", null) != null ? [each.value.ip_address_pool] : []
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "ddos_protection_plan", null) != null ? [each.value.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = lookup(each.value, "encryption", null) != null ? [each.value.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }
}





