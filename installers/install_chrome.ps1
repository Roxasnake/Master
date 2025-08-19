# Installe la dernière version de Google Chrome Entreprise (MSI)
$chromeUrl = "https://dl.google.com/dl/edgedl/chrome/install/googlechromestandaloneenterprise64.msi"
$chromeInstaller = "$env:TEMP\chrome_enterprise.msi"

Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$chromeInstaller`" /qn /norestart"
Remove-Item $chromeInstaller -Force
Write-Host "Chrome Entreprise installé."