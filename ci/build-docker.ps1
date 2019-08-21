
# Builds and pushes the docker images

# THIS SCRIPT IS MEANT TO BE USED FOR DEVELOPMENT PURPOSES
# DO NOT USE IN PRODUCTION

param(
    # Docker image account
    [string]
    $account = "applejag",
    
    # Docker images
    [string[]]
    $images = @(
        # "unity",
        "devkit"
    ),

    $folder = $(Resolve-Path $(Join-Path $($PSCommandPath | Split-Path -Parent) "Docker")),

    # Unity version, also used as Docker image tag
    [string]
    $UnityVersion = "2019.1.14f1",

    [bool] $push = $false
)

Write-Host ">>> Building" -BackgroundColor Green -ForegroundColor Black
$step = 0
$steps = $images.Count * 2

foreach ($image in $images) {
    $step++;
    $imageFullName = "$account/$($image):$UnityVersion"
    $file = "$(Join-Path $folder $image).Dockerfile"
    Write-Host "> Building $imageFullName docker image (step $step/$steps)" -BackgroundColor DarkGreen -ForegroundColor Black
    Write-Host ""
    Write-Host "ARG UNITY_VERSION=$UnityVersion"
    docker build $folder -t $imageFullName -f $file --build-arg UNITY_VERSION=$UnityVersion
    if (-not $?) {
        throw "Failed to build $imageFullName (step $step/$steps)"
    }
    Write-Host ""
}

if ($push) {
    Write-Host ">>> Pushing" -BackgroundColor Blue -ForegroundColor Black

    foreach ($image in $images) {
        $step++;
        $imageFullName = "$account/$($image):$UnityVersion"
        Write-Host "> Pushing $imageFullName docker image (step $step/$steps)" -BackgroundColor DarkBlue -ForegroundColor Black
        Write-Host ""
        docker push $imageFullName
        if (-not $?) {
            throw "Failed to push $imageFullName (step $step/$steps)"
        }
        Write-Host ""
    }
    Write-Host "<<< Build and push complete" -BackgroundColor Cyan -ForegroundColor Black
} else {
    Write-Host "<<< Build complete" -BackgroundColor Cyan -ForegroundColor Black
}

