@echo off
setlocal enabledelayedexpansion

for /f "tokens=* delims= " %%a in ('hostname') do (
    set computerName=%%a
)

set "found=0"

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

if !found! equ 0 (
    echo Option invalide.
    exit /b 1
)
echo 
REM Vous pouvez maintenant utiliser la variable "choix" pour effectuer des actions en fonction de l'option.
echo Vous avez choisi l'option %choix%.

REM Installe Sentinel One avec le token approprié en fonction de l'option choisie
set "cle="
if "%choix%"=="1" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"NOR" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="2" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"LOR" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="3" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"ATL" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="4" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"EST" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="5" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"IDF" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="6" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"DEV" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="7" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"HQ" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else if "%choix%"=="8" (
  for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"ALE" "C:\Users\Public\Documents\application_msi\token\token\Decrypt_token.txt"') do (
    set "cle=%%i"
  )
) else (
  echo Option invalide.
  exit /b 1
)

msiexec /i "C:\Users\Public\Documents\application_msi\S1.msi" SITE_TOKEN=%cle% /QUIET /norestart

exit /b
