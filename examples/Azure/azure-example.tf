terraform {
  required_providers {
    infoblox = {
        source  = "infobloxopen/infoblox"
    }
    azurerm = {
        source = "hashicorp/azurerm"
    }
  }
}

provider "infoblox" {
#For provider and authentication options for Infoblox, refer to: https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs
}

provider "azurerm" {
#For provider and authentication options for Azure, refer to: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs 
  features {}
}

# Call the infoblox_cloud_network module with required variables
module "infoblox_cloud_network" {
  source = "github.com/infobloxopen/terraform-infoblox-cloud-network"
  network_view = "Cloud"
  cloud = "Azure"
  region = "uswest"
  stage = "Prod"
  size = "large"
  application = "test-app"
}

# Create resource group in Azure
resource "azurerm_resource_group" "rg" {
  location = module.infoblox_cloud_network.cloud_region
  name = "autotest-rg"
}

# Use the Azure vnet module to create VNet and Subnets: https://registry.terraform.io/modules/Azure/vnet/azurerm/latest 
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name = "Auto-VNet"
  use_for_each = true
  vnet_location = module.infoblox_cloud_network.cloud_region
  address_space = [ module.infoblox_cloud_network.vpc_cidr ]
  subnet_prefixes = module.infoblox_cloud_network.subnet_cidrs
  subnet_names = [ "subnet1", "subnet2", "subnet3", "subnet4" ] # Enter names for each subnet - 2 for small, 4 for medium and large
}