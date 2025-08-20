# =============================
# Téléchargement et installation de la dernière version de 7-Zip (64 bits) via MSI depuis GitHub (ip7z/7zip)
# =============================

# Récupération de la dernière release sur le dépôt officiel
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ip7z/7zip/releases/latest" -Headers @{ "User-Agent" = "Mozilla/5.0" }

# Recherche du MSI 64 bits
$msiAsset = $latestRelease.assets | Where-Object { $_.name -match "x64\.msi$" } | Select-Object -First 1
if (-not $msiAsset) {
    Write-Host "❌ Impossible de trouver le MSI 64 bits."
    exit 1
}

$installerUrl = $msiAsset.browser_download_url
$installerPath = "$env:TEMP\7zip.msi"

Write-Host "⬇️ Téléchargement de 7-Zip depuis $installerUrl ..."
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

Write-Host "⚙️ Installation de 7-Zip..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait

Remove-Item $installerPath -Force
Write-Host "✅ 7-Zip installé."
