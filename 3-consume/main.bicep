param environmentName string = 'demo-aca'
param location string = resourceGroup().location

param dateNow string = utcNow()
module containerapp 'br/demoRegistry:containerapp:1.1.0' = {
  name: 'containerapp-${dateNow}'
  params: {
    environmentName: environmentName
    location: location
  }
}

output url string = containerapp.outputs.url
