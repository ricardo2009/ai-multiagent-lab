targetScope = 'subscription'

param location string = 'eastus'
param resourceGroupName string = 'ai-multiagent-lab-rg'
param tags object = {
  environment: 'development'
  project: 'ai-multiagent-lab'
}

// Create Resource Group
module rg 'modules/resource-group.bicep' = {
  name: 'resource-group-deployment'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// Provision Azure AI Foundry
module aiFoundry 'modules/ai-foundry.bicep' = {
  name: 'ai-foundry-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
  }
  dependsOn: [rg]
}

// Provision Cosmos DB
module cosmosDb 'modules/cosmos-db.bicep' = {
  name: 'cosmos-db-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
  }
  dependsOn: [rg]
}

// Provision AKS
module aks 'modules/aks.bicep' = {
  name: 'aks-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
  }
  dependsOn: [rg]
}

// Provision Azure Functions
module functions 'modules/functions.bicep' = {
  name: 'functions-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
  }
  dependsOn: [rg]
}

// Configure Networking
module networking 'modules/networking.bicep' = {
  name: 'networking-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
  }
  dependsOn: [rg]
}


