BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    . "$PSScriptRoot/../../source/private/Invoke-Gh.ps1"; mock Invoke-Gh {};
}

Describe "Get-GhRepository" -Tag "Unit" {

    Context "Parameters" {

        it "Has parameters" {
            $function = Get-Command "Get-GhRepository"  
            $function | Should -HaveParameter Owner -Mandatory -Type String
            $function | Should -HaveParameter Repo -Mandatory -Type String
        }
    }

    Context "Run" {
        it "Sends correct endpoint" {
            Get-GhRepository -Owner owner1 -Repo repo1
            Should -Invoke "Invoke-GH" -ParameterFilter { $Endpoint -eq "repos/owner1/repo1" -AND $Method -eq "Get" }
        }

    }
}