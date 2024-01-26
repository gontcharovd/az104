@description('VM size')
param vmSize string = 'Standard_D2s_v3'

@description('VM name Prefix')
param vmName string = 'az104-06-vm'

@description('Number of VMs')
param vmCount int = 4

@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

var vmExtensionName = 'customScriptExtension'
var nic_var = 'az104-06-nic'
var virtualNetworkNames = [
  'az104-06-vnet01'
  'az104-06-vnet01'
  'az104-06-vnet2'
  'az104-06-vnet3'
]
var virtualNetworkNamestbc_var = [
  'az104-06-vnet01'
  'az104-06-vnet2'
  'az104-06-vnet3'
]
var VNetPrefixes = [
  '10.60'
  '10.62'
  '10.63'
]
var nsgNames = [
  'az104-06-nsg01'
  'az104-06-nsg01'
  'az104-06-nsg2'
  'az104-06-nsg3'
]
var nsgNamestbc_var = [
  'az104-06-nsg01'
  'az104-06-nsg2'
  'az104-06-nsg3'
]
var subnetName = 'subnet'
var subnetRefs = [
  0
  1
  0
  0
]
var computeApiVersion = '2018-06-01'
var networkApiVersion = '2018-08-01'

resource vm 'Microsoft.Compute/virtualMachines@2018-06-01' = [for i in range(0, vmCount): {
  name: concat(vmName, i)
  location: resourceGroup().location
  properties: {
    osProfile: {
      computerName: concat(vmName, i)
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
          id: resourceId('Microsoft.Network/networkInterfaces', concat(nic_var, i))
        }
      ]
    }
  }
  dependsOn: [
    reference(concat(nic_var, i))
  ]
}]

resource vmName_vmExtension 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = [for i in range(0, vmCount): {
  name: '${vmName}${i}/${vmExtensionName}'
  location: resourceGroup().location
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
    'Microsoft.Compute/virtualMachines/${vmName}${i}'
  ]
}]

resource virtualNetworkNamestbc 'Microsoft.Network/virtualNetworks@2018-08-01' = [for (item, i) in virtualNetworkNamestbc_var: {
  name: item
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '${VNetPrefixes[i]}.0.0/22'
      ]
    }
    subnets: [
      {
        name: '${subnetName}0'
        properties: {
          addressPrefix: '${VNetPrefixes[i]}.0.0/24'
        }
      }
    ]
  }
}]

resource az104_06_vnet01_subnet1 'Microsoft.Network/virtualNetworks/subnets@2018-08-01' = {
  location: resourceGroup().location
  name: 'az104-06-vnet01/subnet1'
  properties: {
    addressPrefix: '10.60.1.0/24'
  }
  dependsOn: [
    'Microsoft.Network/virtualNetworks/az104-06-vnet01'
  ]
}

resource nic 'Microsoft.Network/networkInterfaces@2018-08-01' = [for i in range(0, vmCount): {
  name: concat(nic_var, i)
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkNames[i], concat(subnetName, subnetRefs[i]))
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames[i])
    }
  }
  dependsOn: [
    nsgNames[i]
    'Microsoft.Network/virtualNetworks/${virtualNetworkNames[i]}'
  ]
}]

resource nsgNamestbc 'Microsoft.Network/networkSecurityGroups@2018-08-01' = [for i in range(0, 3): {
  name: nsgNamestbc_var[i]
  location: resourceGroup().location
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
