powershell.exe -Command "Get-NetIPInterface | select InterfaceAlias,AddressFamily,ConnectionState,Forwarding | Where-Object {$_.InterfaceAlias -match '^vEthernet'} | Sort-Object -Property InterfaceAlias,AddressFamily | Format-Table; Start-Sleep -Seconds 1"