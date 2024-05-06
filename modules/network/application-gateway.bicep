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
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
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
    frontendIPConfigurations: [
      {
        name: parApplicationGatewayFrontendIpConfigName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resApplicationGatewayPublicIp.id
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
    backendAddressPools: [
      {
        name: parApplicationGatewayBackendPoolName
        properties: {
          backendAddresses: [
            {
              // az104-06-vm2
              ipAddress: '10.62.0.4'
            }
            {
              // az104-06-vm3
              ipAddress: '10.63.0.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: parApplicationGatewayBackendSettingsName
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
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
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: parApplicationGatewayRoutingRuleName
        properties: {
          ruleType: 'Basic'
          priority: 1
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', parApplicationGatewayName, parApplicationGatewayBackendPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', parApplicationGatewayName, parApplicationGatewayBackendSettingsName)
          }
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', parApplicationGatewayName, parApplicationGatewayListenerName)
          }
        }
      }
    ]
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 2
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
