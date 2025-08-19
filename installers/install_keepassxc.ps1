# Installe la dernière version de KeePassXC (Windows 64 bits)
$releases = Invoke-RestMethod -Uri "https://api.github.com/repos/keepassxreboot/keepassxc/releases/latest"
$asset = $releases.assets | Where-Object { $_.name -like "*Win64.msi" } | Select-Object -First 1
$installer = "$env:TEMP\keepassxc.msi"

Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$installer`" /qn /norestart"
Remove-Item $installer -Force
Write-Host "KeePassXC installé."