###################################
# Load Balancer
###################################
resource "azurerm_lb" "lb" {
  for_each = var.load_balancers

  name                = each.value.lb_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = try(each.value.sku, "Standard")
  sku_tier            = try(each.value.sku_tier, "Regional")
  edge_zone           = try(each.value.edge_zone, null)
  tags                = try(each.value.tags, {})

  dynamic "frontend_ip_configuration" {
    for_each = try(each.value.frontend_ip_configuration, {})
    content {
      name                                               = frontend_ip_configuration.value.name
      zones                                              = try(frontend_ip_configuration.value.zones, null)
      subnet_id                                          = try(frontend_ip_configuration.value.subnet_id, null) #data.azurerm_subnet.subnet[each.key].id
      gateway_load_balancer_frontend_ip_configuration_id = try(frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
      private_ip_address                                 = try(frontend_ip_configuration.value.private_ip_address, null)
      private_ip_address_allocation                      = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
      private_ip_address_version                         = try(frontend_ip_configuration.value.private_ip_address_version, null)
      public_ip_address_id                               = data.azurerm_public_ip.pip[each.key].id
      public_ip_prefix_id                                = try(frontend_ip_configuration.value.public_ip_prefix_id, null)
    }
  }
}

###################################
# Backend Address Pools
###################################

resource "azurerm_lb_backend_address_pool" "lb_ba_pool" {
  for_each = var.load_balancers

  name               = each.value.ba_pool_name
  loadbalancer_id    = azurerm_lb.lb[each.key].id
  synchronous_mode   = try(each.value.synchronous_mode, null)
  virtual_network_id = data.azurerm_virtual_network.vnet[each.key].id

  dynamic "tunnel_interface" { # this block will only use with sku = Gateway
    for_each = each.value.tunnel_interface != null ? each.value.tunnel_interface : {}
    content {
      identifier = tunnel_interface.value.identifier
      type       = tunnel_interface.value.type
      protocol   = tunnel_interface.value.protocol
      port       = tunnel_interface.value.port
    }
  }
}

###################################
# Probe
###################################
resource "azurerm_lb_probe" "lb_probe" {
  for_each        = var.load_balancers
  name            = each.value.lb_probes_name
  loadbalancer_id = azurerm_lb.lb[each.key].id
  port            = each.value.port

  protocol            = try(each.value.probe_protocol, "Tcp")
  probe_threshold     = try(each.value.probe_threshold, 1)
  request_path        = try(each.value.request_path, null)
  interval_in_seconds = try(each.value.interval_in_seconds, 15)
  number_of_probes    = try(each.value.number_of_probes, 2)
}

###################################
# Rule
###################################
resource "azurerm_lb_rule" "lb_rules" {
  for_each = var.load_balancers

  name                           = each.value.lb_rules_name
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.lbrule_protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port

  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_ba_pool[each.key].id]
  probe_id                 = azurerm_lb_probe.lb_probe[each.key].id
  floating_ip_enabled      = try(each.value.floating_ip_enabled, false)
  idle_timeout_in_minutes  = try(each.value.idle_timeout_in_minutes, 4)
  load_distribution        = try(each.value.load_distribution, "Default")
  disable_outbound_snat    = try(each.value.disable_outbound_snat, false)
  tcp_reset_enabled        = try(each.value.tcp_reset_enabled, false)
}
