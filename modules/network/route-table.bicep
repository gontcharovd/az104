param routeTableName string
param location string
param route object

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: routeTableName
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
