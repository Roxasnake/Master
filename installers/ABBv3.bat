@echo off
setlocal enabledelayedexpansion

for /f "tokens=* delims= " %%a in ('hostname') do (
    set hostname=%%a
)

if "!hostname:NOR=!" neq "!hostname!" (
    set "lieu=1"
) else if "!hostname:ATL=!" neq "!hostname!" (
    set "lieu=2"
) else if "!hostname:LOR=!" neq "!hostname!" (
    set "lieu=3"
) else if "!hostname:EST=!" neq "!hostname!" (
    set "lieu=4"
) else if "!hostname:IDF=!" neq "!hostname!" (
    set "lieu=5"
) else if "!hostname:DEV=!" neq "!hostname!" (
    set "lieu=6"
) else if "!hostname:HQ=!" neq "!hostname!" (
    set "lieu=7"
) else if "!hostname:ALE=!" neq "!hostname!" (
    set "lieu=8"
) else (
    echo Lieu invalide.
    exit /b 1
)

REM Vous pouvez maintenant utiliser la variable "lieu" pour effectuer des actions en fonction du lieu.
echo Vous avez choisi le lieu !lieu!.

REM Chemin vers le fichier MSI
set "msiPath=C:\Users\Public\Documents\Logiciels\ABB\ABBx64.msi"

REM Lecture des données à partir du fichier "ABB.txt"
for /f "tokens=1,2,3 delims=," %%a in (C:\Users\Public\Documents\Logiciels\ABB\ABB.txt) do (
    if "%%a"=="!lieu!" (
        set "USERNAME=%%b"
        set "ADDRESS=%%c"
        goto Found
    )
)

:Found

REM Vérifiez si les valeurs ont été trouvées pour le lieu choisi
if not defined USERNAME (
    echo Lieu invalide ou données introuvables.
    exit /b 1
)

REM Utilisez msiexec pour configurer les propriétés USERNAME et ADDRESS
msiexec /i "%msiPath%" USERNAME="%USERNAME%" ADDRESS="%ADDRESS%" /qn

exit /b
