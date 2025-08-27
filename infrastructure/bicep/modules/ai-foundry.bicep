// Placeholder for Azure AI Foundry Bicep module
// TODO: Define the resources for Azure AI Foundry
param location string
param tags object

// Example: AI Hub resource
resource aiHub 'Microsoft.MachineLearningServices/workspaces@2023-04-01' = {
  name: 'ai-foundry-hub'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    description: 'Azure AI Foundry Hub'
    friendlyName: 'ai-foundry-hub'
  }
}


