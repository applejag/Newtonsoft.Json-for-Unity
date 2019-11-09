
# Run this script to build the
# <repo>/Src/Newtonsoft.Json/Newtonsoft.Json.csproj
# into
# <repo>/Src/Newtonsoft.Json-for-Unity/Plugins/*

param (
    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",

    [string[]] $UnityBuilds = @(
        ,'AOT'
        ## Removed 'Standalone' due to issue #3
        ## https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/3
        #,'Standalone'
        ,'Portable'
        ,'Editor'
    )
)

$ErrorActionPreference = "Stop"

$SetupScript = Resolve-Path "$PSScriptRoot\setup.ps1"
$BuildScript = Resolve-Path "$PSScriptRoot\build.ps1"

$Solution = Resolve-Path "$PSScriptRoot\..\Src\Newtonsoft.Json\Newtonsoft.Json.csproj"
$Package = Resolve-Path "$PSScriptRoot\..\Src\Newtonsoft.Json-for-Unity"
$DestinationBase = Resolve-Path "$Package\Plugins"
$TempDirectory = "$(Resolve-Path "$PSScriptRoot\..")\Temp"

function Get-Version($versionFile = "$PSScriptRoot\version.json")
{
    $version = Get-Content $versionFile | Out-String | ConvertFrom-Json

    $now = [DateTime]::Now

    $year = $now.Year - 2000
    $month = $now.Month
    $totalMonthsSince2000 = ($year * 12) + $month
    $day = $now.Day
    $revision = "{0}{1:00}" -f $totalMonthsSince2000, $day

    return @{
        Major = if ($null -ne $version.Major) {$version.Major} else {throw "Missing 'Major' field in version.json"};
        Minor = if ($null -ne $version.Minor) {$version.Minor} else {0};
        Build = if ($null -ne $version.Build) {$version.Build} else {0};
        Revision = $revision;
        Suffix = $version.Suffix
    }
}

function ConvertTo-Version($obj) {
    if ($obj.Revision -ge 0) {
        return [System.Version]::new($obj.Major, $obj.Minor, $obj.Build, $obj.Revision)
    } else {
        return [System.Version]::new($obj.Major, $obj.Minor, $obj.Build)
    }
}

$VersionJson = Get-Version
$Version = ConvertTo-Version $VersionJson
$VersionPrefix = $Version.ToString(3)
$VersionSuffix = $VersionJson.Suffix
$VersionFull = if ($VersionSuffix) {"$VersionPrefix-$VersionSuffix"} else {$VersionPrefix}

function UpdatePackageJson($packageJson = "$Package\package.json") {
    $package = Get-Content $packageJson | Out-String | ConvertFrom-Json

    $package.version = $VersionFull

    ConvertTo-Json $package -Compress | PrettifyJson | Set-Content $packageJson
}

function PrettifyJson(
    [Parameter(ValueFromPipeline)][string] $json)
{
    $jsonDll = Resolve-Path "$DestinationBase\Newtonsoft.Json Portable\Newtonsoft.Json.dll"
    Write-Host "Using Newtonsoft.Json to prettify .json via '$jsonDll'" -ForegroundColor Gray
    $jsonBin = ""
    if ($IsWindows) {
        $jsonBin = Get-Content $jsonDll -Encoding Byte -Raw
    } else {
        $jsonBin = [System.IO.File]::ReadAllBytes($jsonDll)
    }
    [System.Reflection.Assembly]::Load($jsonBin) | Out-Null
    [Newtonsoft.Json.Linq.JToken]::Parse($json).ToString()
}

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
        VersionSuffix = $VersionSuffix
    }
    & $BuildScript @params
}

function PromptYN ([String] $Prompt) {
    $confirmation = $null
    while ($true)
    {
        $confirmation = Read-Host "$Prompt [y/n]"
        if ($null -eq $confirmation)
        {
            continue
        }
        $confirmation = $confirmation.Substring(0,1).ToLowerInvariant()
        if ($confirmation -eq 'y') {
            return $true
        }
        elseif ($confirmation -eq 'n') {
            return $false
        }
        else {
            Write-Host "Only [Y]es or [N]o are valid responses." -ForegroundColor DarkYellow
        }
    }
}

$builds = ($UnityBuilds | % {"'$_'"}) -join ', '
Write-Host "Building for " -NoNewline
Write-Host $builds -ForegroundColor Cyan
Write-Host "Into folder " -NoNewline
Write-Host $DestinationBase -ForegroundColor Cyan

if (-not (PromptYN "Ready?")) {
    Write-Host "Aborting." -ForegroundColor DarkYellow
    exit
}

& $SetupScript -TempDirectory $TempDirectory

foreach ($build in $UnityBuilds) {
    Build $build
}

UpdatePackageJson
