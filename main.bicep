targetScope = 'subscription'

param location string = 'westeurope'
param vnet1Name string = 'az104-06-vnet01'
param vnet2Name string = 'az104-06-vnet2'
param vnet3Name string = 'az104-06-vnet3'
param vnet1Address string = '10.60.0.0/22'
param vnet2Address string = '10.62.0.0/22'
param vnet3Address string = '10.63.0.0/22'
param vm0Name string = 'az104-06-vm0'
param vm0NicName string = 'az104-06-vm0-nic'
param vm0NsgName string = 'az104-06-vm0-nsg'
param vm1Name string = 'az104-06-vm1'
param vm1NicName string = 'az104-06-vm1-nic'
param vm1NsgName string = 'az104-06-vm1-nsg'
param vm2Name string = 'az104-06-vm2'
param vm2NicName string = 'az104-06-vm2-nic'
param vm2NsgName string = 'az104-06-vm2-nsg'
param vm3Name string = 'az104-06-vm3'
param vm3NicName string = 'az104-06-vm3-nic'
param vm3NsgName string = 'az104-06-vm3-nsg'
param adminUsername string = 'az104Admin'
@secure()
param adminPassword string

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

module vnet1 './modules/network/vnet-hub.bicep' = {
  name: 'vnet1'
  scope: rg1
  params: {
    vnetName: vnet1Name
    location: location
    addressPrefix: vnet1Address
    subnetNames: ['subnet0', 'subnet1']
    subnetPrefixes: ['10.60.0.0/24', '10.60.1.0/24']
  }
}

module vnet2 './modules/network/vnet-spoke.bicep' = {
  name: 'vnet2'
  scope: rg2
  params: {
    vnetName: vnet2Name
    location: location
    addressPrefix: vnet2Address
    subnetName: 'subnet0'
    subnetPrefix: '10.62.0.0/24'
    routeTableId: vnet2RouteTable.outputs.routeTableId
  }
}

module vnet3 './modules/network/vnet-spoke.bicep' = {
  name: 'vnet3'
  scope: rg3
  params: {
    vnetName: vnet3Name
    location: location
    addressPrefix: vnet3Address
    subnetName: 'subnet0'
    subnetPrefix: '10.63.0.0/24'
    routeTableId: vnet2RouteTable.outputs.routeTableId
  }
}

module peer12 './modules/network/peering.bicep' = {
  name: 'peer12'
  scope: rg1
  params: {
    sourceVnetName: vnet1.outputs.vnetName
    destinationVnetName: vnet2.outputs.vnetName
    destinationVnetId: vnet2.outputs.vnetId
  }
}

module peer21 './modules/network/peering.bicep' = {
  name: 'peer21'
  scope: rg2
  params: {
    sourceVnetName: vnet2.outputs.vnetName
    destinationVnetName: vnet1.outputs.vnetName
    destinationVnetId: vnet1.outputs.vnetId
  }
}

module peer13 './modules/network/peering.bicep' = {
  name: 'peer13'
  scope: rg1
  params: {
    sourceVnetName: vnet1.outputs.vnetName
    destinationVnetName: vnet3.outputs.vnetName
    destinationVnetId: vnet3.outputs.vnetId
  }
}

module peer31 './modules/network/peering.bicep' = {
  name: 'peer31'
  scope: rg3
  params: {
    sourceVnetName: vnet3.outputs.vnetName
    destinationVnetName: vnet1.outputs.vnetName
    destinationVnetId: vnet1.outputs.vnetId
  }
}

module vm0 './modules/compute/vm.bicep' = {
  name: 'vm0'
  scope: rg1
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicName: vm0NicName
    nsgName: vm0NsgName
    virtualNetworkName: vnet1.outputs.vnetName
    subnetName: 'subnet0'
    vmName: vm0Name
    enableIpForwarding: true
    vmExtensionFileName: 'configure-ip-forwarding.ps1'
  }
}

module vm1 './modules/compute/vm.bicep' = {
  name: 'vm1'
  scope: rg1
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicName: vm1NicName
    nsgName: vm1NsgName
    virtualNetworkName: vnet1.outputs.vnetName
    subnetName: 'subnet1'
    vmName: vm1Name
    vmExtensionFileName: 'configure-ip-forwarding.ps1'
  }
}

module vm2 './modules/compute/vm.bicep' = {
  name: 'vm2'
  scope: rg2
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicName: vm2NicName
    nsgName: vm2NsgName
    virtualNetworkName: vnet2.outputs.vnetName
    subnetName: 'subnet0'
    vmName: vm2Name
    vmExtensionFileName: 'configure-webserver.ps1'
  }
}

module vm3 './modules/compute/vm.bicep' = {
  name: 'vm3'
  scope: rg3
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicName: vm3NicName
    nsgName: vm3NsgName
    virtualNetworkName: vnet3.outputs.vnetName
    subnetName: 'subnet0'
    vmName: vm3Name
    vmExtensionFileName: 'configure-webserver.ps1'
  }
}

module vnet2RouteTable './modules/network/route-table.bicep' = {
  name: 'vm2RouteTable'
  scope: rg2
  params: {
    routeTableName: 'vm2RouteTable'
    location: location
    route: {
      name: 'routeVm2ToVm3'
      addressPrefix: '10.63.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
  }
}

module vnet3RouteTable './modules/network/route-table.bicep' = {
  name: 'vm3RouteTable'
  scope: rg3
  params: {
    routeTableName: 'vm3RouteTable'
    location: location
    route: {
      name: 'routeVm3ToVm2'
      addressPrefix: '10.62.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
  }
}
