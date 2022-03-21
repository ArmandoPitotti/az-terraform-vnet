resource "azurerm_network_ddos_protection_plan" "ddos" {
  count               = var.ddos_protection_enabled ? 1 : 0
  name                = "${replace(lower(var.resource_group_name), "_", "-")}-ddos-protection"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_network_security_group" "group" {
  count               = var.network_security_group == false ? 0 : length(var.subnets)
  name                = "${replace(lower(var.resource_group_name), "_", "-")}-nsg-${var.subnets[count.index].name}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  security_rule {
    name                       = "DenyNetworkOutBound"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.external_network_range
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${replace(lower(var.resource_group_name), "_", "-")}-vnet-${var.vnet_name}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.vnet_address_space

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_enabled ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.ddos.0.id
      enable = var.ddos_protection_enabled
    }
  }
}

resource "azurerm_subnet" "subnet" {
  count = length(var.subnets)

  name                      = "${replace(lower(var.resource_group_name), "_", "-")}-subnet-${var.subnets[count.index].name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefix            = var.subnets[count.index].address_range
  service_endpoints         = var.subnets[count.index].endpoints  
}

resource "azurerm_subnet_network_security_group_association" "association" {
  count = var.network_security_group == false ? 0 : length(var.subnets)

  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.group[count.index].id
}
