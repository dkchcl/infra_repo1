# output "public_ip_address" {
#   value    = azurerm_public_ip.pip[each.key].ip_address
# }

output "public_ip_addresses" {
  description = "All public IPs created"
  value = {
    for k, v in azurerm_public_ip.pip : k => v.ip_address
  }
}
