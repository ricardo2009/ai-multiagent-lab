variable "location" {}
variable "resource_group_name" {}
variable "tags" {}

// TODO: Define the resources for Azure Functions

resource "azurerm_storage_account" "storage" {
  name                     = "funcstgaiagentlabtf"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "func-plan-ai-multiagent-lab-tf"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "function_app" {
  name                = "func-ai-multiagent-lab-tf"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_name = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  tags = var.tags
}


