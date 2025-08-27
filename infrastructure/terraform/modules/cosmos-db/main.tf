variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

// TODO: Define the resources for Cosmos DB

resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-ai-multiagent-lab-tf"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}


