targetScope = 'subscription'

param parLocation string = 'westeurope'
param parVnet1Name string = 'az104-06-vnet01'
param parVnet2Name string = 'az104-06-vnet2'
param parVnet3Name string = 'az104-06-vnet3'
param parVnet1Address string = '10.60.0.0/22'
param parVnet2Address string = '10.62.0.0/22'
param parVnet3Address string = '10.63.0.0/22'
param parVm0Name string = 'az104-06-vm0'
param parVm0NicName string = 'az104-06-vm0-nic'
param parVm0NsgName string = 'az104-06-vm0-nsg'
param parVm1Name string = 'az104-06-vm1'
param parVm1NicName string = 'az104-06-vm1-nic'
param parVm1NsgName string = 'az104-06-vm1-nsg'
param parVm2Name string = 'az104-06-vm2'
param parVm2NicName string = 'az104-06-vm2-nic'
param parVm2NsgName string = 'az104-06-vm2-nsg'
param parVm3Name string = 'az104-06-vm3'
param parVm3NicName string = 'az104-06-vm3-nic'
param parVm3NsgName string = 'az104-06-vm3-nsg'
param parAdminUsername string = 'az104Admin'
@secure()
param parAdminPassword string
param parLoadBalancerName string = 'az104-06-lb4'

resource resRg1 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg1'
  location: parLocation
}

resource resRg2 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg2'
  location: parLocation
}

resource resRg3 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg3'
  location: parLocation
}

resource resRg4 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'az104-06-rg4'
  location: parLocation
}

module modVnet1 './modules/network/vnet-hub.bicep' = {
  name: 'vnet1'
  scope: resRg1
  params: {
    parVnetName: parVnet1Name
    parLocation: parLocation
    parAddressPrefix: parVnet1Address
    parSubnetNames: ['subnet0', 'subnet1']
    parSubnetPrefixes: ['10.60.0.0/24', '10.60.1.0/24']
  }
}

module modVnet2 './modules/network/vnet-spoke.bicep' = {
  name: 'vnet2'
  scope: resRg2
  params: {
    parVnetName: parVnet2Name
    parLocation: parLocation
    parAddressPrefix: parVnet2Address
    parSubnetName: 'subnet0'
    parSubnetPrefix: '10.62.0.0/24'
    parRouteTableId: modVnet2RouteTable.outputs.outRouteTableId
  }
}

module modVnet3 './modules/network/vnet-spoke.bicep' = {
  name: 'vnet3'
  scope: resRg3
  params: {
    parVnetName: parVnet3Name
    parLocation: parLocation
    parAddressPrefix: parVnet3Address
    parSubnetName: 'subnet0'
    parSubnetPrefix: '10.63.0.0/24'
    parRouteTableId: modVnet3RouteTable.outputs.outRouteTableId
  }
}

module modPeer12 './modules/network/peering.bicep' = {
  name: 'peer12'
  scope: resRg1
  params: {
    parSourceVnetName: modVnet1.outputs.outVnetName
    parDestinationVnetName: modVnet2.outputs.outVnetName
    parDestinationVnetId: modVnet2.outputs.outVnetId
  }
}

module modPeer21 './modules/network/peering.bicep' = {
  name: 'peer21'
  scope: resRg2
  params: {
    parSourceVnetName: modVnet2.outputs.outVnetName
    parDestinationVnetName: modVnet1.outputs.outVnetName
    parDestinationVnetId: modVnet1.outputs.outVnetId
  }
}

module modPeer13 './modules/network/peering.bicep' = {
  name: 'peer13'
  scope: resRg1
  params: {
    parSourceVnetName: modVnet1.outputs.outVnetName
    parDestinationVnetName: modVnet3.outputs.outVnetName
    parDestinationVnetId: modVnet3.outputs.outVnetId
  }
}

module modPeer31 './modules/network/peering.bicep' = {
  name: 'peer31'
  scope: resRg3
  params: {
    parSourceVnetName: modVnet3.outputs.outVnetName
    parDestinationVnetName: modVnet1.outputs.outVnetName
    parDestinationVnetId: modVnet1.outputs.outVnetId
  }
}

module modVm0 './modules/compute/vm.bicep' = {
  name: 'vm0'
  scope: resRg1
  params: {
    parLocation: parLocation
    parAdminUsername: parAdminUsername
    parAdminPassword: parAdminPassword
    parNicName: parVm0NicName
    parNsgName: parVm0NsgName
    parVirtualNetworkName: modVnet1.outputs.outVnetName
    parSubnetName: 'subnet0'
    parVmName: parVm0Name
    parEnableIpForwarding: true
    parVmExtensionFileName: 'configure-ip-forwarding.ps1'
  }
}

module vm1 './modules/compute/vm.bicep' = {
  name: 'vm1'
  scope: resRg1
  params: {
    parLocation: parLocation
    parAdminUsername: parAdminUsername
    parAdminPassword: parAdminPassword
    parNicName: parVm1NicName
    parNsgName: parVm1NsgName
    parVirtualNetworkName: modVnet1.outputs.outVnetName
    parSubnetName: 'subnet1'
    parVmName: parVm1Name
    parVmExtensionFileName: 'configure-ip-forwarding.ps1'
  }
}

module modVm2 './modules/compute/vm.bicep' = {
  name: 'vm2'
  scope: resRg2
  params: {
    parLocation: parLocation
    parAdminUsername: parAdminUsername
    parAdminPassword: parAdminPassword
    parNicName: parVm2NicName
    parNsgName: parVm2NsgName
    parVirtualNetworkName: modVnet2.outputs.outVnetName
    parSubnetName: 'subnet0'
    parVmName: parVm2Name
    parVmExtensionFileName: 'configure-webserver.ps1'
  }
}

module modVm3 './modules/compute/vm.bicep' = {
  name: 'vm3'
  scope: resRg3
  params: {
    parLocation: parLocation
    parAdminUsername: parAdminUsername
    parAdminPassword: parAdminPassword
    parNicName: parVm3NicName
    parNsgName: parVm3NsgName
    parVirtualNetworkName: modVnet3.outputs.outVnetName
    parSubnetName: 'subnet0'
    parVmName: parVm3Name
    parVmExtensionFileName: 'configure-webserver.ps1'
  }
}

module modVnet2RouteTable './modules/network/route-table.bicep' = {
  name: 'vm2RouteTable'
  scope: resRg2
  params: {
    parRouteTableName: 'vm2RouteTable'
    parLocation: parLocation
    parRoute: {
      name: 'routeVm2ToVm3'
      addressPrefix: '10.63.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
  }
}

module modVnet3RouteTable './modules/network/route-table.bicep' = {
  name: 'vm3RouteTable'
  scope: resRg3
  params: {
    parRouteTableName: 'vm3RouteTable'
    parLocation: parLocation
    parRoute: {
      name: 'routeVm3ToVm2'
      addressPrefix: '10.62.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
  }
}

module modPublicLoadBalancer './modules/network/load-balancer.bicep' = {
  name: 'publicLoadBalancer'
  scope: resRg4
  params: {
    parLoadBalancerName: parLoadBalancerName
    parLocation: parLocation
    parSubnetId: modVnet1.outputs.outSubnet0Id
  }
}
