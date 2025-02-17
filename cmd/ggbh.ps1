using namespace System.IO
using namespace System.Security.Cryptography
using namespace System.Text

<#
    Get Git Blob Hash
#>
param
(
    [Parameter(Position=0)]
    [String]
    $FilePath
)

[MemoryStream]$memoryStream = $null
[FileStream]$fileStream = $null

try
{
    $fileInfo = [FileInfo]::new($FilePath)
    $gitBlobHeaderBytes = [Encoding]::ASCII.GetBytes("blob $($FileInfo.Length)`0")

    $memoryStream = [MemoryStream]::new()
    $memoryStream.Write($gitBlobHeaderBytes, 0, $gitBlobHeaderBytes.Length)

    $fileStream = $fileInfo.OpenRead()
    $fileStream.CopyTo($memoryStream)

    [void]$memoryStream.Seek(0, [SeekOrigin]::Begin)

    $hashProvider = [SHA1CryptoServiceProvider]::new()
    $gitBlobHash = $hashProvider.ComputeHash($memoryStream)

    Write-Output ([BitConverter]::ToString($gitBlobHash).ToLower() -replace '-', '')
}
catch
{
    Throw
}
finally
{
    if ($null -ne $fileStream)
    {
        $fileStream.Dispose()
        $fileStream = $null
    }
    if ($null -ne $memoryStream)
    {
        $memoryStream.Dispose()
        $memoryStream = $null
    }
}
