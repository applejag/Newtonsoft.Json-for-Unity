#!/usr/bin/env pwsh
param (
    [Parameter(Mandatory = $true)]
    [System.IO.DirectoryInfo]
    $InputDirectory,

    [Parameter(Mandatory = $true)]
    [System.IO.DirectoryInfo]
    $OutputDirectory,
    
    [System.IO.FileInfo]
    $XSL = $((Resolve-Path (Join-Path $PSScriptRoot 'nunit2junit.xslt')).Path)
)

$ErrorActionPreference = "Stop"

Write-Host "Using transformer '$($XSL.FullName)'"
Write-Host "Converting NUnit XML files from folder '$($InputDirectory.FullName)'"
Write-Host "Outputting JUnit XML files into folder '$($OutputDirectory.FullName)'"
Write-Host ""

$settings = New-Object System.Xml.Xsl.XsltSettings
$resolver = New-Object System.Xml.XmlUrlResolver
$xslt = New-Object System.Xml.Xsl.XslCompiledTransform

$settings.EnableScript = 1
$xslt.Load($XSL.FullName, $settings, $resolver)

Get-ChildItem $InputDirectory -Filter *.xml |
Foreach-Object {
    Write-Host "Working on '$($_.Directory)' :: '$($_.Name)'"
    New-Item $OutputDirectory -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    $output = Join-Path $OutputDirectory $_.Name
    $xslt.Transform($_.FullName, $output)
}

Write-Host "Conversion complete" -ForegroundColor DarkGreen
