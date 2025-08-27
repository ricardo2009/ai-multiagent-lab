@description('Environment name')
param environment string = 'dev'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Components to deploy')
@allowed(['all', 'ai-foundry', 'cosmos-db', 'functions', 'aks', 'networking'])
param deployComponents string = 'all'

@description('Force recreate resources')
param forceRecreate bool = false

@description('Unique suffix for resource names')
param uniqueSuffix string = uniqueString(resourceGroup().id)

@description('Common tags for all resources')
var commonTags = {
  Environment: environment
  Project: 'AI-Multiagent-Lab'
  CreatedBy: 'Bicep'
  DeployComponents: deployComponents
}

// Networking Module
module networking 'modules/networking.bicep' = if (deployComponents == 'all' || deployComponents == 'networking') {
  name: 'networking-deployment-${uniqueSuffix}'
  params: {
    location: location
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: commonTags
  }
}

// Azure AI Foundry Module
module aiFoundry 'modules/ai-foundry.bicep' = if (deployComponents == 'all' || deployComponents == 'ai-foundry') {
  name: 'ai-foundry-deployment-${uniqueSuffix}'
  params: {
    location: location
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: commonTags
  }
  dependsOn: [
    networking
  ]
}

// Cosmos DB Module
module cosmosDb 'modules/cosmos-db.bicep' = if (deployComponents == 'all' || deployComponents == 'cosmos-db') {
  name: 'cosmos-db-deployment-${uniqueSuffix}'
  params: {
    location: location
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: commonTags
  }
  dependsOn: [
    networking
  ]
}

// Azure Functions Module
module functions 'modules/functions.bicep' = if (deployComponents == 'all' || deployComponents == 'functions') {
  name: 'functions-deployment-${uniqueSuffix}'
  params: {
    location: location
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: commonTags
  }
  dependsOn: [
    networking
    cosmosDb
  ]
}

// AKS Module
module aks 'modules/aks.bicep' = if (deployComponents == 'all' || deployComponents == 'aks') {
  name: 'aks-deployment-${uniqueSuffix}'
  params: {
    location: location
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: commonTags
    subnetId: deployComponents == 'all' || deployComponents == 'networking' ? networking.outputs.aksSubnetId : ''
  }
  dependsOn: [
    networking
  ]
}

// Outputs
output resourceGroupName string = resourceGroup().name
output location string = location
output environment string = environment
output deployComponents string = deployComponents

output aiFoundryWorkspaceName string = (deployComponents == 'all' || deployComponents == 'ai-foundry') ? aiFoundry.outputs.workspaceName : ''
output cosmosDbAccountName string = (deployComponents == 'all' || deployComponents == 'cosmos-db') ? cosmosDb.outputs.accountName : ''
output functionsAppName string = (deployComponents == 'all' || deployComponents == 'functions') ? functions.outputs.functionAppName : ''
output aksClusterName string = (deployComponents == 'all' || deployComponents == 'aks') ? aks.outputs.clusterName : ''
output vnetName string = (deployComponents == 'all' || deployComponents == 'networking') ? networking.outputs.vnetName : ''

