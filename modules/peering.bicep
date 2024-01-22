param sourceVnet object
param destinationVnet object

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: 'peer-${sourceVnet.name}-to-${destinationVnet.name}'
  parent: sourceVnet.name
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: destinationVnet.Id
    }
  }
}
