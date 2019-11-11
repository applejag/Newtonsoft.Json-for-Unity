
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

    [System.IO.FileInfo] $TempDirectory = $(Join-Path "." "Temp"),

    [ValidateSet('Release', 'Debug', IgnoreCase = $false)]
    [string] $Configuration = "Release",
    
    [ValidateSet('Standalone', 'AOT', 'Portable', 'Editor', IgnoreCase = $false)]
    [string] $UnityBuild = "Standalone",
    
    [string] $Framework,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $Passthrough,

    [version] $Version = [version]::new(),
    [string] $VersionSuffix
)

$ErrorActionPreference = "Stop"

New-Item $TempDirectory -ItemType Directory -Force | Out-Null
$TempFull = Resolve-Path $TempDirectory

$vswhereVersion = "2.3.2"
$vswherePath = Resolve-Path $(Join-Path $TempFull "vswhere.$vswhereVersion")

$pdb2mdbVersion = "4.2.3.4"
$pdb2mdbPath = Resolve-Path $(Join-Path $TempFull "mono.unofficial.pdb2mdb.$pdb2mdbVersion")

$dotnet = if ($IsWindows) { "dotnet" } else { "~/.dotnet/dotnet" }

$UnityBuildFrameworks = @{
    Standalone = "net462";
    AOT = "net462";
    Portable = "portable-net45+win8+wpa81+wp8";
    Editor = "net45";
}

if ([string]::IsNullOrWhiteSpace($Framework))
{
    $Framework = $UnityBuildFrameworks[$UnityBuild]
}

function GetMsBuildPath()
{
    if ($IsWindows) {
        $path = & (Join-Path $vswherePath (Join-Path "tools" "vswhere.exe")) -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
        if (!($path)) {
            throw "Could not find Visual Studio install path"
        }
        return Join-Path $path (Join-Path 'MSBuild' (Join-Path '15.0' (Join-Path 'Bin' 'MSBuild.exe')))
    } else {
        return "msbuild"
    }
}

function GetPdb2MdbPath() {
    if ($IsWindows) {
        return Join-Path $pdb2mdbPath (Join-Path "tools" "pdb2mdb.exe")
    } else {
        return "pdb2mdb"
    }
}

function GenerateMDB($dllFiles) {
    $pdb2mdb = GetPdb2MdbPath
    foreach ($dllFile in $dllFiles) {
        Write-Host "Converting .pdb for '$dllFile' to .mdb"
        & $pdb2mdb $dllFile
        if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 2) {
            # 0=success, 2=it's a portable, will still work as-is
            throw "Error converting pdb to mdb for $dllFile, exit code: $LASTEXITCODE"
        }
        Write-Host "Success on '$dllFile'" -ForegroundColor Green
    }
}

$VersionShort
if ($Version.Build -ne -1) {
    $VersionShort = $Version.ToString(3)
} else {
    $VersionShort = $Version.ToString()
}

$msbuild = GetMsBuildPath

Write-Host ""
Write-Host "Configuration: $Configuration"
Write-Host "UnityBuild: $UnityBuild"
Write-Host "Framework: $Framework"
if ($VersionSuffix) {
    Write-Host "Version: $Version-$VersionSuffix"
} else {
    Write-Host "Version: $Version"
}
Write-Host ""

New-Item $Destination -ItemType Directory -Force | Out-Null
$DestinationFullPath = Resolve-Path $Destination

# Build & Restore
& $msbuild /t:build /restore $Solution `
    /p:Configuration=$Configuration `
    /p:LibraryFrameworks=$Framework `
    /p:OutputPath=$DestinationFullPath `
    /p:UnityBuild=$UnityBuild `
    /p:VersionPrefix=$($VersionShort) `
    /p:VersionSuffix=$VersionSuffix `
    /p:AssemblyVersion=$($VersionShort) `
    /p:FileVersion=$Version `
    @Passthrough

if ($LASTEXITCODE -ne 0) {
    throw "Failed building $UnityBuild on $Solution, exit code: $LASTEXITCODE"
}

# Generate mdb from pdb
GenerateMDB $(Resolve-Path $(Join-Path $DestinationFullPath "*.dll"))