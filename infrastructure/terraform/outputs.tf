# Simplified Outputs for AI Multiagent Lab Infrastructure

# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = var.location
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

# Networking Outputs
output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

# Cosmos DB Outputs
output "cosmos_db_account_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.name
}

output "cosmos_db_account_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.id
}

output "cosmos_db_endpoint" {
  description = "Endpoint URL of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.endpoint
  sensitive   = true
}

output "cosmos_db_primary_key" {
  description = "Primary key for Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.primary_key
  sensitive   = true
}

# Azure Functions Outputs
output "function_app_name" {
  description = "Name of the Azure Function App"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_id" {
  description = "ID of the Azure Function App"
  value       = azurerm_linux_function_app.main.id
}

output "function_app_default_hostname" {
  description = "Default hostname of the Azure Function App"
  value       = azurerm_linux_function_app.main.default_hostname
}

# Storage Account Outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.functions.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.functions.id
}

# Summary Output for Easy Reference
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    resource_group = azurerm_resource_group.main.name
    location       = var.location
    environment    = var.environment
    
    networking = {
      vnet_name = azurerm_virtual_network.main.name
      vnet_id   = azurerm_virtual_network.main.id
    }
    
    cosmos_db = {
      account_name = azurerm_cosmosdb_account.main.name
      account_id   = azurerm_cosmosdb_account.main.id
    }
    
    functions = {
      app_name = azurerm_linux_function_app.main.name
      app_id   = azurerm_linux_function_app.main.id
    }
    
    storage = {
      account_name = azurerm_storage_account.functions.name
      account_id   = azurerm_storage_account.functions.id
    }
  }
}

