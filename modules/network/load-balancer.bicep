param parLoadBalancerName string
param parLocation string
param parBackendPoolVnetId string
param parLoadBalancerBackendPoolName string = 'az104-06-be1'

resource resLoadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: parLoadBalancerName
  location: parLocation
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    backendAddressPools: [
      {
        name: parLoadBalancerBackendPoolName
        properties: {
          loadBalancerBackendAddresses: [for vm in parBackendPoolVMs : {
            name: 'string'
            properties: {
              ipAddress: 'string'
            }
          }]
          virtualNetwork: {
            id: parBackendPoolVnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'az104-06-pip4'
        properties: {
          publicIPAddress: {
            id: resLbPublicIP.id
          }
        }
      }
    ]
    inboundNatPools: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     backendPort: int
      //     enableFloatingIP: bool
      //     enableTcpReset: bool
      //     frontendIPConfiguration: {
      //       id: 'string'
      //     }
      //     frontendPortRangeEnd: int
      //     frontendPortRangeStart: int
      //     idleTimeoutInMinutes: int
      //     protocol: 'string'
      //   }
      // }
    ]
    inboundNatRules: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     backendAddressPool: {
      //       id: 'string'
      //     }
      //     backendPort: int
      //     enableFloatingIP: bool
      //     enableTcpReset: bool
      //     frontendIPConfiguration: {
      //       id: 'string'
      //     }
      //     frontendPort: int
      //     frontendPortRangeEnd: int
      //     frontendPortRangeStart: int
      //     idleTimeoutInMinutes: int
      //     protocol: 'string'
      //   }
      // }
    ]
    loadBalancingRules: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     backendAddressPool: {
      //       id: 'string'
      //     }
      //     backendAddressPools: [
      //       {
      //         id: 'string'
      //       }
      //     ]
      //     backendPort: int
      //     disableOutboundSnat: bool
      //     enableFloatingIP: bool
      //     enableTcpReset: bool
      //     frontendIPConfiguration: {
      //       id: 'string'
      //     }
      //     frontendPort: int
      //     idleTimeoutInMinutes: int
      //     loadDistribution: 'string'
      //     probe: {
      //       id: 'string'
      //     }
      //     protocol: 'string'
      //   }
      // }
    ]
    outboundRules: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     allocatedOutboundPorts: int
      //     backendAddressPool: {
      //       id: 'string'
      //     }
      //     enableTcpReset: bool
      //     frontendIPConfigurations: [
      //       {
      //         id: 'string'
      //       }
      //     ]
      //     idleTimeoutInMinutes: int
      //     protocol: 'string'
      //   }
      // }
    ]
    probes: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     intervalInSeconds: int
      //     numberOfProbes: int
      //     port: int
      //     probeThreshold: int
      //     protocol: 'string'
      //     requestPath: 'string'
      //   }
      // }
    ]
  }
}

resource resLbPublicIP'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: 'lbPublicIP'
  location: parLocation
  sku: {
      name: 'Standard'
      tier: 'Regional'
    }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

output outLoadBalancerName string = parLoadBalancerName
output outLoadBalancerBackendPoolName string = parLoadBalancerBackendPoolName
