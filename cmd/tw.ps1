<#
    Text Warning
#>
param
(
    [Parameter(Position=0)]
    [String]
    $FilePath,
    [Parameter()]
    [String]
    $Encoding = 'OEM'
)

$byteReadOption = Get-MyPSByteOption
$headBytes = Get-Content -Path $FilePath @byteReadOption -Head 4
$tailByte  = Get-Content -Path $FilePath @byteReadOption -Tail 1

[int]$rowNum = 0

# check empty.
if ($headBytes.Count -eq 0)
{
    [PSCustomObject]@{
        Line = $rowNum
        Warning = 'Empty.'
    }
    return
}

# check BOM of UTF-8.
if ($headBytes.Count -ge 3)
{
    if ($headBytes[0] -eq 0xEF -and
        $headBytes[1] -eq 0xBB -and
        $headBytes[2] -eq 0xBF)
    {
        [PSCustomObject]@{
            Line = $rowNum
            Warning = 'Has BOM. { UTF-8 }'
        }
        # check empty.
        if ($headBytes.Count -eq 3)
        {
            [PSCustomObject]@{
                Line = $rowNum
                Warning = 'Empty.'
            }
            return
        }
    }
}

# check line by line.
$textRows = Get-Content -Path $FilePath -Encoding $Encoding
foreach ($textRow in $textRows)
{
    $rowNum++
    # check odd indent.
    if ($textRow -match '^(?<Indent> *)[^ ]*')
    {
        $length = $Matches['Indent'].Length
        $remain = $length % 2
        if ($remain -ne 0)
        {
            [PSCustomObject]@{
                Line = $rowNum
                Warning = "Odd indent. { Length: $length }"
            }
        }
    }
    # check before EOL.
    if ($textRow.EndsWith(' '))
    {
        [PSCustomObject]@{
            Line = $rowNum
            Warning = 'not printable char included just before EOL. { SPACE(0x20) }'
        }
    }
    elseif ($textRow.EndsWith("`t"))
    {
        [PSCustomObject]@{
            Line = $rowNum
            Warning = 'not printable char included just before EOL. { TAB(0x09) }'
        }
    }
}

# check before EOF.
if ($tailByte -ne 0x0A)
{
    [PSCustomObject]@{
        Line = $rowNum
        Warning = 'LF(0x0A) missing before EOF.'
    }
}
