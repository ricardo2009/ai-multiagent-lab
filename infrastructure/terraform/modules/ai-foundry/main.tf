variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

// Placeholder for Azure AI Foundry Terraform module
// TODO: Define the resources for Azure AI Foundry

resource "azurerm_machine_learning_workspace" "ai_foundry_hub" {
  name                = "ai-foundry-hub-tf"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_insights_id = ""
  key_vault_id = ""
  storage_account_id = ""
  sku_name = "Basic"
  tags = var.tags
}


