#Requires -RunAsAdministrator

$installDir = "C:\wsl-ssh-agent"
if (-not (Test-Path $installDir)) {
    $zipFilename = 'wsl-ssh-agent.zip'
    $downloadsDir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $zipPath = "$downloadsDir\$zipFilename"
    if (-not (Test-Path $zipPath)) {
        $repoUrl = 'https://github.com/rupor-github/wsl-ssh-agent'
        $resp = Invoke-WebRequest "$repoUrl/releases/latest" -Method HEAD -MaximumRedirection 0 -ErrorAction Ignore
        $latestVersion = $resp.Headers.Location -replace '.*/tag/', ''
        $zipUrl = "$repoUrl/releases/download/$latestVersion/$zipFilename"
        Invoke-WebRequest $zipUrl -OutFile $zipPath
    }
    Expand-Archive $zipPath -DestinationPath $installDir
}
