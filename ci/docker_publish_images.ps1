#!/usr/bin/env pwsh

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
Param (
    [switch]
    $Force
)

$ErrorActionPreference = "Stop"

if (-not $PSBoundParameters.ContainsKey('Confirm')) {
    $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
}
if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
    $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
}

$ErrorActionPreference = "Stop"

function Publish-DockerImage  {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    Param (
        [parameter(ValueFromPipeline=$true)]
        [string] $Image
    )

    Process {
        if ($Force -or $PSCmdlet.ShouldProcess($Image)) {
            Write-Host "`n>> Publishing $Image`n" -ForegroundColor DarkCyan
            docker push $Image

            if (-not $?) {
                throw "Failed to publish image $Image";
            }
        } else {
            Write-Host "`n>> Skipping pushing image $Image`n" -ForegroundColor DarkGray
        }
    }
}

[string[]] @(
    , 'applejag/newtonsoft.json-for-unity.package-unity-tester:v1-2019.2.11f1'
    , 'applejag/newtonsoft.json-for-unity.package-unity-tester:v1-2018.4.14f1'
    , 'applejag/newtonsoft.json-for-unity.package-unity-tester:v1-2020.1.0b6-linux-il2cpp'
    , 'applejag/newtonsoft.json-for-unity.package-unity-tester:latest'

    , 'applejag/newtonsoft.json-for-unity.package-builder:v3'
    , 'applejag/newtonsoft.json-for-unity.package-builder:latest'

    , 'applejag/newtonsoft.json-for-unity.package-deploy-npm:v3'
    , 'applejag/newtonsoft.json-for-unity.package-deploy-npm:latest'

    , 'applejag/newtonsoft.json-for-unity.package-deploy-github:v6'
    , 'applejag/newtonsoft.json-for-unity.package-deploy-github:latest'
) | Publish-DockerImage

Write-Host "`n>> Done! `n" -ForegroundColor DarkGreen
