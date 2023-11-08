BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    . "$PSScriptRoot/../../source/private/Invoke-Gh.ps1"; mock Invoke-Gh {};
}

Describe "Set-GhRepository" -Tag "Unit" {

    Context "Parameters" {

        it "Has parameters" {
            $function = Get-Command "Set-GhRepository"  
            $function | Should -HaveParameter Owner -Mandatory -Type String
            $function | Should -HaveParameter Repo -Mandatory -Type String
            $function | Should -HaveParameter Name -Type string
            $function | Should -HaveParameter Description -Type string
            $function | Should -HaveParameter Homepage -Type string
            $function | Should -HaveParameter Private -Type boolean
            $function | Should -HaveParameter AllowSquashMerge -Type boolean
            $function | Should -HaveParameter AllowMergeCommit -Type boolean
            $function | Should -HaveParameter AllowRebaseMerge -Type boolean
            $function | Should -HaveParameter AllowAutoMerge -Type boolean
            $function | Should -HaveParameter DeleteBranchOnMerge -Type boolean
            $function | Should -HaveParameter SquashMergeCommitTitle -Type string      
            $function | Should -HaveParameter SquashMergeCommitMessage -Type string
            $function | Should -HaveParameter MergeCommitTitle -Type string
            $function | Should -HaveParameter MergeCommitMessage -Type string
            $function | Should -HaveParameter Visibility -Type string
            $function | Should -HaveParameter SecurityAndAnalysis -Type string
            $function | Should -HaveParameter DefaultBranch -Type string
            $function | Should -HaveParameter AllowUpdateBranch -Type boolean
            $function | Should -HaveParameter UseSquashPrTitleAsDefault -Type boolean
            $function | Should -HaveParameter Archived -Type boolean
            $function | Should -HaveParameter AllowForking -Type boolean
            $function | Should -HaveParameter WebCommitSignoffRequired -Type boolean
        }
    }

    

    Context "Run" {
        it "Sends correct endpoint" {
            Set-GhRepository -Owner owner1 -Repo repo1
            Should -Invoke "Invoke-GH" -ParameterFilter { $Endpoint -eq "repos/owner1/repo1" -AND $Method -eq "Patch" }
        }

        it "Transforms parameters from PowerShell to GitHub" {
            Set-GhRepository -Owner owner2 -Repo repo2 -Private $true -DefaultBranch branch1
            Should -Invoke "Invoke-GH" -ParameterFilter {
                $Endpoint -eq "repos/owner2/repo2" -AND 
                $Method -eq "Patch" -AND
                $Body["Private"] -eq "true" -AND
                $body["default_branch"] -eq "branch1"  }
        }
    }
}