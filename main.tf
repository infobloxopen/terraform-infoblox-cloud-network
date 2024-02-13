terraform {
  required_providers {
    infoblox = {
      source  = "infobloxopen/infoblox"
      version = "2.5.0"
    }
  }
}

#For provider and authentication options for Infoblox, refer to: https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs

locals {
# Lookups cloud specific region in a map.
  cloud_region = lookup(var.cloud_region[var.region],var.cloud)

# Determines number of subnets based on t-shirt size.
  subnet_count = var.size == "small" ? 2 : 4

#Azure and AWS reserve the first 2 addresses after the default gateway for their use, GCP does not.
  reserved_ip_count = var.cloud == "GCP" ? 0 : 2 
}

data "infoblox_ipv4_network_container" "cloud_container" {
  filters = {
    network_view = var.network_view
    "*Cloud" = var.cloud
    "*Region" = local.cloud_region
    "*Stage" = var.stage
  }
}

resource "infoblox_ipv4_network_container" "vpc_containter" {
  parent_cidr = data.infoblox_ipv4_network_container.cloud_container.results.*.cidr[0]
  allocate_prefix_len = var.vpc_size[var.size]
  network_view = var.network_view
  ext_attrs = jsonencode({
    "Application" = var.application
  })
}

resource "infoblox_ipv4_network" "subnets" {
  count = local.subnet_count
  parent_cidr = infoblox_ipv4_network_container.vpc_containter.cidr
  allocate_prefix_len = var.subnet_size[var.size]
  network_view = var.network_view
  reserve_ip = local.reserved_ip_count
}