BeforeAll {
    Import-Module -Name "$PSScriptRoot/../../build/Rct.GitHub/Rct.GitHub.psd1"
}

Describe "Rct.GitHub" -Tag "Integration" {
    Context "Repository lifecycle" {
        it "Creates, updates and removes a repository" {
            Connect-RctGh -Token ($Env:GHTOKEN | ConvertTo-SecureString -Force -AsPlainText)
            $newRepository = New-Guid
            Write-Host "New Repository: [$newRepository]"
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Throw
            New-RctGhRepository -Private $true -Name $newRepository -AutoInit $true
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Not -Throw
            Set-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository -Description "This is a test"
            $repo = Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository
            $repo.Description | Should -Be "This is a test"
            { Remove-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Not -Throw
            { Get-RctGhRepository -Owner $Env:TESTOWNER -Repo $newRepository } | Should -Throw
        }
    } 
}