#!/usr/bin/env pwsh

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
Param ()

$ErrorActionPreference = "Stop"

if (-not $PSBoundParameters.ContainsKey('Confirm')) {
    $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
}
if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
    $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
}

class DockerBuild {
    [string] $ImageNameKey
    [string] $ImageVersion
    [System.Collections.Generic.List[string]] $ExtraArgs

    DockerBuild([string] $ImageNameKey, [string] $ImageVersion) {
        $this.ImageNameKey = $ImageNameKey
        $this.ImageVersion = $ImageVersion
        $this.ExtraArgs = [System.Collections.Generic.List[string]]::new()
    }

    [DockerBuild] WithExtraArg([string] $ExtraSwitch) {
        $this.ExtraArgs.Add($ExtraSwitch)
        return $this
    }
    [DockerBuild] WithExtraArg([string] $ExtraKey, [string] $ExtraValue) {
        $this.ExtraArgs.Add($ExtraKey)
        $this.ExtraArgs.Add($ExtraValue)
        return $this
    }
}

function Start-DockerBuild  {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    Param (
        [parameter(ValueFromPipeline=$true)]
        [DockerBuild] $Build
    )

    Process {
        $ImageName = "applejag/newtonsoft.json-for-unity.$($Build.ImageNameKey)"
        $DockerFile = "$PSScriptRoot/$($Build.ImageNameKey).Dockerfile"
        $ImageVersion = $Build.ImageVersion
        $ExtraArgs = $Build.ExtraArgs
        if ($PSCmdlet.ShouldProcess("${ImageName}:${ImageVersion}")) {
            Write-Host ">> Building ${ImageName}:${ImageVersion} " -BackgroundColor DarkGreen -ForegroundColor White
            docker build `
                -f $DockerFile `
                --build-arg IMAGE_VERSION=${ImageVersion} `
                -t ${ImageName}:${ImageVersion} `
                -t ${ImageName}:latest `
                @ExtraArgs `
                $PSScriptRoot

            if ($LASTEXITCODE -ne 0) {
                throw "Failed to build with args $ExtraArgs";
            }
        } else {
            Write-Host ">> Skipping building ${ImageName}:${ImageVersion} " -ForegroundColor DarkGray
        }
    }
}

$Builds = [DockerBuild[]] @(
#   , [DockerBuild]::new('package-unity-tester', 'v1-2018.4.14f1').
#       WithExtraArg('--build-arg', 'UNITY_VERSION=2018.4.14f1')

#   , [DockerBuild]::new('package-unity-tester', 'v1-2019.2.11f1').
#       WithExtraArg('--build-arg', 'UNITY_VERSION=2019.2.11f1')

    , [DockerBuild]::new('package-unity-tester', 'v1-2020.1.0b6-linux-il2cpp').
        WithExtraArg('--build-arg', 'UNITY_VERSION=2020.1.0b6-linux-il2cpp')

#   , [DockerBuild]::new('package-builder', 'v3')

#   , [DockerBuild]::new('package-deploy-npm', 'v3')

#   , [DockerBuild]::new('package-deploy-github', 'v6')
)

$Builds | Start-DockerBuild

Write-Host ">> Done! " -BackgroundColor DarkGreen -ForegroundColor Gray
