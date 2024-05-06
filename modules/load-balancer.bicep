param parLoadBalancerBackendPoolName string
param parLoadBalancerFrontendIpConfigName string
param parLoadBalancerHealthProbeName string
param parLoadBalancerName string
param parLoadBalancerPublicIpName string
param parLoadBalancingRuleName string
param parLocation string

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
      }
    ]
    frontendIPConfigurations: [
      {
        name: parLoadBalancerFrontendIpConfigName
        properties: {
          publicIPAddress: {
            id: resLoadBalancerPublicIP.id
          }
        }
      }
    ]
    inboundNatPools: []
    inboundNatRules: []
    loadBalancingRules: [
      {
        name: parLoadBalancingRuleName
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', parLoadBalancerName, parLoadBalancerBackendPoolName)
          }
          backendPort: 80
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', parLoadBalancerName, parLoadBalancerFrontendIpConfigName)
          }
          frontendPort: 80
          loadDistribution: 'Default'
          protocol: 'Tcp'
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', parLoadBalancerName, parLoadBalancerHealthProbeName)
          }
        }
      }
    ]
    outboundRules: []
    probes: [
      {
        name: parLoadBalancerHealthProbeName
        properties: {
          intervalInSeconds: 5
          port: 80
          probeThreshold: 2
          protocol: 'Tcp'
        }
      }
    ]
  }
}

resource resLoadBalancerPublicIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: parLoadBalancerPublicIpName
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
