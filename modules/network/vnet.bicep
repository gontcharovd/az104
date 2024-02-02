param vnetName string 
param addressPrefixes string 
param location string
param subnetNames array
param subnetPrefixes array
param routeTableId string = ''

resource vnet 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
    subnets: [
      for (subnetName, index) in subnetNames: {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefixes[index]
          routeTable: {
            id: ((routeTableId != '') ? routeTableId : null)
          }
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
