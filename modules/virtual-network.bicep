param parAddressPrefix string 
param parLocation string
// Default to empty, indicating no route table
param parRouteTableId string = ''
param parSubnetNames array
param parSubnetPrefixes array
param parVnetName string 

resource resVnetHub 'microsoft.network/virtualnetworks@2023-04-01' = {
  name: parVnetName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parAddressPrefix
      ]
    }
    subnets: [
      for (subnetName, index) in parSubnetNames: {
        name: subnetName
        properties: {
          addressPrefix: parSubnetPrefixes[index]
          routeTable: (parRouteTableId != '') ? {
            id: parRouteTableId
          } : null
        }
      }
    ]
  }
}

output outVnetId string = resVnetHub.id
output outSubnet0Id string = resVnetHub.properties.subnets[0].id
output outVnetName string = resVnetHub.name
