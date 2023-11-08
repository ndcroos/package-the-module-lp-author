function Invoke-Gh
{
    <#
    .SYNOPSIS
        Main function for all other API calls
    .DESCRIPTION
        This function handles passing all required headers, server url. etc so that 
        all other functions can be simplified which makes extending module much faster.
    .PARAMETER Endpoint
        Endpoint to call e.g. repos/user/repo1
    .PARAMETER Body
        Body for call
    .PARAMETER Method
        Which method to use for a call
    .PARAMETER ReturnRaw
        Returns result of Invoke-WebRequest
    #>
    
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [hashtable]$Body,

        [ValidateSet("Get", "Post", "Delete", "Patch")]
        [string]$Method = "Get",

        [switch]$ReturnRaw
    )
  
    if ( -not ($Script:Connection))
    {
        Throw "Please connect to GitHub"
    }
    
    $url = "$($Script:Connection.Server)/$($Endpoint.TrimStart("/"))"
    Write-Verbose "Url: [$url]"
    $params = @{
        Method  = $Method
        Headers = $Script:Connection.Headers
        Uri     = $url
    }

    if ($PSBoundParameters.ContainsKey('Body'))
    {
        $params.Add("body", ( ConvertTo-Json -InputObject $Body -Depth 99))
    }

    $response = Invoke-WebRequest @params
    if ($ReturnRaw.IsPresent)
    {
        return $response
    }
    else
    {
        return $response.Content
    }

}