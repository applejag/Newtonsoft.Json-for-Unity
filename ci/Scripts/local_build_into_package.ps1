
# Run this script to build the
# <repo>/Src/Newtonsoft.Json/Newtonsoft.Json.csproj
# into
# <repo>/Src/Newtonsoft.Json-for-Unity/Plugins/*

param (
    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",

    [string[]] $UnityBuilds = @('AOT', 'Standalone', 'Portable', 'Editor')
)

$ErrorActionPreference = "Stop"

$SetupScript = Resolve-Path "$PSScriptRoot\setup.ps1"
$BuildScript = Resolve-Path "$PSScriptRoot\build.ps1"

$Solution = Resolve-Path "$PSScriptRoot\..\..\Src\Newtonsoft.Json\Newtonsoft.Json.csproj"
$DestinationBase = Resolve-Path "$PSScriptRoot\..\..\Src\Newtonsoft.Json-for-Unity\Plugins"
$TempDirectory = "$(Resolve-Path "$PSScriptRoot\..\..")\Temp"

function GetVersion($versionFile = "$PSScriptRoot\version.json")
{
    $version = Get-Content $versionFile | Out-String | ConvertFrom-Json
    $major = if ($null -ne $version.Major) {$version.Major} else {throw "Missing 'Major' field in version.json"}
    $minor = if ($null -ne $version.Minor) {$version.Minor} else {0}
    $build = if ($null -ne $version.Build) {$version.Build} else {0}

    $now = [DateTime]::Now

    $year = $now.Year - 2000
    $month = $now.Month
    $totalMonthsSince2000 = ($year * 12) + $month
    $day = $now.Day
    $revision = "{0}{1:00}" -f $totalMonthsSince2000, $day

    return [System.Version]::new($major, $minor, $build, $revision)
}

$Version = GetVersion

function Clean($Folder) {
    Write-Host ">> Cleaning up '$Folder'"
    Remove-Item "$Folder\*.dll" -Force -Verbose
    Remove-Item "$Folder\*.pdb" -Force -Verbose
    Remove-Item "$Folder\*.mdb" -Force -Verbose
    Remove-Item "$Folder\*.xml" -Force -Verbose
}

function Build($UnityBuild) {
    $Destination = Join-Path $DestinationBase "Newtonsoft.Json $UnityBuild"

    if (Test-Path $Destination) {
        Clean($Destination)
    }

    $params = @{
        Solution = [string]$Solution
        Destination = [string]$Destination
        TempDirectory = $TempDirectory
        UnityBuild = $UnityBuild
        Configuration = $Configuration
        Version = $Version
    }
    & $BuildScript @params
}

& $SetupScript -TempDirectory $TempDirectory
Build "AOT"
Build "Standalone"
Build "Portable"
Build "Editor"
