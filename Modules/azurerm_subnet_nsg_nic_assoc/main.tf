resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  for_each                  = var.subnet_nsg_assoc
  subnet_id                 = data.azurerm_subnet.subnet[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
}

# resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
#   network_interface_id      = data.azurerm_network_interface.nic[each.key].id
#   network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
# }


