param storagePrefix string = 'demostg'
param location string = 'westeurope'

module storage 'br/demoRegistry:storage:latest' = {
  name: 'storage-demo'
  params: {
    storagePrefix: storagePrefix
    location: location
  }
}

output storageEndpoint object = storage.outputs.storageEndpoint
