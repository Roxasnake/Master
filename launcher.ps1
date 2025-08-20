# =============================
# 1️⃣ Détection du type de machine
# =============================
$cs = Get-CimInstance Win32_ComputerSystem
if ($cs.PCSystemType -eq 2) {
    $machineType = "portable"
} elseif ($cs.PCSystemType -eq 1) {
    $machineType = "fixe"
} else {
    Write-Host "Type de machine inconnu. Par défaut : fixe"
    $machineType = "fixe"
}

Write-Host "Type de machine détecté : $machineType"

# =============================
# 2️⃣ Renommage de la machine
# =============================
$hostnamesUrl = "https://raw.githubusercontent.com/Roxasnake/Master/main/hostname.txt"

try {
    $hostnames = Invoke-WebRequest -Uri $hostnamesUrl -UseBasicParsing | Select-Object -ExpandProperty Content
    $hostnames = $hostnames -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
} catch {
    Write-Host "Impossible de récupérer la liste des hostnames."
    exit 1
}

# Détecter le hostname selon le type
if ($machineType -eq "portable") {
    $hostname = $hostnames | Where-Object { $_ -match "PLAPA" } | Select-Object -First 1
} else {
    $hostname = $hostnames | Where-Object { $_ -match "PDEKA" } | Select-Object -First 1
}

if (-not $hostname) {
    Write-Host "Aucun hostname disponible pour le type $machineType."
    exit 1
}

# Renommer la machine
Rename-Computer -NewName $hostname -Force
Write-Host "Machine renommée en $hostname (pas de redémarrage)."

# =============================
# 3️⃣ Exécution des scripts PS1
# =============================
$apiUrl = "https://api.github.com/repos/Roxasnake/Master/contents/installers?ref=main"

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "Mozilla/5.0" }
    $ps1files = $response | Where-Object { $_.name -like "*.ps1" }
} catch {
    Write-Host "Impossible de récupérer la liste des scripts via l’API GitHub"
    exit 1
}

foreach ($file in $ps1files) {
    $url = $file.download_url
    Write-Host "`n--- Exécution de $($file.name) ---"
    try {
        Invoke-Expression (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
    } catch {
        Write-Host "Erreur lors de l'exécution de $($file.name)"
    }
}
