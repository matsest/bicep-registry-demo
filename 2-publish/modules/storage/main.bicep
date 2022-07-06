@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location

@metadata({
  schema: [
    'string'
  ]
})
param ipRules array = []

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

var ipRulesVar = [for ipRule in ipRules: {
  action: 'Allow'
  value: ipRule
}]

resource stg 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: ipRulesVar
    }
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints
