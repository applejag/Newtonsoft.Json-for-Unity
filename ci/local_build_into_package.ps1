#!/usr/bin/env pwsh
using namespace System.IO

# Run this script to build the
# <repo>/Src/Newtonsoft.Json/Newtonsoft.Json.csproj
# into
# <repo>/Src/Newtonsoft.Json-for-Unity/Plugins/*

param (
    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",

    [ValidateSet('Standalone','AOT','Editor','Tests')]
    [string[]] $UnityBuilds = @(
        'AOT', 'Editor'
    ),

    [string] $VolumeSource = ([Path]::GetFullPath("$PSScriptRoot/..")),

    [string] $DockerImage = "applejag/newtonsoft.json-for-unity.package-builder:v3",

    [string] $WorkingDirectory = "/root/repo",

    [string] $RelativeBuildSolution = "Src/Newtonsoft.Json/Newtonsoft.Json.csproj",
    [string] $RelativeBuildDestination = "",
    [string] $RelativeBuildDestinationBase = "Src/Newtonsoft.Json-for-Unity/Plugins/",
    [string[]] $CopyFiles = @('*'),
    [string] $AdditionalConstants = "",
    
    [switch] $UseDefaultAssemblyVersion,
    [switch] $DontUseNuGetPackageCache,
    [switch] $DontUseNuGetHttpCache,
    [switch] $DontSign
)

$ErrorActionPreference = "Stop"

Write-Host ">> Starting $DockerImage" -BackgroundColor DarkRed
$watch = [System.Diagnostics.Stopwatch]::StartNew()

if (-not $DontSign) {
    $AdditionalConstants += ";SIGNING"
}

if ($null -eq $UnityBuilds -or $UnityBuilds.Count -eq 0) {
    throw "At least 1 build must be specified."
}

$BuildDestination = ""

if (-not [string]::IsNullOrEmpty($RelativeBuildDestination)) {
    if ($UnityBuilds.Count -gt 1) {
        throw "Specifying RelativeBuildDestination cannot be used when targeting multiple UnityBuilds."
    } else {
        $BuildDestination = "/root/repo/$RelativeBuildDestination"
    }
}

$dockerVolumes = @(
    "${VolumeSource}:/root/repo"
)

$IsWSL = ($IsLinux -and $Env:WSL_DISTRO_NAME)

if (-not $DontUseNuGetPackageCache) {
    if ($IsWindows) {
        $dockerVolumes += @("$Env:UserProfile/.nuget/packages:/root/.nuget/packages")
    } elseif ($IsWSL) {
        $UserProfile = wslpath $(cmd.exe /C "echo %USERPROFILE%")
        $dockerVolumes += @("$UserProfile/.nuget/packages:/root/.nuget/packages")
    } elseif ($IsLinux) {
        $dockerVolumes += @("$Env:HOME/.nuget/packages:/root/.nuget/packages")
    }
}

if (-not $DontUseNuGetHttpCache) {
    if ($IsWindows) {
        $dockerVolumes += @("$Env:LocalAppData/NuGet/v3-cache:/root/.local/share/NuGet/v3-cache")
    } elseif ($IsWSL) {
        $LocalAppData = wslpath $(cmd.exe /C "echo %LOCALAPPDATA%")
        $dockerVolumes += @("$LocalAppData/NuGet/v3-cache:/root/.local/share/NuGet/v3-cache")
    } elseif ($IsLinux) {
        $dockerVolumes += @("$Env:HOME/.local/share/NuGet/v3-cache:/root/.local/share/NuGet/v3-cache")
    }
}

$dockerVolumesArgs
Write-Host @"
`$container = docker run -dit --rm ``
    $(($dockerVolumes | ForEach-Object {"-v $_ ``"}) -join "`n    ")
    -e SCRIPTS=/root/repo/ci/scripts ``
    -e BUILD_SOLUTION=/root/repo/$RelativeBuildSolution ``
    -e BUILD_DESTINATION_BASE=/root/repo/$RelativeBuildDestinationBase ``
    -e BUILD_DESTINATION=$BuildDestination ``
    -e BUILD_CONFIGURATION=$Configuration ``
    -e BUILD_ADDITIONAL_CONSTANTS=$AdditionalConstants ``
    -e BASH_ENV=/root/.bashrc ``
    $DockerImage
"@ -ForegroundColor DarkGray

$container = docker run -dit `
    -v "${VolumeSource}:/root/repo" `
    -e SCRIPTS=/root/repo/ci/scripts `
    -e BUILD_SOLUTION=/root/repo/$RelativeBuildSolution `
    -e BUILD_DESTINATION_BASE=/root/repo/$RelativeBuildDestinationBase `
    -e BUILD_DESTINATION=$BuildDestination `
    -e BUILD_CONFIGURATION=$Configuration `
    -e BUILD_ADDITIONAL_CONSTANTS=$AdditionalConstants `
    -e BASH_ENV=/root/.bashrc `
    $DockerImage

if ($LASTEXITCODE -ne 0) {
    throw "Failed to create container"
}

function Invoke-DockerCommand ([string] $name, [string] $command) {
    Write-Host ">> $name " -BackgroundColor DarkBlue -ForegroundColor White
    Write-Host $command -ForegroundColor DarkGray
    @"
    set -o nounset
    set -o errexit
    set -o pipefail
    touch `$BASH_ENV
    chmod +x `$BASH_ENV
    `$BASH_ENV

    $command
    echo 
"@ | docker exec -iw $WorkingDirectory $container bash
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to run command '$name'"
    }
    Write-Host ''
}

try {
    Invoke-DockerCommand "Enable permissions on scripts" `
          'chmod +x $SCRIPTS/**.sh -v'

    if ($UseDefaultAssemblyVersion) {
        Invoke-DockerCommand "Setup default variables" @'
            env() {
                echo "export '$1=$2'" >> $BASH_ENV
                echo "$1='$2'"
                export "$1=$2"
            }
            xml() {
                xmlstarlet sel -t -v "/Project/PropertyGroup/$1" -n Src/Newtonsoft.Json/Newtonsoft.Json.csproj | head -n 1
            }
            echo ">>> OBTAINING VERSION FROM $(pwd)/Src/Newtonsoft.Json/Newtonsoft.Json.csproj"
            env VERSION "$(xml VersionPrefix)"
            env VERSION_SUFFIX "$(xml VersionSuffix)"
            env VERSION_JSON_NET "$(xml VersionPrefix)"
            env VERSION_ASSEMBLY "$(xml AssemblyVersion)"
'@
    } else {
        Invoke-DockerCommand "Setup variables" @'
            env() {
                echo "export '$1=$2'" >> $BASH_ENV
                echo "$1='$2'"
                export "$1=$2"
            }
            echo ">>> OBTAINING VERSION FROM $(pwd)/ci/version.json"
            env VERSION "$($SCRIPTS/get_json_version.sh ./ci/version.json FULL)"
            env VERSION_SUFFIX "$($SCRIPTS/get_json_version.sh ./ci/version.json SUFFIX)"
            env VERSION_JSON_NET "$($SCRIPTS/get_json_version.sh ./ci/version.json JSON_NET)"
            env VERSION_ASSEMBLY "$($SCRIPTS/get_json_version.sh ./ci/version.json ASSEMBLY)"
            echo
            
            echo ">>> UPDATING VERSION IN $(pwd)/Src/Newtonsoft.Json-for-Unity/package.json"
            echo "BEFORE:"
            echo ".version=$(jq ".version" Src/Newtonsoft.Json-for-Unity/package.json)"
            echo ".displayName=$(jq ".displayName" Src/Newtonsoft.Json-for-Unity/package.json)"
            echo "$(jq ".version=\"$VERSION\" | .displayName=\"Json.NET $VERSION_JSON_NET for Unity\"" Src/Newtonsoft.Json-for-Unity/package.json)" > Src/Newtonsoft.Json-for-Unity/package.json
            echo "AFTER:"
            echo ".version=$(jq ".version" Src/Newtonsoft.Json-for-Unity/package.json)"
            echo ".displayName=$(jq ".displayName" Src/Newtonsoft.Json-for-Unity/package.json)"
'@
    }

    
    foreach ($build in $UnityBuilds) {
        Invoke-DockerCommand "NuGet restore for build '$build'" `
            "dotnet restore `"`$BUILD_SOLUTION`" -p:UnityBuild=$build"

        Invoke-DockerCommand "Build '$build'" @"
            mkdir -p Temp/Build
            rm -rf Temp/Build/*
            BUILD_DESTINATION="`$(pwd)/Temp/Build" `$SCRIPTS/build.sh $build
            BUILD_DESTINATION=`${BUILD_DESTINATION:-"`${BUILD_DESTINATION_BASE:?"Build output path required."}/Newtonsoft.Json $build"}
            mkdir -vp "`$BUILD_DESTINATION"
            cp -fvrt "`$BUILD_DESTINATION" $(($CopyFiles | ForEach-Object {Join-Path "`$(pwd)/Temp/Build" $_}) -join " ")
"@
    }

    Invoke-DockerCommand 'Fix meta files' `
        '$SCRIPTS/generate_metafiles.sh $BUILD_DESTINATION_BASE'

    Write-Host '>> Done!' -BackgroundColor Black -ForegroundColor DarkGray

} finally {
    $watch.Stop()
    Write-Host ">> Stopping $container" -BackgroundColor DarkGray
    docker kill $container | Out-Null
}

Write-Host ''
Write-Host "Full script completed in: $('{0:#,##}' -f $watch.ElapsedMilliseconds) ms" -ForegroundColor DarkGray
Write-Host ''
