resource "azurerm_bastion_host" "bastion_host" {
  for_each = var.bastion_hosts

  name                = each.value.bastion_host_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku

  copy_paste_enabled        = each.value.copy_paste_enabled
  file_copy_enabled         = each.value.file_copy_enabled
  ip_connect_enabled        = each.value.ip_connect_enabled
  kerberos_enabled          = each.value.kerberos_enabled
  scale_units               = each.value.scale_units
  shareable_link_enabled    = each.value.shareable_link_enabled
  tunneling_enabled         = each.value.tunneling_enabled
  session_recording_enabled = each.value.session_recording_enabled
  # virtual_network_id        = data.azurerm_virtual_network.vnet[each.key].id   # `virtual_network_id` is only supported when `sku` is `Developer`(no public IP)
  tags  = each.value.tags
  zones = each.value.zones

  ip_configuration {                                          # Normal production deployment(SKU is Basic / Standard / Premium)
    name                 = each.value.ip_configuration.name
    subnet_id            = data.azurerm_subnet.subnet[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}



