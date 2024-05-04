param parApplicationGatewayName string
param parLocation string
param parVirtualNetworkName string
param parApplicationGatewayPublicIpName string = 'az104-06-pip5'
param parApplicationGatewayFrontendIpConfigName string = 'az104-06-pip5'
param parApplicationGatewayBackendPoolName string = 'az104-06-appgw5-be1'
param parApplicationGatewayRoutingRuleName string = 'az104-06-appgw5-rl1'
param parApplicationGatewayListenerName string = 'az104-06-appgw5-rl1l1'
param parApplicationGatewayBackendSettingsName string = 'az104-06-appgw5-http1'

resource resApplicationGateway 'Microsoft.Network/applicationGateways@2023-04-01' = {
  name: parApplicationGatewayName
  location: parLocation
  properties: {
    // Disable autoscaling
    autoscaleConfiguration: {
      maxCapacity: 2
      minCapacity: 2
    }
    backendAddressPools: [
      {
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.62.0.4'
            }
            {
              ipAddress: '10.63.0.4'
            }
          ]
        }
      }
    ]
    backendSettingsCollection: [
      {
        name: parApplicationGatewayBackendSettingsName
        properties: {
          port: 80
          protocol: 'Http'
          timeout: 20
        }
      }
    ]
    enableHttp2: false
    frontendIPConfigurations: [
      {
        name: parApplicationGatewayFrontendIpConfigName
        properties: {
          publicIPAddress: {
            id: resApplicationGatewayPublicIP.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', parVirtualNetworkName, 'subnet-appgw')
          }
        }
      }
    ]
    httpListeners: [
      {
        name: parApplicationGatewayListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', parApplicationGatewayName, parApplicationGatewayFrontendIpConfigName)
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', parApplicationGatewayName, 'port_80')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: parApplicationGatewayRoutingRuleName
        properties: {
          priority: 1
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', parApplicationGateWayName, parApplicationGatewayBackendPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', parApplicationGateWayName, parApplicationGatewayBackendSettingsName)
          }
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', parApplicationGateWayName, parApplicationGatewayListenerName)
          }
          ruleType: 'Basic'
        }
      }
    ]
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
  }
}

resource resApplicationGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: parApplicationGatewayPublicIpName
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
