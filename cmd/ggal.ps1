<#
    Get Git Alias
#>

param (
    [Parameter(Position=0)]
    [String]
    $Alias
)

if ($Alias -eq '') { $Alias = '\w+' } else { $Alias = $Alias.Replace('*', '\w*') }

git config list --global |
    Select-String "^alias\.($Alias)=(.*)" |
    ForEach-Object {
        [PSCustomObject]@{
            Alias   = $_.Matches[0].Groups[1]
            Content = $_.Matches[0].Groups[2]
        }
    } |
    Format-Table -Wrap
