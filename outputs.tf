output "vnet" {
  value       = azurerm_virtual_network.vnet
  description = "Provisioned Virtual Network object"
}

output "subnets" {
  value       = azurerm_subnet.subnet[*]
  description = "List of provisioned subnets"
}
