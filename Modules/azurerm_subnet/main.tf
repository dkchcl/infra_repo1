resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                                          = each.value.subnet_name
  resource_group_name                           = each.value.resource_group_name
  virtual_network_name                          = each.value.virtual_network_name
  address_prefixes                              = try(each.value.address_prefixes, null)
  default_outbound_access_enabled               = try(each.value.default_outbound_access_enabled, true)
  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, "Disabled")
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, true)
  sharing_scope                                 = try(each.value.sharing_scope, null)
  service_endpoints                             = try(each.value.service_endpoints, null)
  service_endpoint_policy_ids                   = try(each.value.service_endpoint_policy_ids, null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name

      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = service_delegation.value.name
          actions = lookup(service_delegation.value, "actions", [])
        }
      }
    }
  }

  dynamic "ip_address_pool" {
    for_each = try(each.value.ip_address_pool != null ? [each.value.ip_address_pool] : [], [])
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }
}
