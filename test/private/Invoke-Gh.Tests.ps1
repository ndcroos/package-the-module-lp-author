BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('/test/', '/source/')
    mock Invoke-RestMethod {}
}

Describe "Invoke-Gh" -Tag "Unit" {

    Context "Parameters" {

        it "Has parameters" {
            $function = Get-Command "Invoke-Gh"
            $function | Should -HaveParameter Endpoint -Type string -Mandatory
            $function | Should -HaveParameter Body -Type hashtable
            $function | Should -HaveParameter Method -Type string -DefaultValue "Get"
            $function | Should -HaveParameter ReturnRaw -Type switch
        }
    }

    Context "Not Authenticated" {
        it "Throws when user not authenticate" {
            { Invoke-Gh -Endpoint "Bla" } | Should -Throw
        }
    }

    Context "Authenticated" {

        BeforeAll {
            $Script:Connection = @{}
            $Script:Connection["Server"] = "https://pester.test"
            $Script:Connection.Headers = @{}

            $content = @{
                User = "Pester"
                Repo = "GH"
            } | ConvertTo-Json
            
            $ghResponse = @{
                content = $content
            } 

            mock Invoke-WebRequest { return $ghResponse }
        }
        it 'Runs with default parameters' {
            $response = Invoke-Gh -Endpoint test1
            $response | Should -BeOfType string
            $content = $response | ConvertFrom-Json
            $content.User | Should -be "Pester"
            $content.Repo | Should -be "GH"
        }
    }
        
}