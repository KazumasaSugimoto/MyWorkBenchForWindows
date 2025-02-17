using namespace System.IO
using namespace System.Text

<#
    NG Char Checker
#>
param
(
    [Parameter(Position=0)]
    [String]
    $TextFilePath,
    [String]
    $SourceEncodingName = 'UTF-8',
    [String]
    $TargetEncodingName = 'shift_jis'
)

[StreamReader]$streamReader = $null

try
{
    $sourceEncoding = [Encoding]::GetEncoding($SourceEncodingName)
    $targetEncoding = [Encoding]::GetEncoding($TargetEncodingName)

    $streamReader = [StreamReader]::new($TextFilePath, $sourceEncoding)
    [int]$lineNumber = 0

    $result = while (-not $streamReader.EndOfStream)
    {
        $textRow = $streamReader.ReadLine()
        $lineNumber++
        [int]$byteIndex = 0

        for ([int]$charIndex = 0; $charIndex -lt $textRow.Length; $charIndex++)
        {
            $sourceChar = $textRow[$charIndex]
            $sourceCharBytes = $sourceEncoding.GetBytes($sourceChar)

            $targetCharBytes = $targetEncoding.GetBytes($sourceChar)
            $targetChar = $targetEncoding.GetString($targetCharBytes, 0, $targetCharBytes.Length)

            if ($sourceChar -cne $targetChar)
            {
                [PSCustomObject]@{
                    "InlinePosition" = [PSCustomObject]@{
                        Line = $lineNumber
                        Column = $charIndex + 1
                        Byte = $byteIndex + 1
                    }
                    "Source[$($sourceEncoding.EncodingName)]" = [PSCustomObject]@{
                        Char = $sourceChar
                        Bytes = [BitConverter]::ToString($sourceCharBytes)
                    }
                    "Target[$($targetEncoding.EncodingName)]" = [PSCustomObject]@{
                        Char = $targetChar
                        Bytes = [BitConverter]::ToString($targetCharBytes)
                    }
                }
            }
            $byteIndex += $sourceCharBytes.Length
        }
    }

    Write-Output $result
}
catch
{
    throw
}
finally
{
    if ($null -ne $streamReader)
    {
        $streamReader.Dispose()
        $streamReader = $null
    }
}
