data "azurerm_virtual_network" "vnet" {
  for_each            = var.bastion_hosts
  name                = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "subnet" {
  for_each             = var.bastion_hosts
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pip" {
  for_each            = var.bastion_hosts
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}

