param location string
param nicName string
param nsgName string
param subnetName string
param virtualNetworkName string
param vmName string
param vmSize string = 'Standard_D2s_v3'
param adminUsername string
@secure()
param adminPassword string

resource vm 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: vmName
  location: location
  properties: {
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: 'true'
      }
    }
    hardwareProfile: {
      vmSize: vmSize
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
          id: resourceId('Microsoft.Network/networkInterfaces', nicName)
        }
      ]
    }
  }
  dependsOn: [
    reference(nicName)
  ]
}]

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  name: '${vmName}/customScriptExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\' && powershell.exe Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' -Value $(\'Hello World from \' + $env:computername)'
    }
  }
  dependsOn: [
    'Microsoft.Compute/virtualMachines/${vmName}'
  ]
}]

resource nic 'Microsoft.Network/networkInterfaces@2018-08-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nsgName)
    }
  }
  dependsOn: [
    nsgName
   'Microsoft.Network/virtualNetworks/virtualNetworkName'
  ]
}]

resource nsg 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: nsgName
  location: location
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
}]
