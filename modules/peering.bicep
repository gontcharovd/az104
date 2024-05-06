param parDestinationVnetId string
param parDestinationVnetName string
param parSourceVnetName string

resource resPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: '${parSourceVnetName}/peer-${parSourceVnetName}-to-${parDestinationVnetName}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: parDestinationVnetId
    }
  }
}
