param location string
param tags object

// TODO: Define the resources for AKS
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-01' = {
  name: 'aks-ai-multiagent-lab'
  location: location
  tags: tags
  properties: {
    dnsPrefix: 'ai-multiagent-lab'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    identity: {
      type: 'SystemAssigned'
    }
  }
}


