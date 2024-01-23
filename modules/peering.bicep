param sourceVnetName string
param destinationVnetName string
param destinationVnetId string

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: '${sourceVnetName}/peer-${sourceVnetName}-to-${destinationVnetName}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: destinationVnetId
    }
  }
}
