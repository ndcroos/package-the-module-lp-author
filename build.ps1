param (
    [string]$Version = "1.0.0",

    [string]$Name = "Rct.GitHub"
)

#Requires -Module "ModuleBuilder"

$params = @{
    SourcePath = "$PSScriptRoot/source/Rct.GitHub.psd1" 
    UnversionedOutputDirectory = $true
    Version = $Version 
    Passthru = $true
    Verbose = $true
    OutputDirectory = "$PSScriptRoot/build/Rct.GitHub"
    SourceDirectories = @("public", "private")
    PublicFilter = "public\*.ps1"
}

Write-Host "Building module [$Name] [$Version]"
$result = Build-Module @params

try 
{
    Write-Host "Loading module:[$($result.Path)]"
    Import-Module -Name $result.Path -ErrorAction stop -Force -Verbose
}
catch
{
    Throw "Failed to load module $_"
}
finally
{
    Write-Host "Unloading module"
    Remove-Module -Name $result.Name -ErrorAction SilentlyContinue
}
