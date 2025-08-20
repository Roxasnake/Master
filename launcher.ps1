 =============================
# 2️⃣ Partie Installation des scripts PS1
# =============================

# Cette partie doit être exécutée **après le redémarrage**.
# Vous pouvez créer un script séparé ou utiliser une tâche planifiée pour l'exécuter après le reboot.

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
