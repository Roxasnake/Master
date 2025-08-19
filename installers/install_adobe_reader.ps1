# Installe Adobe Acrobat Reader DC
$adobeUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820442/AcroRdrDC2300820442_fr_FR.exe"
$installer = "$env:TEMP\adobe_reader.exe"

Invoke-WebRequest -Uri $adobeUrl -OutFile $installer
Start-Process $installer -ArgumentList "/sAll /rs /rps /msi /norestart /quiet" -Wait
Remove-Item $installer -Force
Write-Host "Adobe Reader installé."