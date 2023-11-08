function Remove-GhRepository
{
    <#
    .SYNOPSIS
        Deletes a repository
    .DESCRIPTION
        Deleting a repository requires admin access. If OAuth is used, the delete_repo scope is required.
        If an organization owner has configured the organization to prevent members from deleting organization-owned repositories, you will get a 403 Forbidden response.    
    .PARAMETER Owner
        The account owner of the repository. The name is not case sensitive.
    .PARAMETER Repo
        The name of the repository without the .git extension. The name is not case sensitive.
    #>
    
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Owner,

        [Parameter(Mandatory)]
        [string]$Repo
    )
    
    $endpoint = "repos/$Owner/$Repo"
    $params = @{
        Method   = "Delete"
        endpoint = $endpoint
    }

    if ($PSCmdlet.ShouldProcess($endpoint))
    {
        Invoke-Gh @params
    }
}