#!/usr/bin/env pwsh
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Opens the current folder with the docker image

# THIS SCRIPT IS MEANT TO BE USED FOR DEVELOPMENT PURPOSES
# DO NOT USE IN PRODUCTION

param(
    [string]
    $VolumeSource = "/c/Projekt/Newtonsoft.Json-for-Unity",

    # Unity license.ulf
    [string]
    $UnityLicenseOverride,

    [string]
    $DockerImage = "applejag/newtonsoft.json-for-unity.package-unity-tester",

    [ValidateSet("2018.4.14f1", "2019.2.11f1", "2020.1.0b6-linux-il2cpp")]
    [string]
    $UnityVersion = "2019.2.11f1",

    [int]
    [ValidateRange(1, [int]::MaxValue)]
    $DockerImageVersion = 1,

    [string]
    $DockerImageOverride = ""
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
    Join-Path "$PSScriptRoot" "Unity_v$UnityVersion.ulf"
}

$Command = '/bin/bash'
$Args = @(
    , "-e", "TEST_PLATFORM=linux"
    , "-e", "WORKDIR=/root/repo"
    , "-e", "SCRIPTS=/root/repo/ci/scripts"
    , "-v", "${VolumeSource}:/root/repo"
)

if (Test-Path $UnityLicenseULF)
{
    Write-Output "Using Unity license $UnityLicenseULF"
    Write-Output "Using Docker image $DockerImage"
    Write-Output "Using volume $VolumeSource at /root/repo"
    
    $UnityLicenseContent = Get-Content -Path $UnityLicenseULF -Raw
    $UnityLicenseBytes = [System.Text.Encoding]::UTF8.GetBytes($UnityLicenseContent)
    $UnityLicenseB64 = [Convert]::ToBase64String($UnityLicenseBytes)

    $Args += @(
        , "-e", "UNITY_LICENSE_CONTENT_B64=$UnityLicenseB64"
    )
}
else
{
    Write-Output "No Unity license at $UnityLicenseULF, going for fetching login instead"
    Write-Output "Using Docker image $DockerImage"
    Write-Output "Using volume $VolumeSource at /root/repo"
    
    $UnityID = Get-Credential -Message "Enter UnityID login"
    $UnityUserName = $UnityID.UserName
    $UnityPassword = $UnityID.GetNetworkCredential().Password
    $Args += @(
        , "-e", "UNITY_USERNAME=$UnityUserName"
        , "-e", "UNITY_PASSWORD=$UnityPassword"
    )
    $Command = @"
    xvfb-run -as '-screen 0 640x480x24' \
        /opt/Unity/Editor/Unity \
        -logFile /dev/stdout \
        -batchmode \
        -username '$UnityUserName' -password '$UnityPassword'
    echo 
"@
}

Write-Output ""

$Command | docker run -i --rm $Args $DockerImage

# To generate the .alf file run this:
#
# xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
#  /opt/Unity/Editor/Unity \
#  -logFile \
#  -batchmode \
#  -username "$UNITY_USERNAME" -password "$UNITY_PASSWORD" \
# && cat /root/.config/unity3d/Unity/Editor.log

# Then copy the XML and paste into a new file and name if unity3d.alf
# Upload the .alf to https://license.unity3d.com/manual

# When running, dont forget running /ci/scripts/unity_login.sh
