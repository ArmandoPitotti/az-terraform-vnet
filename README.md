# Overview

This Terraform project contains a template for setting up a Virtual Network together with a list of inner Subnets.

## Usage

This module provisions a Virtual Network.

```hcl-terraform
module "vnet" {
  source = "gitlabe2.ext.net.nokia.com/cs/common/iac/az-terraform-vnet?ref=<version>"
  resource_group_name       = var.resource_group_name
  resource_group_location   = var.resource_group_location
  vnet_name                 = "common"
  vnet_address_space        = ["172.20.0.0/16"]
  subnets                   = [{ name = "shared", address_range = "172.20.10.0/24", endpoints = ["Microsoft.ContainerRegistry", "Microsoft.Storage"] }]
}
```
where `<version>` must be changed with the tag version that you want to refer to.

## TODO
- [ ] do security compliance

## Variables

In `variables.tf` file, the following variables have been defined:

| Name                     | Required | Default                 | Description |
| ----                     | -------- | -------                 | ----------- |
| `resource_group_name`         | Yes | N/A                     | Name of the resource group the Virtual Network will be associated to |
| `resource_group_location`     | Yes | westeurope              | Location of the resource group the Virtual Network will be associated to |
| `vnet_name`                   | Yes | N/A                     | The name of the Virtual Network to provision |
| `vnet_address_space`          | Yes | ["172.20.0.0/16"]       | Address space in CIDR format of the Virtual Network to provision |
| `subnets`                     | Yes | shared and internal     | List of subnet configurations for the VNet  |
| `ddos_protection_enabled`     | Yes | false     | List of subnet configurations for the VNet  |


## Output

This module also defines some useful output variables (listed in `outputs.tf`) that can be highlighted to
the user when Terraform applies and they can be easily queried using the `output` command.

Here all the outputs:

| Name                         | Description |
| ----                         | ----------- |
| `vnet`                       | Provisioned Virtual Network object |
| `subnets`                    | List of provisioned subnets |
