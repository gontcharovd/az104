# Install the remote access Windows feature with associated tools
Install-WindowsFeature RemoteAccess -IncludeManagementTools
Install-WindowsFeature -Name Routing -IncludeManagementTools -IncludeAllSubfeature
Install-WindowsFeature -Name "RSAT-RemoteAccess-Powershell"
Install-RemoteAccess -VpnType RoutingOnly
Get-NetAdapter | Set-NetIPInterface -Forwarding Enabled

# Install webserver
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Configure simple "Hello World" web page
remove-item 'C:\inetpub\wwwroot\iisstart.htm'
Add-Content -Path 'C:\inetpub\wwwroot\iisstart.htm' `
	-Value $('Hello World from ' + $env:computername)