$ErrorActionPreference = "Stop"

function Start-DockerBuild  {
    Param (
        [string]
        $ImageVersion = "v1",

        [string]
        $ImageName,

        [parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Passthrough
    )

    Write-Host ">> Building ${ImageName}:${ImageVersion} " -BackgroundColor DarkGreen -ForegroundColor White
    docker build `
        --build-arg IMAGE_VERSION=${ImageVersion} `
        -t ${ImageName}:${ImageVersion} `
        -t ${ImageName}:latest `
        @Passthrough `
        $PSScriptRoot

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to build with args $Passthrough";
    }
}

Start-DockerBuild -ImageVersion v1 `
    -ImageName applejag/newtonsoft.json-for-unity.package-unity-tester `
    -f $PSScriptRoot\package-unity-tester.Dockerfile `
    --build-arg UNITY_VERSION=2019.2.11f1

Start-DockerBuild -ImageVersion v1 `
    -ImageName applejag/newtonsoft.json-for-unity.package-builder `
    -f $PSScriptRoot\package-builder.Dockerfile

Start-DockerBuild -ImageVersion v1 `
    -ImageName applejag/newtonsoft.json-for-unity.package-deployer `
    -f $PSScriptRoot\package-deployer.Dockerfile

Write-Host ">> Done! " -BackgroundColor DarkGreen -ForegroundColor Gray
