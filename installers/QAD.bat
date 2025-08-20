@echo off
setlocal enabledelayedexpansion

set "hostname=%COMPUTERNAME%"
echo Nom du poste : %hostname%

:: Vérifie si le nom contient "ALE"
echo %hostname% | find /I "ALE" >nul
if not errorlevel 1 (
    echo.
    echo Le nom du poste contient "ALE" : aucune action effectuée.
    goto fin
)

echo.
echo ================================
echo   INSTALLATION DE QAD EN COURS
echo ================================
msiexec /i "C:\Users\Public\Documents\Application_MSI\ed7e8apq43m6nupcodc4s47gad3rgawgq35esafcrumgszip4bqed4cgxjhng1bpxm5kg.msi" /qn /norestart

echo.
echo Attente de l'installation complète de QAD...

:: Boucle d'attente (on vérifie toutes les 10 secondes si le .exe existe)
set "QADExePath=C:\Program Files (x86)\QAD\QAD CLOUD\QAD.Applications.exe"
:waitLoop
if exist "!QADExePath!" (
    echo QAD est maintenant installé.
) else (
    echo QAD pas encore installé... nouvelle vérification dans 10 secondes.
    timeout /t 10 >nul
    goto waitLoop
)

echo.
echo ================================
echo   LANCEMENT DE LA MISE A JOUR
echo ================================
start "" "!QADExePath!"

:fin
echo.
echo ================================
echo   SCRIPT TERMINE
echo ================================
timeout /t 65 >nul
taskkill /IM QAD.client.exe /F