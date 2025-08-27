# Development Environment Configuration

environment = "dev"
location    = "East US"

# Networking
vnet_address_space = ["10.0.0.0/16"]

# AKS Configuration
aks_node_count   = 1
aks_node_vm_size = "Standard_B2s"

# Cosmos DB Configuration
cosmos_db_consistency_level = "Session"

# Functions Configuration
functions_plan_sku = "Y1"

# AI Foundry Configuration
ai_foundry_sku = "Basic"

# Monitoring
enable_monitoring        = true
enable_private_endpoints = false  # Disabled for dev to reduce costs
log_retention_days      = 30

# Tags
tags = {
  Owner       = "AI-Multiagent-Lab"
  CostCenter  = "Engineering"
  Environment = "dev"
  Project     = "AI-Multiagent-Lab"
  Purpose     = "Development and Testing"
}

