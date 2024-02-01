param vnetName string 
param addressPrefixes string 
param location string
param subnetNames array
param subnetPrefixes array
param routeTableId string

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
        }
      }
    ]
  }
}


resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = if (routeTableName) {
  name: routeTableName
  parent: vnet
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: route.name
        properties: {
          addressPrefix: route.addressPrefix
          hasBgpOverride: false
          nextHopIpAddress: route.nextHopIpAddress
          nextHopType: route.nextHopType
        }
      }
    ]
  }
}

output vnetId string = vnet.id
