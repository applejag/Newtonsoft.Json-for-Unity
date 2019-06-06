
param (
    [Parameter(Mandatory)]
    [ValidateScript({
        if( -Not ($_ | Test-Path) ){ throw "Solution (.sln or .csproj) file required." }
        if(-Not ($_ | Test-Path -PathType Leaf) ){ throw "The Solution argument must be a file. Folder paths are not allowed." }
        return $true
    })]
    [System.IO.FileInfo] $Solution,

    [Parameter(Mandatory)]
    [System.IO.FileInfo] $Destination,

    [System.IO.FileInfo] $TempDirectory = ".\Temp",

    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",
    
    [ValidateSet('Standalone', 'AOT', 'Portable', IgnoreCase = $false)]
    [string] $UnityBuild = "Standalone",
    
    [string] $Framework,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $Passthrough
)

$ErrorActionPreference = "Stop"

New-Item $TempDirectory -ItemType Directory -Force | Out-Null
$TempFull = Resolve-Path $TempDirectory

$vswhereVersion = "2.3.2"
$vswherePath = Resolve-Path "$TempFull\vswhere.$vswhereVersion"

$UnityBuildFrameworks = @{
    Standalone = "net462";
    AOT = "net462";
    Portable = "portable-net45+win8+wpa81+wp8";
}

if ([string]::IsNullOrWhiteSpace($Framework))
{
    $Framework = $UnityBuildFrameworks[$UnityBuild]
}

function GetMsBuildPath()
{
  $path = & $vswherePath\tools\vswhere.exe -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
  if (!($path)) {
    throw "Could not find Visual Studio install path"
  }
  return join-path $path 'MSBuild\15.0\Bin\MSBuild.exe'
}

$msbuild = GetMsBuildPath

Write-Host ""
Write-Host "Configuration: $Configuration"
Write-Host "UnityBuild: $UnityBuild"
Write-Host "Framework: $Framework"
Write-Host ""

New-Item $Destination -ItemType Directory -Force | Out-Null
$DestinationFullPath = Resolve-Path $Destination

& $msbuild /t:build $Solution /m /p:Configuration=$Configuration /p:LibraryFrameworks=$Framework /p:OutputPath=$DestinationFullPath /p:UnityBuild=$UnityBuild @Passthrough