targetScope = 'subscription'

param parLocation string
// virtual network
param parVnet1Name string
param parVnet2Name string
param parVnet3Name string
param parVnet1Address string
param parVnet2Address string
param parVnet3Address string
// route table
param parRouteTableVnet2Name string = 'az104-06-rt23'
param parRouteTableVnet3Name string = 'az104-06-rt32'
// virtual machine
param parVm0Name string
param parVm0NicName string
param parVm0NsgName string
param parVm1Name string
param parVm1NicName string
param parVm1NsgName string
param parVm2Name string
param parVm2NicName string
param parVm2NsgName string
param parVm3Name string
param parVm3NicName string
param parVm3NsgName string
param parAdminUsername string
@secure()
param parAdminPassword string
// public load balancer
param parLoadBalancerName string
param parLoadBalancerBackendPoolName string
param parLoadBalancerPublicIpName string
param parLoadBalancerFrontendIpConfigName string
param parLoadBalancingRuleName string
param parLoadBalancerHealthProbeName string
// application gateway
param parApplicationGatewayName string
param parApplicationGatewayPublicIpName string
param parApplicationGatewayFrontendIpConfigName string
param parApplicationGatewayBackendPoolName string
param parApplicationGatewayRoutingRuleName string
param parApplicationGatewayListenerName string
param parApplicationGatewayBackendSettingsName string

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

module modVnet1 './modules/virtual-network.bicep' = {
  name: 'vnet1'
  scope: resRg1
  params: {
    parAddressPrefix: parVnet1Address
    parLocation: parLocation
    parSubnetNames: ['subnet0', 'subnet1', 'subnet-appgw']
    parSubnetPrefixes: ['10.60.0.0/24', '10.60.1.0/24', '10.60.3.224/27']
    parVnetName: parVnet1Name
  }
}

module modVnet2 './modules/virtual-network.bicep' = {
  name: 'vnet2'
  scope: resRg2
  params: {
    parAddressPrefix: parVnet2Address
    parLocation: parLocation
    parRouteTableId: modVnet2RouteTable.outputs.outRouteTableId
    parSubnetNames: ['subnet0']
    parSubnetPrefixes: ['10.62.0.0/24']
    parVnetName: parVnet2Name
  }
}

module modVnet3 './modules/virtual-network.bicep' = {
  name: 'vnet3'
  scope: resRg3
  params: {
    parAddressPrefix: parVnet3Address
    parLocation: parLocation
    parRouteTableId: modVnet3RouteTable.outputs.outRouteTableId
    parSubnetNames: ['subnet0']
    parSubnetPrefixes: ['10.63.0.0/24']
    parVnetName: parVnet3Name
  }
}

module modPeer12 './modules/peering.bicep' = {
  name: 'peer12'
  scope: resRg1
  params: {
    parDestinationVnetId: modVnet2.outputs.outVnetId
    parDestinationVnetName: modVnet2.outputs.outVnetName
    parSourceVnetName: modVnet1.outputs.outVnetName
  }
}

module modPeer21 './modules/peering.bicep' = {
  name: 'peer21'
  scope: resRg2
  params: {
    parDestinationVnetId: modVnet1.outputs.outVnetId
    parDestinationVnetName: modVnet1.outputs.outVnetName
    parSourceVnetName: modVnet2.outputs.outVnetName
  }
}

module modPeer13 './modules/peering.bicep' = {
  name: 'peer13'
  scope: resRg1
  params: {
    parDestinationVnetId: modVnet3.outputs.outVnetId
    parDestinationVnetName: modVnet3.outputs.outVnetName
    parSourceVnetName: modVnet1.outputs.outVnetName
  }
}

module modPeer31 './modules/peering.bicep' = {
  name: 'peer31'
  scope: resRg3
  params: {
    parDestinationVnetId: modVnet1.outputs.outVnetId
    parDestinationVnetName: modVnet1.outputs.outVnetName
    parSourceVnetName: modVnet3.outputs.outVnetName
  }
}

module modVm0 './modules/virtual-machine.bicep' = {
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
    parLoadBalancerName: modPublicLoadBalancer.outputs.outLoadBalancerName
    parLoadBalancerBackendPoolName: modPublicLoadBalancer.outputs.outLoadBalancerBackendPoolName
  }
}

module modVm1 './modules/virtual-machine.bicep' = {
  name: 'vm1'
  scope: resRg1
  params: {
    parAdminPassword: parAdminPassword
    parAdminUsername: parAdminUsername
    parLoadBalancerBackendPoolName: modPublicLoadBalancer.outputs.outLoadBalancerBackendPoolName
    parLocation: parLocation
    parNicName: parVm1NicName
    parNsgName: parVm1NsgName
    parSubnetName: 'subnet1'
    parVirtualNetworkName: modVnet1.outputs.outVnetName
    parVmName: parVm1Name
  }
}

module modVm2 './modules/virtual-machine.bicep' = {
  name: 'vm2'
  scope: resRg2
  params: {
    parAdminPassword: parAdminPassword
    parAdminUsername: parAdminUsername
    parLocation: parLocation
    parNicName: parVm2NicName
    parNsgName: parVm2NsgName
    parSubnetName: 'subnet0'
    parVirtualNetworkName: modVnet2.outputs.outVnetName
    parVmName: parVm2Name
  }
}

module modVm3 './modules/virtual-machine.bicep' = {
  name: 'vm3'
  scope: resRg3
  params: {
    parAdminPassword: parAdminPassword
    parAdminUsername: parAdminUsername
    parLocation: parLocation
    parNicName: parVm3NicName
    parNsgName: parVm3NsgName
    parSubnetName: 'subnet0'
    parVirtualNetworkName: modVnet3.outputs.outVnetName
    parVmName: parVm3Name
  }
}

module modVnet2RouteTable './modules/route-table.bicep' = {
  name: 'vm2RouteTable'
  scope: resRg2
  params: {
    parLocation: parLocation
    parRoute: {
      name: parRouteTableVnet2Name
      addressPrefix: '10.63.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
    parRouteTableName: 'vm2RouteTable'
  }
}

module modVnet3RouteTable './modules/route-table.bicep' = {
  name: 'vm3RouteTable'
  scope: resRg3
  params: {
    parLocation: parLocation
    parRoute: {
      name: parRouteTableVnet3Name
      addressPrefix: '10.62.0.0/16'
      nextHopIpAddress: '10.60.0.4'
      nextHopType: 'VirtualAppliance'
    }
    parRouteTableName: 'vm3RouteTable'
  }
}

module modPublicLoadBalancer './modules/load-balancer.bicep' = {
  name: 'publicLoadBalancer'
  scope: resRg1
  params: {
    parLoadBalancerBackendPoolName: parLoadBalancerBackendPoolName
    parLoadBalancerFrontendIpConfigName: parLoadBalancerFrontendIpConfigName
    parLoadBalancerHealthProbeName: parLoadBalancerHealthProbeName
    parLoadBalancerName: parLoadBalancerName
    parLoadBalancerPublicIpName: parLoadBalancerPublicIpName
    parLoadBalancingRuleName: parLoadBalancingRuleName
    parLocation: parLocation
  }
}

module modApplicationGateway './modules/application-gateway.bicep' = {
  name: 'applicationGateway'
  scope: resRg1
  params: {
    parApplicationGatewayBackendPoolName: parApplicationGatewayBackendPoolName
    parApplicationGatewayBackendSettingsName: parApplicationGatewayBackendSettingsName
    parApplicationGatewayFrontendIpConfigName: parApplicationGatewayFrontendIpConfigName
    parApplicationGatewayListenerName: parApplicationGatewayListenerName
    parApplicationGatewayName: parApplicationGatewayName
    parApplicationGatewayPublicIpName: parApplicationGatewayPublicIpName
    parApplicationGatewayRoutingRuleName: parApplicationGatewayRoutingRuleName
    parLocation: parLocation
    parVirtualNetworkName: modVnet1.outputs.outVnetName
  }
}
