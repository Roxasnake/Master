# Paramètres du repo
$repo = "Roxasnake/Master"
$branch = "main"
$folder = "installers"

# Récupère la liste des scripts dans le dossier "installers" via l'API GitHub
$apiUrl = "https://api.github.com/repos/$repo/contents/$folder?ref=$branch"
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
