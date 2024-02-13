variable "network_view" {
  description = "Network view in NIOS to search for and create resources"
  type = string
  default = "default"
}

variable "cloud" {
  description = "Cloud provider for this VPC."
  type = string
  validation {
    condition = contains(["Azure", "AWS", "GCP"], var.cloud)
    error_message = "The value of cloud must be one of the following: Azure, AWS, or GCP"
  }
}

variable "region" {
  description = "Region where VPC will be created: uswest, useast, euwest"
  type = string
  validation {
    condition = contains(["uswest", "useast", "euwest"], var.region)
    error_message = "The value of region must be one of the following: uswest, useast, or euwest"
  }
}

variable "stage" {
  description = "Workload stage for this VPC: Prod, Staging, QA, Dev"
  type = string
  validation {
    condition = contains(["Prod", "Staging", "QA", "Dev"], var.stage)
    error_message = "The value of stage must be one of the following: Prod, Staging, QA, or Dev"
  }
}

variable "size" {
  description = "T-shirt size of VPC: small, medium, large"
  type = string
  validation {
    condition = contains(["small", "medium", "large"], var.size)
    error_message = "The value of size must be one of the following: small, medium, or large"
  }
}

variable "application" {
  description = "Name of the application using this VPC"
  type = string
    validation {
    condition = length(var.application) >= 4
    error_message = "You must enter a name for the application, 4 or more characters"
  }
}

variable "cloud_region" {
# Maps the input variable region to a specific region in each cloud.
  description = "Maps requested region to unique cloud regions"
  type = map(object({
    Azure = string
    AWS = string
    GCP = string
  }))
  default = {
    uswest = {
      Azure = "westus"
      AWS = "us-west-1"
      GCP = "us-west1"
    }
    useast = {
      Azure = "eastus"
      AWS = "us-east-1"
      GCP = "us-east1"
    }
    euwest = {
      Azure = "westeurope"
      AWS = "eu-west-3"
      GCP = "europe-west2-a"
    }
  }
}

variable "vpc_size" {
  description = "Maps t-shirt size to prefix length for VPC"
  type = map(number)
  default = {
    small = 27
    medium = 26
    large = 24
  }
}

variable "subnet_size" {
  description = "Maps t-shirt size to prefix length for subnets"
  type = map(number)
  default = {
    small = 28
    medium = 28
    large = 26
  }
}