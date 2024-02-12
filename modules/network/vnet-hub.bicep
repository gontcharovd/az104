param parVnetName string 
param parAddressPrefix string 
param parLocation string
param parSubnetNames array
param parSubnetPrefixes array

resource resVnetHub 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: parVnetName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parAddressPrefix
      ]
    }
    subnets: [
      // hub subnets have no routing table
      for (subnetName, index) in parSubnetNames: {
        name: subnetName
        properties: {
          addressPrefix: parSubnetPrefixes[index]
        }
      }
    ]
  }
}

output outVnetId string = resVnetHub.id
output outSubnet0Id string = resVnetHub.properties.subnets[0].id
output outVnetName string = resVnetHub.name
