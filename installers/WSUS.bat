@echo off
setlocal enabledelayedexpansion

:: Déterminer le nom de l'ordinateur
for /f "tokens=* delims= " %%a in ('hostname') do (
    set computerName=%%a
)

set "found=0"

:: Déterminer le choix basé sur le nom de l'ordinateur
if "!computerName:NOR=!" neq "!computerName!" (
    set "choix=1"
    set "found=1"
) 
if "!computerName:LOR=!" neq "!computerName!" (
    set "choix=2"
    set "found=1"
) 
if "!computerName:ATL=!" neq "!computerName!" (
    set "choix=3"
    set "found=1"
) 
if "!computerName:EST=!" neq "!computerName!" (
    set "choix=4"
    set "found=1"
) 
if "!computerName:IDF=!" neq "!computerName!" (
    set "choix=5"
    set "found=1"
) 
if "!computerName:DEV=!" neq "!computerName!" (
    set "choix=6"
    set "found=1"
) 
if "!computerName:HQ=!" neq "!computerName!" (
    set "choix=7"
    set "found=1"
) 
if "!computerName:ALE=!" neq "!computerName!" (
    set "choix=8"
    set "found=1"
) 

:: Si aucun choix n'a été trouvé, afficher un message d'erreur et quitter
if !found! equ 0 (
    echo Option invalide.
    exit /b 1
)

:: Déterminer l'URL du serveur WSUS basé sur le choix
set "wsusUrl="
if !choix! equ 1 (set "wsusUrl=http://10.155.0.100:8530")
if !choix! equ 2 (set "wsusUrl=http://10.88.0.100:8530")
if !choix! equ 3 (set "wsusUrl=http://10.36.0.100:8530")
if !choix! equ 4 (set "wsusUrl=http://10.67.0.100:8530")
if !choix! equ 5 (set "wsusUrl=http://10.102.0.100:8530")
if !choix! equ 7 (set "wsusUrl=http://10.155.0.100:8530")
if !choix! equ 8 (set "wsusUrl=http://10.155.0.100:8530")

echo Vous avez choisi l'option %choix% avec le serveur WSUS %wsusUrl%.

:: Configuration des clés de registre pour WSUS
set "key1=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
set "key2=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

reg query "%key1%" >nul 2>&1
if %errorlevel% neq 0 (
    reg add "%key1%" /v "WUServer" /t REG_SZ /d "%wsusUrl%" /f
    reg add "%key1%" /v "WUStatusServer" /t REG_SZ /d "%wsusUrl%" /f
    reg add "%key1%" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "%wsusUrl%" /f
)

reg query "%key2%" >nul 2>&1
if %errorlevel% neq 0 (
    reg add "%key2%" /v "UseWUServer" /t REG_DWORD /d 1 /f
    reg add "%key2%" /v "DetectionFrequencyEnabled" /t REG_DWORD /d 1 /f
    reg add "%key2%" /v "DetectionFrequency" /t REG_DWORD /d 16 /f
)

echo Les cles de registre ont ete configurees avec succes.

:: Redémarrer le service Windows Update
echo Redemarrage du service Windows Update...
net stop wuauserv
net start wuauserv

:: Supprimer l'ancienne configuration du client WSUS
echo Suppression de l'ancienne configuration du client WSUS...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientIdValidation /f

:: Redémarrer le service Windows Update à nouveau
echo Redemarrage du service Windows Update...
net stop wuauserv
net start wuauserv

:: Forcer la détection des mises à jour et le rapport au serveur WSUS
echo Lancement de la detection des mises a jour...
wuauclt /resetauthorization /detectnow

echo Lancement du rapport au serveur WSUS...
wuauclt /reportnow

echo Mise a jour et rapport forces.

endlocal
