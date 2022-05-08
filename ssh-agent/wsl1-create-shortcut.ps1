$InstallDir = 'C:\wsl-ssh-agent'

function Create-Shortcut {
    param ( [string]$SourceExe, [string]$Arguments, [string]$DestinationPath )
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $SourceExe
    $Shortcut.Arguments = $Arguments
    $Shortcut.Save()
}

$StartupDir = (New-Object -ComObject Shell.Application).NameSpace('shell:StartUp').Self.Path
$DestinationPath = "$StartupDir\wsl-ssh-agent-gui.lnk"
if (-not (Test-Path $DestinationPath)) {
    Create-Shortcut -SourceExe "$InstallDir\wsl-ssh-agent-gui.exe" -Arguments "-socket $InstallDir\ssh-agent.sock" -DestinationPath $DestinationPath
    Start-Process -FilePath $InstallDir\wsl-ssh-agent-gui.exe -ArgumentList "-socket $InstallDir\ssh-agent.sock"
}
