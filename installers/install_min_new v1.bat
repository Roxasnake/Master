@echo off
setlocal enabledelayedexpansion

REM --- Activer la restauration système ---
powershell -Command "Enable-ComputerRestore -Drive 'C:\'"
powershell -Command "vssadmin Resize ShadowStorage /For=C: /On=C: /MaxSize=10%%"

REM --- Récupérer le nom de la machine ---
for /f "tokens=* delims= " %%a in ('hostname') do set hostname=%%a
echo [INFO] Nom de la machine detecte : !hostname!

REM --- Détection du type de poste ---
if not "!hostname!"=="!hostname:LAP=!" (
    echo [INFO] PC Portable detecte → installation automatique.
    call :installer_pc_portable
    goto :fin
) 

if not "!hostname!"=="!hostname:DEK=!" (
    echo [INFO] PC Fixe detecte → demande installation Office.
    call :installer_pc_fixe
    goto :fin
) 

echo [ERREUR] Nom de machine non reconnu. Utilisez le prefixe LAP ou DEK.
goto :fin

:installer_pc_portable
echo [INSTALL] Installation automatique pour PC portable...

REM --- Installation FortiClient ---
if not exist "%SystemDrive%\ForticlientInstalled.txt" (
    echo Installation de FortiClient...
    "C:\Users\Public\Documents\Application_MSI\FortiClientVPN.exe" /quiet /norestart
    regedit /s "C:\Users\Public\Documents\Application_MSI\forti_VPN.reg"
    echo Installation de FortiClient terminee. > "%SystemDrive%\ForticlientInstalled.txt"
)

REM --- Installation Microsoft Office ---
echo Installation de Microsoft Office...
call "C:\Users\Public\Documents\Logiciels\Run_Install_Office.cmd"

REM --- Désactiver l'accélération graphique Office ---
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Graphics" /v DisableHardwareAcceleration /t REG_DWORD /d 1 /f

REM --- Installation / désactivation de périphériques supplémentaires ---
call :installer_application_supplementaire_portable

goto :fin

:installer_pc_fixe
REM --- Popup pour installation Office ---
for /f "tokens=*" %%i in ('powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::MsgBox('Installer Office ?', 'YesNo,Information', 'Installation') "') do set choix=%%i

if /i "!choix!"=="Yes" (
    echo [INSTALL] Installation de Microsoft Office...
    call "C:\Users\Public\Documents\Logiciels\Run_Install_Office.cmd"
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Graphics" /v DisableHardwareAcceleration /t REG_DWORD /d 1 /f
) else (
    echo [INFO] Installation Office ignoree.
)

goto :fin

:installer_application_supplementaire_portable
REM --- Exemple de désactivation de périphérique ---
pnputil /disable-device "INTELAUDIO\CTLR_DEV_A0C8&LINKTYPE_06&DEVTYPE_06&VEN_8086&DEV_AE50&SUBSYS_0A211028&REV_0001\0601"
goto :eof

:fin
echo --- Fin du script ---
exit /b
