function Set-GhRepository
{
    <#
.SYNOPSIS
    Update GitHub repository settings using the GitHub REST API.

.DESCRIPTION
    This script allows you to update various settings of a GitHub repository using the GitHub REST API.

.PARAMETER Owner
    The account owner of the repository. The name is not case sensitive.

.PARAMETER Repo
    The name of the repository without the .git extension. The name is not case sensitive.

.PARAMETER Name
    The name of the repository.

.PARAMETER Description
    A short description of the repository.

.PARAMETER Homepage
    A URL with more information about the repository.

.PARAMETER Private
    Either true to make the repository private or false to make it public. Default: false.

.PARAMETER Visibility
    The visibility of the repository. Can be one of: public, private.

.PARAMETER SecurityAndAnalysis
    Specify which security and analysis features to enable or disable for the repository. This parameter accepts a JSON object.

.PARAMETER DefaultBranch
    Updates the default branch for this repository.

.PARAMETER AllowSquashMerge
    Either true to allow squash-merging pull requests, or false to prevent squash-merging. Default: true.

.PARAMETER AllowMergeCommit
    Either true to allow merging pull requests with a merge commit, or false to prevent merging pull requests with merge commits. Default: true.

.PARAMETER AllowRebaseMerge
    Either true to allow rebase-merging pull requests, or false to prevent rebase-merging. Default: true.

.PARAMETER AllowAutoMerge
    Either true to allow auto-merge on pull requests, or false to disallow auto-merge. Default: false.

.PARAMETER DeleteBranchOnMerge
    Either true to allow automatically deleting head branches when pull requests are merged, or false to prevent automatic deletion. Default: false.

.PARAMETER AllowUpdateBranch
    Either true to always allow a pull request head branch that is behind its base branch to be updated even if it is not required to be up to date before merging, or false otherwise. Default: false.

.PARAMETER UseSquashPrTitleAsDefault (Deprecated)
    Either true to allow squash-merge commits to use pull request title, or false to use commit message. Deprecated: Please use SquashMergeCommitTitle instead. Default: false.

.PARAMETER SquashMergeCommitTitle
    The default value for a squash merge commit title. Can be one of: PR_TITLE, COMMIT_OR_PR_TITLE.

.PARAMETER SquashMergeCommitMessage
    The default value for a squash merge commit message. Can be one of: PR_BODY, COMMIT_MESSAGES, BLANK.

.PARAMETER MergeCommitTitle
    The default value for a merge commit title. Can be one of: PR_TITLE, MERGE_MESSAGE.

.PARAMETER MergeCommitMessage
    The default value for a merge commit message. Can be one of: PR_TITLE, PR_BODY, BLANK.

.PARAMETER Archived
    Whether to archive this repository. false will unarchive a previously archived repository. Default: false.

.PARAMETER AllowForking
    Either true to allow private forks, or false to prevent private forks. Default: false.

.PARAMETER WebCommitSignoffRequired
    Either true to require contributors to sign off on web-based commits, or false to not require contributors to sign off on web-based commits. Default: false.

#>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $Owner,
        [Parameter(Mandatory)]
        [string] $Repo,
        [string] $Name,
        [string] $Description,
        [string] $Homepage,
        [boolean] $Private,
        [ValidateSet("public", "private")]
        [string] $Visibility,
        [string] $SecurityAndAnalysis,
        [string] $DefaultBranch,
        [boolean] $AllowSquashMerge,
        [boolean] $AllowMergeCommit,
        [boolean] $AllowRebaseMerge,
        [boolean] $AllowAutoMerge,
        [boolean] $DeleteBranchOnMerge,
        [boolean] $AllowUpdateBranch,
        [boolean] $UseSquashPrTitleAsDefault,
        [string] $SquashMergeCommitTitle,
        [ValidateSet("PR_BODY", "COMMIT_MESSAGES", "BLANK")]
        [string] $SquashMergeCommitMessage,
        [ValidateSet("PR_TITLE", "MERGE_MESSAGE")]
        [string] $MergeCommitTitle,
        [Validateset("PR_TITLE", "PR_BODY", "BLANK")]
        [string] $MergeCommitMessage,
        [boolean] $Archived,
        [boolean] $AllowForking,
        [boolean] $WebCommitSignoffRequired
    )

    $endpoint = "repos/$Owner/$Repo"

    $body = @{}
    switch ($PSBoundParameters.Keys.GetEnumerator())
    {
        'Name' { $Body['name'] = $PSBoundParameters.Name }
        'Description' { $Body['description'] = $PSBoundParameters.Description }
        'Homepage' { $Body['homepage'] = $PSBoundParameters.Homepage }
        'Private' { $Body['private'] = $PSBoundParameters.Private }
        'Visibility' { $Body['visibility'] = $PSBoundParameters.Visibility }
        'SecurityAndAnalysis' { $Body['security_and_analysis'] = $PSBoundParameters.SecurityAndAnalysis | ConvertFrom-Json }
        'DefaultBranch' { $Body['default_branch'] = $PSBoundParameters.DefaultBranch }
        'AllowSquashMerge' { $Body['allow_squash_merge'] = $PSBoundParameters.AllowSquashMerge }
        'AllowMergeCommit' { $Body['allow_merge_commit'] = $PSBoundParameters.AllowMergeCommit }
        'AllowRebaseMerge' { $Body['allow_rebase_merge'] = $PSBoundParameters.AllowRebaseMerge }
        'AllowAutoMerge' { $Body['allow_auto_merge'] = $PSBoundParameters.AllowAutoMerge }
        'DeleteBranchOnMerge' { $Body['delete_branch_on_merge'] = $PSBoundParameters.DeleteBranchOnMerge }
        'AllowUpdateBranch' { $Body['allow_update_branch'] = $PSBoundParameters.AllowUpdateBranch }
        'SquashMergeCommitTitle' { $Body['squash_merge_commit_title'] = $PSBoundParameters.SquashMergeCommitTitle }
        'SquashMergeCommitMessage' { $Body['squash_merge_commit_message'] = $PSBoundParameters.SquashMergeCommitMessage }
        'MergeCommitTitle' { $Body['merge_commit_title'] = $PSBoundParameters.MergeCommitTitle }
        'MergeCommitMessage' { $Body['merge_commit_message'] = $PSBoundParameters.MergeCommitMessage }
        'Archived' { $Body['archived'] = $PSBoundParameters.Archived }
        'AllowForking' { $Body['allow_forking'] = $PSBoundParameters.AllowForking }
        'WebCommitSignoffRequired' { $Body['web_commit_signoff_required'] = $PSBoundParameters.WebCommitSignoffRequired }
    }

    $params = @{
        endpoint = $endpoint
        method   = "Patch"
        body     = $body
    }
    
    if ($PSCmdlet.ShouldProcess($endpoint))
    {
        Invoke-Gh @params | ConvertFrom-Json
    }
}