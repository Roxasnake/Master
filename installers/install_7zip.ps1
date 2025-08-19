# Installe la dernière version de 7-Zip (version 64 bits)
$7zipPage = Invoke-WebRequest -Uri "https://www.7-zip.org/download.html"
$7zipUrl = ($7zipPage.Links | Where-Object { $_.href -match "7z.*-x64\.exe" })[0].href
if ($7zipUrl -notmatch "^http") { $7zipUrl = "https://www.7-zip.org/$7zipUrl" }
$installer = "$env:TEMP\7zip.exe"

Invoke-WebRequest -Uri $7zipUrl -OutFile $installer
Start-Process $installer -ArgumentList "/S" -Wait
Remove-Item $installer -Force
Write-Host "7-Zip installé."