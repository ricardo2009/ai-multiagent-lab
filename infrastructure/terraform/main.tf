terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  description = "The Azure location where all resources should be created."
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  default     = "ai-multiagent-lab-rg-tf"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    environment = "development"
    project     = "ai-multiagent-lab-tf"
  }
}

module "resource_group" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "ai_foundry" {
  source              = "./modules/ai-foundry"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "cosmos_db" {
  source              = "./modules/cosmos-db"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "aks" {
  source              = "./modules/aks"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "functions" {
  source              = "./modules/functions"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "networking" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}


