param location string
param tags object

// TODO: Define the resources for Azure Functions
resource functionAppPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'func-plan-ai-multiagent-lab'
  location: location
  tags: tags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'func-ai-multiagent-lab'
  location: location
  tags: tags
  kind: 'functionapp'
  properties: {
    serverFarmId: functionAppPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: '' // TODO: Add storage account connection string
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
      ]
    }
  }
}


