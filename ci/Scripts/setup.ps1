
param (
    [System.IO.FileInfo] $TempDirectory = ".\Temp",

    # Properties
    [string] $NuGetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
)

$ErrorActionPreference = "Stop"

New-Item $TempDirectory -ItemType Directory -Force | Out-Null
$TempFull = Resolve-Path $TempDirectory

$nugetPath = "$TempFull\nuget.exe"
$nugetConfig = Resolve-Path ".\nuget.config" -ErrorAction SilentlyContinue
if (-Not $nugetConfig) {
    $nugetConfig = Resolve-Path "$PSScriptRoot\nuget.config" -ErrorAction SilentlyContinue
}

$vswhereVersion = "2.3.2"
$vswherePath = Join-Path $TempFull "vswhere.$vswhereVersion"

$netCliChannel = "2.0"
$netCliVersion = "2.2.105"

function EnsureDotNetCli()
{
  Write-Host "Downloading dotnet-install.ps1"

  # https://stackoverflow.com/questions/36265534/invoke-webrequest-ssl-fails
  [Net.ServicePointManager]::SecurityProtocol = 'TLS12'
  Invoke-WebRequest `
    -Uri "https://dot.net/v1/dotnet-install.ps1" `
    -OutFile "$TempFull\dotnet-install.ps1"

  & $TempFull\dotnet-install.ps1 -Channel $netCliChannel -Version $netCliVersion | Out-Default
}

function EnsureNuGetExists()
{
  if (!(Test-Path $nugetPath))
  {
    Write-Host "Couldn't find nuget.exe. Downloading from $NuGetUrl to $nugetPath"
    (New-Object System.Net.WebClient).DownloadFile($NuGetUrl, $nugetPath)
  }
}

function EnsureNuGetPackage($packageName, $packagePath, $packageVersion)
{
  if (!(Test-Path $packagePath))
  {
    Write-Host "Couldn't find $packagePath. Downloading with NuGet"
    if ($nugetConfig) {
        & $nugetPath install $packageName -OutputDirectory $TempFull -Version $packageVersion -ConfigFile $nugetConfig | Out-Default
    } else {
        & $nugetPath install $packageName -OutputDirectory $TempFull -Version $packageVersion | Out-Default
    }
  }
}

EnsureDotNetCli
EnsureNuGetExists
EnsureNuGetPackage "vswhere" $vswherePath $vswhereVersion