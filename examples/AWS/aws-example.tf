terraform {
  required_providers {
    infoblox = {
        source  = "infobloxopen/infoblox"
    }
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "infoblox" {
#For provider and authentication options for Infoblox, refer to: https://registry.terraform.io/providers/infobloxopen/infoblox/latest/docs
}

provider "aws" {
#For provider and authentication options for AWS, refer to: https://registry.terraform.io/providers/hashicorp/aws/latest/docs 
  region  = "us-west-1" # Include AWS region for deployment
}

# Call the infoblox_cloud_network module with required variables
module "infoblox_cloud_network" {
  source = "github.com/infobloxopen/terraform-infoblox-cloud-network"
  network_view = "Cloud"
  cloud = "AWS"
  region = "uswest"
  stage = "Dev"
  size = "small"
  application = "test-app"
}

# Use the AWS vpc module to create VPC and Subnets: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest  
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"
  name = "auto-vpc"
  cidr = module.infoblox_cloud_network.vpc_cidr
  azs = ["us-west-1b", "us-west-1c"]
  public_subnets = module.infoblox_cloud_network.subnet_cidrs
}