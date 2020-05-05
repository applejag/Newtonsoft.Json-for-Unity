$ErrorActionPreference = "Stop"

function Publish-DockerImage  {
    Param (
        [parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Passthrough
    )

    Write-Host ">> Publishing $Passthrough" -BackgroundColor DarkCyan -ForegroundColor White
    docker push @Passthrough

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to publish with args $Passthrough";
    }
}

Publish-DockerImage applejag/newtonsoft.json-for-unity.package-unity-tester:v1-2019.2.11f1
Publish-DockerImage applejag/newtonsoft.json-for-unity.package-unity-tester:v1-2018.4.14f1
Publish-DockerImage applejag/newtonsoft.json-for-unity.package-unity-tester:latest

Publish-DockerImage applejag/newtonsoft.json-for-unity.package-builder:v2
Publish-DockerImage applejag/newtonsoft.json-for-unity.package-builder:latest

Publish-DockerImage applejag/newtonsoft.json-for-unity.package-deploy-npm:v3
Publish-DockerImage applejag/newtonsoft.json-for-unity.package-deploy-npm:latest

Publish-DockerImage applejag/newtonsoft.json-for-unity.package-deploy-github:v5
Publish-DockerImage applejag/newtonsoft.json-for-unity.package-deploy-github:latest
