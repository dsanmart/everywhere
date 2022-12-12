param appServiceAppName string = 'dsanmart-assignment-app-bicep'

param appServicePlanName string = 'dsanmart-assignment-ASP-bicep'

param storageAccountName string = 'jseijasstorage'
@allowed([
  'nonprod'
  'prod'
])

param environmentType string = 'nonprod'
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'app.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
