# Put together from script originally by JamesNK
# https://github.com/JamesNK/Newtonsoft.Json/blob/c89d6addf118745c4c14536ce64fd69566ebd644/Build/build.ps1

$nugetUrl = 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe'
$nugetPath = '.\Temp\nuget.exe'
$vswhereVersion = '2.3.2'
$vswherePath = ".\Temp\vswhere.$vswhereVersion"
$nunitConsoleVersion = '3.8.0'
$nunitConsolePath = ".\Temp\NUnit.ConsoleRunner.$nunitConsoleVersion"

function Install-AllTheThingsINeed()
{
    EnsureNuGetExists
    EnsureNuGetPackage "vswhere" $vswherePath $vswhereVersion
    EnsureNuGetPackage "NUnit.ConsoleRunner" $nunitConsolePath $nunitConsoleVersion

    $msBuildPath = GetMsBuildPath
    Write-Host "MSBuild path $msBuildPath"

@"
`$nuget = '$(Resolve-Path $nugetPath)'
`$msbuild = '$msBuildPath'
`$vswhere = '$(Resolve-Path $vswherePath\tools\vswhere.exe)'
`$nunit3console = '$(Resolve-Path $nunitConsolePath\tools\nunit3-console.exe)'

function nuget {
    Param (
        [parameter(ValueFromRemainingArguments = `$true)]
        [string[]]`$Passthrough
    )
    &`$nuget @Passthrough
}

function msbuild {
    Param (
        [parameter(ValueFromRemainingArguments = `$true)]
        [string[]]`$Passthrough
    )
    &`$msbuild @Passthrough
}

function vswhere {
    Param (
        [parameter(ValueFromRemainingArguments = `$true)]
        [string[]]`$Passthrough
    )
    &`$vswhere @Passthrough
}

function nunit3console {
    Param (
        [parameter(ValueFromRemainingArguments = `$true)]
        [string[]]`$Passthrough
    )
    &`$nunit3console @Passthrough
}
"@ > .\Temp\profile.ps1
}

function EnsureNuGetExists()
{
    if (!(Test-Path $nugetPath))
    {
        Write-Host "Couldn't find nuget.exe. Downloading from $nugetUrl to $nugetPath"
        (New-Object System.Net.WebClient).DownloadFile($nugetUrl, $nugetPath)
    }
    else
    {
        Write-Host "nuget.exe was already installed."
    }
}

function EnsureNuGetPackage($packageName, $packagePath, $packageVersion)
{
    if (!(Test-Path $packagePath))
    {
        Write-Host "Couldn't find $packagePath. Downloading with NuGet"
        &$nugetPath install $packageName -OutputDirectory .\Temp -Version $packageVersion -ConfigFile "$sourceDir\nuget.config"
    }
    else
    {
        Write-Host "Package $packagePath. Was already installed"
    }
}

function GetMsBuildPath()
{
    $path = & $vswherePath\tools\vswhere.exe -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
    if (!($path))
    {
        throw "Could not find Visual Studio install path"
    }

    $msBuildPath = join-path $path 'MSBuild\15.0\Bin\MSBuild.exe'
    if (Test-Path $msBuildPath)
    {
        return $msBuildPath
    }

    $msBuildPath = join-path $path 'MSBuild\Current\Bin\MSBuild.exe'
    if (Test-Path $msBuildPath)
    {
        return $msBuildPath
    }

    throw "Could not find MSBuild path"
}

Install-AllTheThingsINeed