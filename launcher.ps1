# Lance tous les scripts d'installation présents dans le dossier "installers"
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installers = Get-ChildItem -Path "$root/installers" -Filter *.ps1

foreach ($script in $installers) {
    Write-Host "Exécution de $($script.Name)..."
    & "$($script.FullName)"
}