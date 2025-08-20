# Lancer tous les scripts PowerShell (.ps1) et Batch (.bat) présents dans le dossier 'installers' du dépôt public Roxasnake/Master

$apiUrl = "https://api.github.com/repos/Roxasnake/Master/contents/installers?ref=main"

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "Mozilla/5.0" }
    $scripts = $response | Where-Object { $_.name -match "\.(ps1|bat)$" }
} catch {
    Write-Host "Impossible de récupérer la liste des scripts via l’API GitHub"
    exit 1
}

foreach ($file in $scripts) {
    $url = $file.download_url
    Write-Host "`n--- Exécution de $($file.name) ---"
    try {
        if ($file.name -like "*.ps1") {
            Invoke-Expression (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        } elseif ($file.name -like "*.bat") {
            $tempPath = Join-Path $env:TEMP $file.name
            Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing
            Start-Process -FilePath $tempPath -Wait
            Remove-Item $tempPath -Force
        }
    } catch {
        Write-Host "Erreur lors de l'exécution de $($file.name)"
    }
}
