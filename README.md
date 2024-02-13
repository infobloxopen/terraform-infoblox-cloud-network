# terraform-infoblox-cloud-network

This Terraform module creates a network container and multiple networks in Infoblox NIOS. It is intended only as an example of how to create a module for Infoblox to use with multi-cloud network automation and will likely need to be customized to work in your environment.

### Terraform and terraform-provider-infoblox Versions
This module was developed and tested with Terraform version 1.4.6 and terraform-provider-infoblox version 2.5.0.

## Example Usage
This module should be used with VPC/VNet modules published by major cloud providers to allocate and provision VPCs/VNets in the cloud. See the subfolders under the examples folder for examples of use with some cloud providers.

```hcl
module "infoblox_cloud_network" {
  source = "github.com/infobloxopen/terraform-infoblox-cloud-network"
  network_view = "Cloud"
  cloud = "Azure"
  region = "uswest"
  stage = "Prod"
  size = "large"
  application = "test-app"
}
```

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :--------: |
| network_view | Network view to search and create resources in. | `string` | `"default"` | No |
| cloud | Value to filter on for Cloud extensible attribute. | `string` | N/A | Yes |
| region | Value to filter on for Region extensible attribute. | `string` | N/A | Yes |
| stage | Value to filter on for Stage extensible attribute. | `string` | N/A | Yes |
| size | Size of container to create: small, medium, large. | `string` | N/A | Yes |
| application | Value to set for Application extensible attribute. | `string` | N/A | Yes |

## Outputs
| Name | Description | Type |
| ---- | ----------- | ---- |
| vpc_cidr | CIDR of new network container, used for VPC CIDR. | `string` |
| subnet_cidrs | CIDRs of new networks, used for subnet CIDRs. | `list(string)` |
| cloud_region | Cloud region to deploy resources, based on mapping from combination of cloud and region inputs. | `string` |
