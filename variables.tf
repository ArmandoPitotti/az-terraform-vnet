#
## Variables Configuration
#
#

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which to provision the Virtual Network"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group in which to provision the Virtual Network"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network to provision"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space in CIDR format of the Virtual Network to provision"
  default     = ["172.20.0.0/16"]
}

# address ranges must be compatible with vnet_address_space
variable "subnets" {
  type = list(object({
    name          = string
    address_range = string
    endpoints     = list(string)
  }))
  description = "List of subnet configurations for the VNet"
  default     = []
}

variable "ddos_protection_enabled" {
  type        = bool
  description = "Enable vnet ddos protection: may incur in undesired additional costs"
  default     = false
}

variable "external_network_range" {} // module.external.vnet.address_space.0

variable "network_security_group"{
  type = bool
  description = "subnets have NSG"
  default = false
}