
# Run this script to build the
# <repo>/Src/Newtonsoft.Json/Newtonsoft.Json.csproj
# into
# <repo>/Src/Newtonsoft.Json-for-Unity/Plugins/*

param (
    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",

    [string[]] $UnityBuilds = @(
        ,'AOT'
        ,'Portable'
        ,'Editor'
    ),

    [string] $VolumeSource = "/c/Projekt/Newtonsoft.Json",

    [string] $Image = "applejag/json.net.unity-builder:v1",

    [string] $WorkingDirectory = "/root/repo"
)

$ErrorActionPreference = "Stop"

Write-Host ">> Starting $Image" -BackgroundColor DarkRed
$watch = [System.Diagnostics.Stopwatch]::StartNew()

$container = docker run -dit `
    -v "${VolumeSource}:/root/repo" `
    -e SCRIPTS=/root/repo/ci/scripts `
    -e BUILD_SOLUTION=/root/repo/Src/Newtonsoft.Json/Newtonsoft.Json.csproj `
    -e BUILD_DESTINATION_BASE=/root/repo/Src/Newtonsoft.Json-for-Unity/Plugins `
    -e BASH_ENV=/.bash_env `
    $Image

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
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to run command '$name'"
    }
    Write-Host ''
}

try {
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

    Invoke-DockerCommand 'NuGet restore' `
        'msbuild -t:restore "$BUILD_SOLUTION"'

    Invoke-DockerCommand 'Build Editor' `
        '$SCRIPTS/build.sh Editor'

    Invoke-DockerCommand 'Build AOT' `
        '$SCRIPTS/build.sh AOT'

    Invoke-DockerCommand 'Build Portable' `
        '$SCRIPTS/build.sh Portable'

    Invoke-DockerCommand 'Fix meta files' `
        '$SCRIPTS/generate_metafiles.sh $BUILD_DESTINATION_BASE'

    Write-Host '>> Done!' -BackgroundColor DarkGreen -ForegroundColor White

} finally {
    $watch.Stop()
    Write-Host ">> Stopping $container" -BackgroundColor DarkGray
    docker kill $container | Out-Null
}

Write-Host ''
Write-Host "Full script completed in: $('{0:#,##}' -f $watch.ElapsedMilliseconds) ms" -ForegroundColor DarkGray
Write-Host ''
