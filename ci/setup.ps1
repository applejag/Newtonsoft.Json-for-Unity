
param (
    [System.IO.FileInfo] $TempDirectory = $(Join-Path "." "Temp"),

    # Properties
    [string] $NuGetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
)

$ErrorActionPreference = "Stop"

New-Item $TempDirectory -ItemType Directory -Force | Out-Null
$TempFull = Resolve-Path $TempDirectory

$dotnet = if ($IsWindows) { "dotnet" } else { "~/.dotnet/dotnet" }

$nugetPath = Join-Path $TempFull "nuget.exe"
$nugetConfig = Resolve-Path $(Join-Path "." "nuget.config") -ErrorAction SilentlyContinue
if (-Not $nugetConfig) {
    $nugetConfig = Resolve-Path $(Join-Path $PSScriptRoot "nuget.config") -ErrorAction SilentlyContinue
}

$packages = @(
    , @{
        Name = "vswhere"
        Version = "2.3.2"
    }
    , @{
        Name = "Mono.Unofficial.pdb2mdb"
        Version = "4.2.3.4"
    }
)

$netCliChannel = "2.0"
$netCliVersion = "2.2.105"

function EnsureDotNetCli()
{
    if (Get-Command $dotnet -errorAction SilentlyContinue)
    {
        Write-Host "dotnet already installed" -ForegroundColor Green
        return
    }
    
    if ($IsWindows) {
        Write-Host "Downloading dotnet-install.ps1"
        
        # https://stackoverflow.com/questions/36265534/invoke-webrequest-ssl-fails
        [Net.ServicePointManager]::SecurityProtocol = 'TLS12'
        Invoke-WebRequest `
            -Uri "https://dot.net/v1/dotnet-install.ps1" `
            -OutFile $(Join-Path $TempFull "dotnet-install.ps1")
        
        & (Join-Path $TempFull "dotnet-install.ps1") -Channel $netCliChannel -Version $netCliVersion | Out-Default
    }
    else
    {
        Write-Host "Downloading dotnet-install.sh"
        
        Invoke-WebRequest `
            -Uri "https://dot.net/v1/dotnet-install.sh" `
            -OutFile $(Join-Path $TempFull "dotnet-install.sh")

        bash $(Join-Path $TempFull "dotnet-install.sh")
    }
}

function EnsureNuGetExists()
{
    if (!(Test-Path $nugetPath)) {
        Write-Host "Couldn't find nuget.exe. Downloading from $NuGetUrl to $nugetPath"
        Invoke-WebRequest -Uri $NuGetUrl -OutFile $nugetPath
        Write-Host "Installed nuget.exe at '$nugetPath'" -ForegroundColor Green
    } else {
        Write-Host "nuget.exe already installed at '$nugetPath'" -ForegroundColor Green
    }
}

function EnsureMonoExists()
{
    if (!$IsWindows) {
        if (!(Get-Command "mono" -ErrorAction SilentlyContinue)) {
            Write-Host "Couldn't find mono. Downloading from apt-get"
            apt-get update
            apt-get install --no-install-recommends -qq mono-devel
            Write-Host "Installed mono" -ForegroundColor Green
        } else {
            Write-Host "mono already installed" -ForegroundColor Green
        }
    }
}

function nuget([Parameter(ValueFromRemainingArguments = $true)] $Passthrough)
{
    if ($IsWindows) {
        & $nugetPath $Passthrough
    } else {
        mono $nugetPath $Passthrough
    }
}

function EnsureNuGetPackage($packageName, $packageVersion)
{
    $packagePath = Join-Path $TempFull "$($packageName).$packageVersion"
    if (!(Test-Path $packagePath))
    {
        Write-Host "Couldn't find $packagePath. Downloading with NuGet"
        if ($nugetConfig) {
            nuget install $packageName -OutputDirectory $TempFull -Version $packageVersion -ConfigFile $nugetConfig | Out-Default
        } else {
            nuget install $packageName -OutputDirectory $TempFull -Version $packageVersion | Out-Default
        }
        Write-Host "Installed $packageName ($packageVersion) installed at '$packagePath'" -ForegroundColor Green
    } else {
        Write-Host "Package $packageName ($packageVersion) already installed at '$packagePath'" -ForegroundColor Green
    }
}

EnsureDotNetCli
EnsureNuGetExists
EnsureMonoExists

foreach ($package in $packages) {
    EnsureNuGetPackage $package.Name $package.Version
}
