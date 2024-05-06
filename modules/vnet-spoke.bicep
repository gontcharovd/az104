param parAddressPrefix string 
param parLocation string
param parRouteTableId string
param parSubnetName string
param parSubnetPrefix string
param parVnetName string 

resource resVnetSpoke 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: parVnetName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parAddressPrefix
      ]
    }
    // spoke vnets have only one subnet
    subnets: [
      {
        name: parSubnetName
        properties: {
          addressPrefix: parSubnetPrefix
          routeTable: {
            id: parRouteTableId
          }
        }
      }
    ]
  }
}

output outVnetId string = resVnetSpoke.id
output outVnetName string = resVnetSpoke.name
