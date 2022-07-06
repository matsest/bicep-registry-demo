param storagePrefix string = 'demostg'
param location string = 'westeurope'

module storage 'br/demoRegistry:storage:v1.1.0' = {
  name: 'storage-demo'
  params: {
    storagePrefix: storagePrefix
    location: location
  }
}

output storageEndpoint object = storage.outputs.storageEndpoint
