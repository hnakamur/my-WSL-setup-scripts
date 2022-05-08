#Requires -RunAsAdministrator
function StartAndEnable-Service {
    param (
        [Parameter(Mandatory)]
        [string]$serviceName
    )

    $service = (Get-Service $serviceName -ErrorAction SilentlyContinue)
    if ($service.Status -ne 'Running') {
        Start-Service $serviceName
    }
    if ($service.StartType -ne 'Automatic') {
        Set-Service $serviceName -StartupType Automatic
    }
}

$programFilesDir = (New-Object -ComObject Shell.Application).NameSpace('shell:ProgramFiles').Self.Path
$installDir = "$programFilesDir\OpenSSH"
if (-not (Test-Path $installDir)) {
    $zipFilename = 'OpenSSH-Win64.zip'
    $downloadsDir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $zipPath = "$downloadsDir\$zipFilename"
    if (-not (Test-Path $zipPath)) {
        $resp = Invoke-WebRequest https://github.com/PowerShell/Win32-OpenSSH/releases/latest -Method HEAD -MaximumRedirection 0 -ErrorAction Ignore
        $latestVersion = $resp.Headers.Location -replace '.*/tag/', ''
        $zipUrl = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/$latestVersion/$zipFilename"

        Write-Output "zipUrl=$zipUrl, zipPath=$zipPath"
        Invoke-WebRequest $zipUrl -OutFile $zipPath
    }

    Expand-Archive $zipPath -DestinationPath $programFilesDir
    Rename-Item "$programFilesDir\OpenSSH-Win64" $installDir
}

if ((Get-Service sshd -ErrorAction SilentlyContinue) -eq $null) {
    & "$installDir\install-sshd.ps1"
}

StartAndEnable-Service sshd
StartAndEnable-Service ssh-agent
