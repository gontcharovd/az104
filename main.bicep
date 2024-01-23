targetScope = 'subscription'

param location string = 'westeurope'
param vnet1Name string = 'az104-06-vnet1'
param vnet2Name string = 'az104-06-vnet2'
param vnet3Name string = 'az104-06-vnet3'
param vnet1Address string = '10.60.0.0/16'
param vnet2Address string = '10.62.0.0/16'
param vnet3Address string = '10.63.0.0/16'

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
    vnetName: vnet1Name
    location: location
    addressPrefixes: vnet1Address
    subnetNames: ['subnet0', 'subnet1']
    subnetPrefixes: ['10.60.0.0/24', '10.60.1.0/24']
  }
}

module vnet2 './modules/vnet.bicep' = {
  name: 'vnet2'
  scope: rg2
  params: {
    vnetName: vnet2Name
    location: location
    addressPrefixes: vnet2Address
    subnetNames: ['subnet0']
    subnetPrefixes: ['10.62.0.0/24']
  }
}

module vnet3 './modules/vnet.bicep' = {
  name: 'vnet3'
  scope: rg3
  params: {
    vnetName: vnet3Name
    location: location
    addressPrefixes: vnet3Address
    subnetNames: ['subnet0']
    subnetPrefixes: ['10.63.0.0/24']
  }
}

module peer12 './modules/peering.bicep' = {
  name: 'peer12'
  scope: rg1
  params: {
    sourceVnetName: vnet1Name
    destinationVnetName: vnet2Name
    destinationVnetId: vnet2.outputs.vnetId
  }
}

module peer21 './modules/peering.bicep' = {
  name: 'peer21'
  scope: rg2
  params: {
    sourceVnetName: vnet2Name
    destinationVnetName: vnet1Name
    destinationVnetId: vnet1.outputs.vnetId
  }
}

module peer13 './modules/peering.bicep' = {
  name: 'peer13'
  scope: rg1
  params: {
    sourceVnetName: vnet1Name
    destinationVnetName: vnet3Name
    destinationVnetId: vnet3.outputs.vnetId
  }
}

module peer31 './modules/peering.bicep' = {
  name: 'peer31'
  scope: rg3
  params: {
    sourceVnetName: vnet3Name
    destinationVnetName: vnet1Name
    destinationVnetId: vnet1.outputs.vnetId
  }
}
