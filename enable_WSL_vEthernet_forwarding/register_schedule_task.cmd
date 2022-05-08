@echo off
echo $folderName = '\MyTasks';^
$taskName = 'Enable WSL vEthernet forwarding';^
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent();^
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser);^
if (-not($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))) {^
  Write-Output 'This script must be run as administrator.';^
  Start-Sleep -Seconds 1;^
  exit;^
}^
if ((Get-ScheduledTaskInfo -TaskName "$folderName\$taskName" -ErrorAction SilentlyContinue) -eq $null) {^
    $action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/c wsl.exe echo start default WSL instance and enable forwardning of vEthernet \(WSL\)^&^& powershell.exe -Command ""Set-NetIPInterface -InterfaceAlias 'vEthernet (WSL)' -Forwarding Enabled""";^
    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser.Name;^
    $principal = New-ScheduledTaskPrincipal $currentUser.Name -RunLevel Highest;^
    Register-ScheduledTask -TaskName $taskName -TaskPath $folderName -Action $action -Principal $principal -Trigger $trigger;^
} | powershell.exe -
