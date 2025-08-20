# =============================
# Téléchargement et installation de Microsoft Teams
# =============================

$teamsUrl = "https://aka.ms/TeamsWin64"
$installer = "$env:TEMP\Teams_windows_x64.exe"

Write-Host "Téléchargement de la dernière version de Teams..."
Invoke-WebRequest -Uri $teamsUrl -OutFile $installer

Write-Host "Installation de Teams..."
Start-Process -FilePath $installer -ArgumentList "/quiet" -Wait

Remove-Item $installer -Force
Write-Host "Microsoft Teams installé."
