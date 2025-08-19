#requires -runasadministrator
<#
.SYNOPSIS
    Installe Microsoft Office avec configuration personnalisée.
.DESCRIPTION
    Installe Office à l'aide du fichier XML situé dans C:\temp\config.xml
    Si le fichier n'existe pas, une configuration par défaut est créée.
    Le script doit être exécuté en tant qu'administrateur.
#>

# Elevation automatique si nécessaire
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$Script:ODT = "$env:temp\ODT"
$Script:Installer = "$env:temp\ODTSetup.exe"
$Script:ConfigFile = "C:\temp\config.xml"

function Get-ODT {
    $webpage = Invoke-RestMethod 'https://www.microsoft.com/en-us/download/details.aspx?id=49117'
    $Script:ODTURL = ($webpage -split "`n") | ForEach-Object {
        if ($_ -match '.*href="(https://download.microsoft.com.*officedeploymenttool.*\.exe)"') { $matches[1] }
    }

    Write-Output "`nTéléchargement de l'Office Deployment Tool (ODT)..."
    Invoke-WebRequest -Uri $Script:ODTURL -OutFile $Script:Installer
    Start-Process -Wait -NoNewWindow -FilePath $Script:Installer -ArgumentList "/extract:$Script:ODT /quiet"
}

function Set-ConfigXML {
    if (Test-Path $Script:ConfigFile) {
        Write-Output "Utilisation du fichier XML existant : $Script:ConfigFile"
        return
    }

    Write-Warning "Fichier XML non trouvé dans C:\temp. Création d'une configuration par défaut..."
    $xmlContent = @'
<Configuration ID="8abbd230-6944-44f9-b401-1560e94005d9">
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021" Version="16.0.14334.20244">
    <Product ID="Standard2021Volume" PIDKEY="CHN27-HJFYQ-YPJWH-T49PR-QGR27">
      <Language ID="fr-fr" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <AppSettings>
    <User Key="software\microsoft\office\16.0\excel\options" Name="defaultformat" Value="60" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" />
    <User Key="software\microsoft\office\16.0\powerpoint\options" Name="defaultformat" Value="52" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" />
    <User Key="software\microsoft\office\16.0\word\options" Name="defaultformat" Value="ODT" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" />
  </AppSettings>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
'@

    if (!(Test-Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory | Out-Null }
    $xmlContent | Out-File -FilePath $Script:ConfigFile -Encoding UTF8
    Write-Output "Fichier XML créé : $Script:ConfigFile"
}

function Install-Office {
    Write-Output "Installation de Microsoft Office en cours..."
    Start-Process -Wait -WindowStyle Hidden -FilePath "$Script:ODT\setup.exe" -ArgumentList "/configure `"$Script:ConfigFile`""
    Write-Output "Installation terminée."
}

function Remove-OfficeHub {
    $AppName = 'Microsoft.MicrosoftOfficeHub'
    Write-Output "`nSuppression de [$AppName] (application Store)..."
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $AppName } | Remove-AppxProvisionedPackage -AllUsers | Out-Null
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -like $AppName } | Remove-AppxPackage -AllUsers
}

# Préparation
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

if ([Net.ServicePointManager]::SecurityProtocol -notcontains 'Tls12') {
    [Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12
}

Get-ODT
Set-ConfigXML
Install-Office
Remove-OfficeHub

