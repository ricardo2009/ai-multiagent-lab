variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

// TODO: Define the resources for AKS

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-ai-multiagent-lab-tf"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "ai-multiagent-lab-tf"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}


