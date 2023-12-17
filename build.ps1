param (
    [string]$Version = "1.0.0",

    [string]$Name = "Rct.GitHub"
)

#Requires -Module "ModuleBuilder"

#remove v from version
if ($Version[0] -eq "v")
{
    $Version = $Version.Substring(1)
}

#Get-Command to find nuget, and assign result to a variable
$nuget = Get-Command -Name nuget -CommandType Application | Select-Object -First 1

$params = @{
    SourcePath = "$PSScriptRoot/source/Rct.GitHub.psd1" 
    UnversionedOutputDirectory = $true
    Version = $Version 
    Passthru = $true
    Verbose = $true
    OutputDirectory = "$PSScriptRoot/build/Rct.GitHub"
    SourceDirectories = @("public", "private")
    PublicFilter = "public\*.ps1"
    CopyPaths = @("Rct.GitHub.nuspec")
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

# Use nuget to pack module, point it to the .nuspec file. 
# Pass in values for output directory and version parameters.
& $nuget pack $("$PSScriptRoot/build/$Name/Rct.GitHub.nuspec") -OutputDirectory $("$PSScriptRoot/build/nuget") -Version $Version