function Get-GhRepository
{
    <#
    .SYNOPSIS
    Retrieves a single repository

    .PARAMETER Owner
    The account owner of the repository. The name is not case sensitive.

    .PARAMETER Repo
    The name of the repository without the .git extension. The name is not case sensitive.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Owner,

        [Parameter(Mandatory)]
        [string]$Repo
    )
    
    $endpoint = "repos/$Owner/$Repo"
    $params = @{
        endpoint = $endpoint
        method = "Get"
    }
    Invoke-Gh @params | ConvertFrom-Json
}