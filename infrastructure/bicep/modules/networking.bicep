param location string
param tags object

// TODO: Define the resources for Networking
resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-ai-multiagent-lab'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}


