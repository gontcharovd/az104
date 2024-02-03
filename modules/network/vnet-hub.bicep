param vnetName string 
param addressPrefix string 
param location string
param subnetNames array
param subnetPrefixes array

resource vnetHub 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
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

output vnetId string = vnetHub.id
output vnetName string = vnetHub.name
