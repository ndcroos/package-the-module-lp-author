function New-GhRepository
{

    <#
.SYNOPSIS
    Creates or modifies a repository with the specified properties.

.DESCRIPTION
    This script allows you to create or modify a repository with various properties.

.PARAMETER Name
    The name of the repository. (Required)

.PARAMETER Description
    A short description of the repository.

.PARAMETER Homepage
    A URL with more information about the repository.

.PARAMETER Private
    Whether the repository is private. (Default: false)

.PARAMETER HasIssues
    Whether issues are enabled. (Default: true)

.PARAMETER HasProjects
    Whether projects are enabled. (Default: true)

.PARAMETER HasWiki
    Whether the wiki is enabled. (Default: true)

.PARAMETER HasDiscussions
    Whether discussions are enabled. (Default: false)

.PARAMETER TeamId
    The id of the team that will be granted access to this repository.
    This is only valid when creating a repository in an organization.

.PARAMETER AutoInit
    Whether the repository is initialized with a minimal README. (Default: false)

.PARAMETER GitignoreTemplate
    The desired language or platform to apply to the .gitignore.

.PARAMETER LicenseTemplate
    The license keyword of the open-source license for this repository.

.PARAMETER AllowSquashMerge
    Whether to allow squash merges for pull requests. (Default: true)

.PARAMETER AllowMergeCommit
    Whether to allow merge commits for pull requests. (Default: true)

.PARAMETER AllowRebaseMerge
    Whether to allow rebase merges for pull requests. (Default: true)

.PARAMETER AllowAutoMerge
    Whether to allow Auto-merge to be used on pull requests. (Default: false)

.PARAMETER DeleteBranchOnMerge
    Whether to delete head branches when pull requests are merged. (Default: false)

.PARAMETER SquashMergeCommitTitle
    The default value for a squash merge commit title:
    - PR_TITLE (default to the pull request's title).
    - COMMIT_OR_PR_TITLE (default to the commit's title if only one commit,
      or the pull request's title when more than one commit).

.PARAMETER SquashMergeCommitMessage
    The default value for a squash merge commit message:
    - PR_BODY (default to the pull request's body).
    - COMMIT_MESSAGES (default to the branch's commit messages).
    - BLANK (default to a blank commit message).

.PARAMETER MergeCommitTitle
    The default value for a merge commit title:
    - PR_TITLE (default to the pull request's title).
    - MERGE_MESSAGE (default to the classic title for a merge message,
      e.g., Merge pull request #123 from branch-name).

.PARAMETER MergeCommitMessage
    The default value for a merge commit message:
    - PR_TITLE (default to the pull request's title).
    - PR_BODY (default to the pull request's body).
    - BLANK (default to a blank commit message).

.PARAMETER HasDownloads
    Whether downloads are enabled. (Default: true)

.PARAMETER IsTemplate
    Whether this repository acts as a template that can be used to generate new repositories.
    (Default: false)

.EXAMPLE
    Create a new repository with a name and description.
    PS> .\CreateRepository.ps1 -Name "MyRepo" -Description "A sample repository"

.EXAMPLE
    Modify an existing repository's settings.
    PS> .\ModifyRepository.ps1 -Name "ExistingRepo" -HasWiki $false -AllowAutoMerge $true
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $Description,

        [string] $Homepage,

        [boolean] $Private,

        [boolean] $HasIssues,

        [boolean] $HasProjects,

        [boolean] $HasWiki,

        [boolean] $HasDiscussions,

        [int] $TeamId,

        [boolean] $AutoInit,

        [string] $GitignoreTemplate,

        [string] $LicenseTemplate,

        [boolean] $AllowSquashMerge,

        [boolean] $AllowMergeCommit,

        [boolean] $AllowRebaseMerge,

        [boolean] $AllowAutoMerge,

        [boolean] $DeleteBranchOnMerge,

        [string] $SquashMergeCommitTitle,

        [ValidateSet("PR_BODY", "COMMIT_MESSAGES", "BLANK")]
        [string] $SquashMergeCommitMessage,

        [ValidateSet("PR_TITLE", "MERGE_MESSAGE")]
        [string] $MergeCommitTitle,

        [Validateset("PR_TITLE", "PR_BODY", "BLANK")]
        [string] $MergeCommitMessage,

        [boolean] $HasDownloads,

        [boolean] $IsTemplate
    )
    
    $body = @{}
    switch ($PSBoundParameters.Keys.GetEnumerator())
    {
        "Name" { $Body["name"] = $PSBoundParameters["name"] }
        "Description" { $Body["description"] = $PSBoundParameters["description"] }
        "Homepage" { $Body["homepage"] = $PSBoundParameters["Homepage"] }
        "Private" { $Body["private"] = $PSBoundParameters["Private"] }
        "HasIssues" { $Body["has_issues"] = $PSBoundParameters["HasIssues"] }
        "HasProjects" { $Body["has_projects"] = $PSBoundParameters["HasProjects"] }
        "HasWiki" { $Body["has_wiki"] = $PSBoundParameters["HasWiki"] }
        "HasDiscussions" { $Body["has_discussions"] = $PSBoundParameters["HasDiscussions"] }
        "TeamId" { $Body["team_id"] = $PSBoundParameters["TeamId"] }
        "AutoInit" { $Body["auto_init"] = $PSBoundParameters["AutoInit"] }
        "GitignoreTemplate" { $Body["gitignore_template"] = $PSBoundParameters["GitignoreTemplate"] }
        "LicenseTemplate" { $Body["license_template"] = $PSBoundParameters["LicenseTemplate"] }
        "AllowSquashMerge" { $Body["allow_squash_merge"] = $PSBoundParameters["AllowSquashMerge"] }
        "AllowMergeCommit" { $Body["allow_merge_commit"] = $PSBoundParameters["AllowMergeCommit"] }
        "AllowRebaseMerge" { $Body["allow_rebase_merge"] = $PSBoundParameters["AllowRebaseMerge"] }
        "AllowAutoMerge" { $Body["allow_auto_merge"] = $PSBoundParameters["AllowAutoMerge"] }
        "DeleteBranchOnMerge" { $Body["delete_branch_on_merge"] = $PSBoundParameters["DeleteBranchOnMerge"] }
        "SquashMergeCommitTitle" { $Body["squash_merge_commit_title"] = $PSBoundParameters["SquashMergeCommitTitle"] }
        "SquashMergeCommitMessage" { $Body["squash_merge_commit_message"] = $PSBoundParameters["SquashMergeCommitMessage"] }
        "MergeCommitTitle" { $Body["merge_commit_title"] = $PSBoundParameters["MergeCommitTitle"] }
        "MergeCommitMessage" { $Body["merge_commit_message"] = $PSBoundParameters["MergeCommitMessage"] }
        "HasDownloads" { $Body["has_downloads"] = $PSBoundParameters["HasDownloads"] }
        "IsTemplate" { $Body["is_template"] = $PSBoundParameters["IsTemplate"] }
    }

    $endpoint = "user/repos"
    $params = @{
        endpoint = $endpoint
        method   = "Post"
        body     = $body
    }

    if ($PSCmdlet.ShouldProcess($body.Name))
    {
        Invoke-Gh @params | ConvertFrom-Json
    }
}