# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Opens the current folder with the docker image

# THIS SCRIPT IS MEANT TO BE USED FOR DEVELOPMENT PURPOSES
# DO NOT USE IN PRODUCTION

param(
    # Unity license
    [string]
    $UnityLicenseULF = (Join-Path $PSScriptRoot Unity_v2019.2.11f1.ulf),

    # Docker image
    [string]
    $DockerImage = "applejag/newtonsoft.json-for-unity:latest",

    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "Folder ""$_"" does not exist"
        }
        if(-Not ($_ | Test-Path -PathType Container) ){
            throw "The Path argument must be a folder. File paths are not allowed."
        }
        return $true
    })]
    [System.IO.DirectoryInfo]
    $VolumePath = (Join-Path $PSScriptRoot ..)
)

$ErrorActionPreference = "Stop"

$VolumePath = [string] (Resolve-Path $VolumePath)

$Command = '/bin/bash'
$Args = @(
    , "-e", "TEST_PLATFORM=linux"
    , "-e", "WORKDIR=/root/repo"
    , "-e", "SCRIPTS=/root/repo/ci/scripts"
    # , "-v", "${VolumePath}:/root/repo"
    , "-v", "/c/Projekt/Newtonsoft.Json:/root/repo"
)

if ((![string]::IsNullOrWhiteSpace($UnityLicenseULF)) -and (Test-Path $UnityLicenseULF))
{
    Write-Output "Using Unity license $UnityLicenseULF"
    Write-Output "Using Docker image $DockerImage"
    Write-Output "Using volume $VolumePath at /root/repo"
    
    $UnityLicenseContent = Get-Content -Path $UnityLicenseULF -Raw
    $UnityLicenseBytes = [System.Text.Encoding]::UTF8.GetBytes($UnityLicenseContent)
    $UnityLicenseB64 = [Convert]::ToBase64String($UnityLicenseBytes)

    $Args += @(
        , "-e", "UNITY_LICENSE_CONTENT_B64=$UnityLicenseB64"
    )
}
else
{
    Write-Output "Using Unity license <NONE>"
    Write-Output "Using Docker image $DockerImage"
    Write-Output "Using volume $VolumePath at /root/repo"
    
    $UnityID = Get-Credential -Message "Enter UnityID login"
    $Args += @(
        , "-e", "UNITY_USERNAME=$($UnityID.UserName)"
        , "-e", "UNITY_PASSWORD=$($UnityID.GetNetworkCredential().Password)"
    )
    $Command = "xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' `
     /opt/Unity/Editor/Unity `
     -logFile `
     -batchmode `
     -username `"$UNITY_USERNAME`" -password `"$UNITY_PASSWORD`" `
    && cat /root/.config/unity3d/Unity/Editor.log"
}

Write-Output ""

docker run -it --rm $Args $DockerImage $Command

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
