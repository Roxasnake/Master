# Lancer tous les scripts PowerShell (.ps1) présents dans le dossier 'installers' du dépôt public Roxasnake/Master

$repo = "Roxasnake/Master"
$branch = "main"
$folder = "installers"

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
