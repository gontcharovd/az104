# Install "Hello World" webserver
Install-WindowsFeature -name Web-Server -IncludeManagementTools
remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\'
Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' `
	-Value $(\'Hello World from \' + $env:computername)
