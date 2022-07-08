param name string = 'demo-vnet'

param addressPrefixes array = [ '10.0.0.0/16' ]

param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '10.0.2.0/24'
  }
]

param location string = resourceGroup().location

module vnet 'br/public:network/virtual-network:1.0.1' = {
  name: '${uniqueString(deployment().name, 'westeurope')}-minvnet'
  params: {
    name: name
    addressPrefixes: addressPrefixes
    location: location
    subnets: subnets
  }
}

output id string = vnet.outputs.resourceId
