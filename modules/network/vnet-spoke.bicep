param vnetName string 
param addressPrefix string 
param location string
param subnetName string
param subnetPrefix string
param routeTableId string

resource vnetSpoke 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          routeTable: {
            id: routeTableId
          }
        }
      }
    ]
  }
}

output vnetId string = vnetSpoke.id
output vnetName string = vnetSpoke.name
