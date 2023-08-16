output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_default_id" {
  value = azurerm_subnet.default.id
}

output "subnet_private_endpoint_id" {
  value = azurerm_subnet.private.id
}