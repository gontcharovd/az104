param parLocation string
param parNicName string
param parNsgName string
param parSubnetName string
param parVirtualNetworkName string
param parVmName string
param parVmSize string = 'Standard_B1ms'
param parEnableIpForwarding bool = false
@description('Virtual machine extension files are stored in a public GitHub repo.')
param parVmExtensionFilePath string = 'https://raw.githubusercontent.com/gontcharovd/az104/main/src/'
param parVmExtensionFileName string
param parAdminUsername string
@secure()
param parAdminPassword string
param parLoadBalancerName string = ''
param parLoadBalancerBackendPoolName string = ''

resource resVm 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: parVmName
  location: parLocation
  properties: {
    osProfile: {
      computerName: parVmName
      adminUsername: parAdminUsername
      adminPassword: parAdminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: parVmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: resNic.id
        }
      ]
    }
  }
}

resource parVmExtension 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  parent: resVm
  name: 'customScriptExtension'
  location: parLocation
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        uri(parVmExtensionFilePath, parVmExtensionFileName)
      ]
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ${parVmExtensionFileName}'
    }
  }
}

resource resNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: parNicName
  location: parLocation
  properties: {
    enableIPForwarding: parEnableIpForwarding
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', parVirtualNetworkName, parSubnetName)
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: resNsg.id
    }
    loadBalancerBackendAddresspools: {
      id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', parLoadBalancerName, parLoadBalancerBackendPoolName)
    }
  }
}

resource resNsg 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: parNsgName
  location: parLocation
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'default-allow-http'
        properties: {
          priority: 1100
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
