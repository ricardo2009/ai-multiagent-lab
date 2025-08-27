variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

// TODO: Define the resources for Networking

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-ai-multiagent-lab-tf"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}


