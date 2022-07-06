@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string = 'br${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param location string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

resource bicepRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    adminUserEnabled: false
  }
}

@description('Output the login server property for later use')
output loginServer string = bicepRegistry.properties.loginServer
