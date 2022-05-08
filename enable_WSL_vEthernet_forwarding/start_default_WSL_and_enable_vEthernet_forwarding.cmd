wsl.exe echo 'Start default WSL2 instance and enable fowarding of "vEthernet \(WSL\)"'
powershell.exe -Command "Start-Process powershell.exe -Verb RunAs -ArgumentList \"-ExecutionPolicy ByPass -WindowStyle Hidden -Command Set-NetIPInterface -InterfaceAlias 'vEthernet (WSL)' -Forwarding Enabled\""
