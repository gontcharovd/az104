param loadBalancerName string
param location string
param subnetId string


resource symbolicname 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: loadBalancerName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    backendAddressPools: [
      // {
      //   id: 'string'
      //   name: 'string'
      //   properties: {
      //     // drainPeriodInSeconds: int
      //     loadBalancerBackendAddresses: [
      //       {
      //         name: 'string'
      //         properties: {
      //           adminState: 'None'
      //           ipAddress: 'string'
      //           loadBalancerFrontendIPConfiguration: {
      //             id: 'string'
      //           }
      //           subnet: {
      //             id: 'string'
      //           }
      //           virtualNetwork: {
      //             id: 'string'
      //           }
      //         }
      //       }
      //     ]
      //     location: 'string'
      //     syncMode: 'string'
      //     tunnelInterfaces: [
      //       {
      //         identifier: int
      //         port: int
      //         protocol: 'string'
      //         type: 'string'
      //       }
      //     ]
      //     virtualNetwork: {
      //       id: 'string'
      //     }
      //   }
      // }
    ]
    frontendIPConfigurations: [
      {
        name: 'az104-06-pip4'
        properties: {
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            location: location
            properties: {
              publicIPAddressVersion: 'IPv4'
              publicIPAllocationMethod: 'Dynamic'
            }
          sku: {
              name: 'Standard'
              tier: 'Regional'
            }
          }
          subnet: {
            id: subnetId
            name: 'string'
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
