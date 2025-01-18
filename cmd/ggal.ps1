<#
    Get Git Alias
#>

param (
    [Parameter(Position=0)]
    [String]
    $Alias = '',
    [Parameter(Position=1)]
    [String]
    $Content = ''
)

if ($Alias   -eq '') { $Alias   = '\w+' } else { $Alias   = $Alias.Replace('*', '\w*')  }
if ($Content -eq '') { $Content = '.*'  } else { $Content = $Content.Replace('*', '.*') }

git config list --global |
    Select-String "^alias\.($Alias)=($Content)" |
    ForEach-Object {
        [PSCustomObject]@{
            Alias   = $_.Matches[0].Groups[1]
            Content = $_.Matches[0].Groups[2]
        }
    } |
    Format-Table -Wrap
