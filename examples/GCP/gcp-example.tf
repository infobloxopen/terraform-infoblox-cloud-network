terraform {
  required_providers {
    infoblox = {
        source  = "infobloxopen/infoblox"
    }
    google = {
        source = "hashicorp/google"
    }
  }
}

provider "infoblox" {
#For provider and authentication options for Infoblox, refer to: https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs
}

provider "google" {
#For provider and authentication options for GCP, refer to: https://registry.terraform.io/providers/hashicorp/google/latest/docs
}

# Call the infoblox_cloud_network module with required variables
module "infoblox_cloud_network" {
  source = "git::https://github.com/infobloxopen/terraform-infoblox-cloud-network.git"
  network_view = "Cloud"
  cloud = "GCP"
  region = "uswest"
  stage = "Prod"
  size = "large"
  application = "test-app"
}

# Use the GCP network module to create VPC and Subnets: https://registry.terraform.io/modules/terraform-google-modules/network/google/latest
module "network" {
  source  = "terraform-google-modules/network/google"
  version = "9.0.0"
  network_name = "auto-vpc"
  project_id = "project_id"
  subnets = [ # The GCP module requires a block for each subnet you will create. Adjust based on how many subnets are created: 2 for small, 4 for large and medium
    {
      subnet_name = "subnet-01"
      subnet_ip = module.infoblox_cloud_network.subnet_cidrs[0]
      subnet_region = module.infoblox_cloud_network.cloud_region
    },
    {
      subnet_name = "subnet-02"
      subnet_ip = module.infoblox_cloud_network.subnet_cidrs[1]
      subnet_region = module.infoblox_cloud_network.cloud_region
    },
    {
      subnet_name = "subnet-03"
      subnet_ip = module.infoblox_cloud_network.subnet_cidrs[2]
      subnet_region = module.infoblox_cloud_network.cloud_region
    },
    {
      subnet_name = "subnet-04"
      subnet_ip = module.infoblox_cloud_network.subnet_cidrs[3]
      subnet_region = module.infoblox_cloud_network.cloud_region
    }
  ]
}