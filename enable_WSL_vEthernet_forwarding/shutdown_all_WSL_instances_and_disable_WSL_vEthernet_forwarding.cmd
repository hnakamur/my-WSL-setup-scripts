wsl.exe --shutdown
powershell.exe -Command "Start-Process powershell.exe -Verb RunAs -ArgumentList \"-ExecutionPolicy ByPass -WindowStyle Hidden -Command Set-NetIPInterface -InterfaceAlias 'vEthernet (WSL)' -Forwarding Disabled\""
