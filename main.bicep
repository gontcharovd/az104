targetScope = 'subscription'

param location string = 'westeurope'

resource rg1 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg1'
  location: location
}

resource rg2 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg2'
  location: location
}

resource rg3 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg3'
  location: location
}

resource rg4 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg4'
  location: location
}

module vnet1 './modules/vnet.bicep' = {
  name: 'vnet1'
  scope: rg1
  params: {
    name: 'az104-06-vnet1'
    location: location
    addressPrefixes: '10.60.0.0/16'
    subnetNames: ['subnet0', 'subnet1']
    subnetPrefixes: ['10.60.0.0/24', '10.60.1.0/24']
  }
}

module vnet2 './modules/vnet.bicep' = {
  name: 'vnet2'
  scope: rg2
  params: {
    name: 'az104-06-vnet2'
    location: location
    addressPrefixes: '10.62.0.0/16'
    subnetNames: ['subnet0']
    subnetPrefixes: ['10.62.0.0/24']
  }
}

module vnet3 './modules/vnet.bicep' = {
  name: 'vnet3'
  scope: rg3
  params: {
    name: 'az104-06-vnet3'
    location: location
    addressPrefixes: '10.63.0.0/16'
    subnetNames: ['subnet0']
    subnetPrefixes: ['10.63.0.0/24']
  }
}
