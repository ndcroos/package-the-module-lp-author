BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    mock Invoke-RestMethod {}
    mock Invoke-RestMethod {return @{"current_user_url" = "user"} } -ParameterFilter {$Uri -eq "https://api.github.com"}
}

Describe "Connet-Gh" -Tag "Unit" {

    Context "Parameters" {

        it "Has parameters" {
            $function = Get-Command "Connect-Gh"
            $function | Should -HaveParameter Token -Type securestring -Mandatory
            $function | Should -HaveParameter ServerUrl -Type string -DefaultValue "https://api.github.com"
            $function | Should -HaveParameter ApiVersion -Type string -DefaultValue "2022-11-28"
        }
    }

    Context "Run" {
        it "Authenticates" {
            $testToken = "token1"
            Connect-Gh -Token ($testToken | ConvertTo-SecureString -AsPlainText -Force)
            Should -Invoke "Invoke-RestMethod" -ParameterFilter { 
                $Uri -eq "https://api.github.com" -AND 
                $Headers["X-GitHub-Api-Version"] -eq "2022-11-28" -AND
                $Headers["Authorization"] -eq "Bearer token1"
            }
        }

        it 'Creates $Script:Connection' {
            $testToken = "token1"
            Connect-Gh -Token ($testToken | ConvertTo-SecureString -AsPlainText -Force)
            $Script:Connection | Should -BeOfType hashtable
            $Script:Connection["Token"] | Should -BeOfType securestring
            $Script:Connection["Server"] | Should -be "https://api.github.com"
            $Script:Connection["ApiVersion"] | Should -be "2022-11-28"
            $Script:Connection.Headers["Authorization"] | Should -be "Bearer token1"
        }

    }
}