param name string 
param addressPrefixes string 
param location string
param subnetNames array
param subnetPrefixes array


resource vnet1 'microsoft.network/virtualnetworks@2021-05-01' = {
  name: name
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

