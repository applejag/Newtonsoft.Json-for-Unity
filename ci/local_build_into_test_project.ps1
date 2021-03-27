#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [string]
    [ValidateSet('Standalone','AOT','Editor','Tests')]
    $UnityBuild = 'Tests'
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host ">>> (1/2) BUILDING DEBUG BUILD OF PACKAGE USING local_build_into_package.ps1 " -BackgroundColor DarkCyan -ForegroundColor Black
Write-Host ""
&$PSScriptRoot\local_build_into_package.ps1 `
    -Configuration Debug `
    -UnityBuilds @($UnityBuild) `
    -RelativeBuildDestination "Src/Newtonsoft.Json-for-Unity.Tests/Assets/Plugins/Newtonsoft.Json/" `
    -RelativeBuildDestinationBase "Src/Newtonsoft.Json-for-Unity.Tests/Assets/Plugins/" `
    -UseDefaultAssemblyVersion `
    -DontSign
if ($LASTEXITCODE -ne 0) {
    throw "Failed to complete debug build"
}
Write-Host ""
Write-Host ">>> (1/2) COMPLETED DEBUG BUILD OF PACKAGE USING local_build_into_package.ps1 " -BackgroundColor DarkGreen -ForegroundColor Black
Write-Host ""

Write-Host ""
Write-Host ">>> (2/2) BUILDING DEBUG BUILD OF TESTS USING local_build_into_package.ps1 " -BackgroundColor DarkCyan -ForegroundColor Black
Write-Host ""

&$PSScriptRoot\local_build_into_package.ps1 `
    -Configuration Debug `
    -UnityBuilds @("Tests") `
    -RelativeBuildSolution "Src/Newtonsoft.Json.Tests/Newtonsoft.Json.Tests.csproj" `
    -RelativeBuildDestination "Src/Newtonsoft.Json-for-Unity.Tests/Assets/Plugins/Newtonsoft.Json.Tests/" `
    -RelativeBuildDestinationBase "Src/Newtonsoft.Json-for-Unity.Tests/Assets/Plugins/" `
    -CopyFiles @("Newtonsoft.Json.Tests.dll", "Newtonsoft.Json.Tests.pdb", "System.Web.Polyfill.dll", "System.Web.Polyfill.pdb") `
    -UseDefaultAssemblyVersion `
    -AdditionalConstants "ENABLE_IL2CPP" `
    -DontSign

if ($LASTEXITCODE -ne 0) {
    throw "Failed to complete debug build"
}

Write-Host ""
Write-Host ">>> (2/2) COMPLETED DEBUG BUILD OF TESTS USING local_build_into_package.ps1 " -BackgroundColor DarkGreen -ForegroundColor Black
Write-Host ""
