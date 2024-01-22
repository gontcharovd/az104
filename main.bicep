targetScope = 'subscription'

param location string = 'westeurope'
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
    vnetName: 'az104-06-vnet1'
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
    vnetName: 'az104-06-vnet2'
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
    vnetName: 'az104-06-vnet3'
    location: location
    addressPrefixes: vnet3Address
    subnetNames: ['subnet0']
    subnetPrefixes: ['10.63.0.0/24']
  }
}

module peerFirstVnetSecondVnet './modules/peering.bicep' = {
  name: 'peerFirstToSecond'
  scope: resourceGroup('rg1')
  params: {
    existingLocalVirtualNetworkName: 'firstVnet'
    existingRemoteVirtualNetworkName: 'secondVnet'
    existingRemoteVirtualNetworkResourceGroupName: 'secondVnetRg'
  }
}

module peerSecondVnetFirstVnet './modules/peering.bicep' = {
  name: 'peerSecondToFirst'
  scope: resourceGroup('rg2')
  params: {
    existingLocalVirtualNetworkName: 'secondVnet'
    existingRemoteVirtualNetworkName: 'firstVnet'
    existingRemoteVirtualNetworkResourceGroupName: 'firstVnetRg'
  }
}
