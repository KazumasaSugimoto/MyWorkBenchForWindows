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

if ($Alias   -eq '') { $Alias   = '[\w-]+' } else { $Alias   = $Alias.Replace('*', '[\w-]*') }
if ($Content -eq '') { $Content = '.*'     } else { $Content = $Content.Replace('*', '.*')   }

# git config --list --global |
git config list --global |
    findstr.exe /B /I /L "alias." |
    # Select-String "^alias\.($Alias)=(.*($Content).*)" |
    ForEach-Object {
        # [PSCustomObject]@{
        #     Alias   = $_.Matches[0].Groups[1].Value
        #     Content = $_.Matches[0].Groups[2].Value
        # }
        if ($_ -match "^alias\.(?<Alias>$Alias)=(?<Content>.*($Content).*)")
        {
            [PSCustomObject]@{
                Alias   = $Matches.Alias
                Content = $Matches.Content
            }
        }
    } |
    Sort-Object Alias |
    Format-Table -Wrap
