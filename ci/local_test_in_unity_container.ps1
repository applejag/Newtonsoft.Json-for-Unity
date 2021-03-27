#!/usr/bin/env pwsh

# Run this script to test all Newtonsoft.Json.Tests
# using Unity Test Runner

# THIS SCRIPT IS MEANT TO BE USED FOR DEVELOPMENT PURPOSES
# DO NOT USE IN PRODUCTION

param(
    # Unity license.ulf
    [string]
    $UnityLicenseOverride,

    [string]
    $VolumeSource = "/c/Projekt/Newtonsoft.Json-for-Unity",

    [string]
    $DockerImage = "applejag/newtonsoft.json-for-unity.package-unity-tester",

    [ValidateSet("2018.4.14f1", "2019.2.11f1", "2020.1.0b6-linux-il2cpp")]
    [string]
    $UnityVersion = "2019.2.11f1",

    [int]
    [ValidateRange(1, [int]::MaxValue)]
    $DockerImageVersion = 1,

    [string]
    $DockerImageOverride,

    [string]
    $WorkingDirectory = "/root/repo",

    [switch]
    $SkipPackageRebuild
)

$ErrorActionPreference = "Stop"

if (-not [string]::IsNullOrEmpty($DockerImageOverride)) {
    $DockerImage = $DockerImageOverride
} elseif ($DockerImage.IndexOf(':') -eq -1) {
    $DockerImage = "${DockerImage}:v$DockerImageVersion-$UnityVersion"
}

$UnityLicenseULF = if (-not [string]::IsNullOrEmpty($UnityLicenseOverride)) {
    Resolve-Path $UnityLicenseOverride
} else {
    Resolve-Path (Join-Path "$PSScriptRoot" "Unity_v$UnityVersion.ulf")
}

Write-Output "Using Unity license $UnityLicenseULF"
Write-Output "Using Docker image $DockerImage"
Write-Output "Using Unity license $UnityVersion"
Write-Output "Using volume $VolumeSource at /root/repo"

$UnityLicenseContent = Get-Content -Path $UnityLicenseULF -Raw
$UnityLicenseBytes = [System.Text.Encoding]::UTF8.GetBytes($UnityLicenseContent)
$UnityLicenseB64 = [Convert]::ToBase64String($UnityLicenseBytes)

if (-not $SkipPackageRebuild) {
    &$PSScriptRoot\local_build_into_test_project.ps1 `
        -UnityBuild Tests
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to complete debug build"
    }
}

Write-Host ">> Starting $DockerImage" -BackgroundColor DarkRed
$watch = [System.Diagnostics.Stopwatch]::StartNew()

$container = docker run -dit --rm `
    -v "${VolumeSource}:/root/repo" `
    -e SCRIPTS=/root/repo/ci/scripts `
    -e PACKAGE_FOLDER=/root/repo/Src/Newtonsoft.Json-for-Unity `
    -e TEST_PROJECT=/root/repo/Src/Newtonsoft.Json-for-Unity.Tests `
    -e PLATFORMS=playmode `
    -e UNITY_LICENSE_CONTENT_B64=$UnityLicenseB64 `
    -e BASH_ENV=/.bash_env `
    $DockerImage

if ($LASTEXITCODE -ne 0) {
    throw "Failed to create container"
}

function Invoke-DockerCommand ([string] $name, [string] $command) {
    Write-Host ">> $name " -BackgroundColor DarkCyan -ForegroundColor White
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
    $exitCode = $LASTEXITCODE
    Write-Host "Received exit code $exitCode from command '$name'" -ForegroundColor DarkGray
    if ($exitCode -ne 0) {
        throw "Failed to run command '$name', received exit code $exitCode"
    }
    Write-Host ''
}

try {
    Invoke-DockerCommand "Enable permissions on scripts" `
          'chmod +x $SCRIPTS/**.sh -v'

    if ($UnityVersion.StartsWith("2018.")) {
        # Unity will regenerate the removed files
        Invoke-DockerCommand "Downgrade Unity project to 2018.x" @'
            echo "Removing $TEST_PROJECT/Library folder"
            rm -rf "$TEST_PROJECT/Library"
            echo "Removing $TEST_PROJECT/Temp folder"
            rm -rf "$TEST_PROJECT/Temp"
            echo "Moving $TEST_PROJECT/Packages/manifest.json file"
            mv -v "$TEST_PROJECT/Packages/manifest.json" "$TEST_PROJECT/Packages/.manifest.json.old"
            echo
            find "$TEST_PROJECT/Assets" -name '.*.asmdef.old' -exec rm -v {} +
            echo
            find "$TEST_PROJECT/Assets" -name '*.asmdef' -exec $SCRIPTS/unity_downgrade_asmdef.sh --backup "{}" \;
'@
    }

    Invoke-DockerCommand "Setup Unity license" `
        '$SCRIPTS/unity_login.sh'

    Invoke-DockerCommand "Copy Newtonsoft.Json.Tests into Unity testing project" @'
        rm -rfv Src/Newtonsoft.Json.Tests/obj
        rm -rfv Src/Newtonsoft.Json.Tests/bin
        rm -rfv "$TEST_PROJECT/Assets/Newtonsoft.Json.Tests/obj"
        rm -rfv "$TEST_PROJECT/Assets/Newtonsoft.Json.Tests/bin"
        cp -vur Src/Newtonsoft.Json.Tests/. "$TEST_PROJECT/Assets/Newtonsoft.Json.Tests/"
        cp -v Src/IdentityPublicKey.snk "$TEST_PROJECT/Assets/"
'@

    Invoke-DockerCommand "Run tests" `
        '$SCRIPTS/unity_test.sh $TEST_PROJECT ~/repo/tests/nunit'

    Write-Host '>> Done!' -BackgroundColor DarkGreen -ForegroundColor White

} finally {
    Invoke-DockerCommand "Convert NUnit to JUnit xml" `
        '$SCRIPTS/nunit2junit.sh ~/repo/tests/nunit ~/repo/tests/junit/'
    
    if ($UnityVersion.StartsWith("2018.")) {
        # Unity will regenerate the removed files
        Invoke-DockerCommand "Revert downgrade Unity project from 2018.x" @'
            echo "Moving $TEST_PROJECT/Packages/manifest.json.old file"
            mv -vf "$TEST_PROJECT/Packages/.manifest.json.old" "$TEST_PROJECT/Packages/manifest.json"
            find "$TEST_PROJECT/Assets" -name '*.asmdef' -exec $SCRIPTS/unity_downgrade_asmdef.sh --reset "{}" \;
'@
    }

    $watch.Stop()
    Write-Host ">> Stopping $container" -BackgroundColor DarkGray
    docker kill $container | Out-Null
}

Write-Host ''
Write-Host "Full script completed in: $('{0:#,##}' -f $watch.ElapsedMilliseconds) ms" -ForegroundColor DarkGray
Write-Host ''
