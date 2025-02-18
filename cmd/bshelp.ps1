<#
    Batch Script Help Part Displayer
#>
param
(
    [Parameter(Position=0)]
    [String]
    $BatchFilePath
)

Get-Content -Path $BatchFilePath -Encoding OEM |
    ForEach-Object {
        if ($_ -match '^rem( ?(?<HelpMessage>.*))')
        {
            Write-Output $Matches['HelpMessage']
        }
    }
