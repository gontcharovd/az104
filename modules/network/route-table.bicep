param parRouteTableName string
param parLocation string
param parRoute object

resource resRouteTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: parRouteTableName
  location: parLocation
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: parRoute.name
        properties: {
          addressPrefix: parRoute.addressPrefix
          hasBgpOverride: false
          nextHopIpAddress: parRoute.nextHopIpAddress
          nextHopType: parRoute.nextHopType
        }
      }
    ]
  }
}

output outRouteTableId string = resRouteTable.id
