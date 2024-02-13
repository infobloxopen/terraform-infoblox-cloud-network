output "vpc_cidr" {
    value = infoblox_ipv4_network_container.vpc_containter.cidr
    description = "CIDR of new network container, used for VPC CIDR"
}

output "subnet_cidrs" {
    value = infoblox_ipv4_network.subnets.*.cidr
    description = "CIDRs of new networks, used for subnet CIDRs"
}

output "cloud_region" {
    value = local.cloud_region
    description = "Cloud region to deploy resources"
}