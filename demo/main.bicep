param storagePrefix string
param location string = resourceGroup().location

module storage 'br/demoRegistry:storage:v1' = {
  name: 'storage-demo'
  params: {
    storagePrefix: storagePrefix
    location: location
  }
}

output storageEndpoint object = storage.outputs.storageEndpoint
