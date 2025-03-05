function prompt
{
#   "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
    "PS $($executionContext.SessionState.Path.CurrentLocation)`n> ";
}

function Get-MyPSVersionString
{
<#
    .SYNOPSIS
        Put PSVersion String.
#>
    Write-Output $PSVersionTable.PSVersion.ToString()
}

function Get-MyPSVersionIndex
{
    if ($PSVersionTable.PSVersion.Major -le 5) { return 0 } else { return 1 }
}

function Move-MyPSCurrentDirectory
{
<#
    .SYNOPSIS
        pushd/popd helper.
#>
    param
    (
        [Parameter()]
        [String]
        $Path = ''
    )

    if ($Path -ne '')
    {
        Push-Location -Path $Path
    }
    else
    {
        Pop-Location
    }
}

function Get-MyPSCommandSyntax
{
<#
    .SYNOPSIS
        put command syntax.
#>
    param
    (
        [Parameter(Position=0)]
        [String]
        $Name,
        [Parameter(Position=1)]
        [String]
        $Parameter = '',
        [switch]
        $ReturnValues
    )

    $result = Get-Command -Name $Name

    switch ($result.CommandType.ToString())
    {
        "Alias"
        {
            Write-Output "`n$($result.DisplayName)"
            $Name = $result.ResolvedCommandName
        }
    }

    if ($Parameter -eq '')
    {
        $paramSets = (Get-Command -Name $Name).ParameterSets
        foreach ($paramSet in $paramSets)
        {
            Write-Output "`n$($paramSet.Name):"
            Write-Output "`n$Name $($paramSet.ToString())"
        }
        if ($ReturnValues)
        {
            $retVals = Get-Help -Name $Name |
                Select-Object -ExpandProperty returnValues -ErrorAction Ignore
            if ($retVals -ne $nul)
            {
                Write-Output "`nReturnValues:"
                Write-Output $retVals
            }
        }
        Write-Output ''
    }
    elseif ($Parameter -eq '?')
    {
        $examples = Get-Help -Name $Name |
            Select-Object -ExpandProperty examples -ErrorAction Ignore
        if ($examples -ne $nul)
        {
            Write-Output $examples
        }
        else
        {
            Write-Output "`nno example.`n"
        }
    }
    else
    {
        Get-Help -Name $Name -Parameter $Parameter -ErrorAction Ignore
    }
}

function Get-MyPSScriptBlock
{
<#
    .SYNOPSIS
        put script source.
#>
    param
    (
        [Parameter(Position=0)]
        [String]
        $Name
    )

    $result = Get-Command -Name $Name

    switch ($result.CommandType.ToString())
    {
        "Alias"
        {
            Write-Output "`n$($result.DisplayName)"
            Get-MyPSScriptBlock -Name $result.ResolvedCommandName
        }
        Default
        {
            Select-Object -InputObject $result -ExpandProperty ScriptBlock -ErrorAction Ignore
        }
    }
}

function Get-MyPSWindowTitle
{
<#
    .SYNOPSIS
        Put host window title.
#>
    Write-Output (Get-Host).UI.RawUI.WindowTitle
}

function Set-MyPSWindowTitle
{
<#
    .SYNOPSIS
        Set host window title.
#>
    param
    (
        [Parameter()]
        [String]
        $WindowTitle = ''
    )

    switch ($WindowTitle)
    {
        ''
        {
            $WindowTitle = (Get-Location).Path
            break
        }
        ({ $_ -in @( '.', '..' ) })
        {
            $WindowTitle = (Get-Item -Path $_).Name
            break
        }
    }

    (Get-Host).UI.RawUI.WindowTitle = $WindowTitle
}

function Get-MyPSByteOption
{
    if ($PSVersionTable.PSVersion.Major -le 5)
    {
        return @{ Encoding = 'Byte' }
    }
    else
    {
        return @{ AsByteStream = $true }
    }
}

function Get-MyPSFolderInfo
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $FolderPath,
        [Parameter()]
        [int]
        $Depth = 0
    )

    $folderInfo = Get-Item -LiteralPath $FolderPath -Force

    $myPSNotes = [PSCustomObject]@{
        RawPath = $FolderPath
        FilesCount = 0
        FoldersCount = 0
        Size = 0
        Depth = $Depth
        Exceptions = [System.Collections.Generic.List[String]]::new()
        ProcTime = [PSCustomObject]@{
            Begin = [System.DateTime]::Now
            "End" = $null
        }
    }

    try
    {
        $folderInfo.GetFiles() |
            ForEach-Object {
                $myPSNotes.FilesCount++
                $myPSNotes.Size += $_.Length
            }
    }
    catch
    {
        $myPSNotes.Exceptions.Add($_)
    }

    try
    {
        $folderInfo.GetDirectories() |
            ForEach-Object {
                $myPSNotes.FoldersCount++
                $subFolderInfo = Get-MyPSFolderInfo -FolderPath $_.FullName -Depth ($Depth + 1)
                $myPSNotes.FilesCount += $subFolderInfo.MyPSNotes.FilesCount
                $myPSNotes.FoldersCount += $subFolderInfo.MyPSNotes.FoldersCount
                $myPSNotes.Size += $subFolderInfo.MyPSNotes.Size
                if ($myPSNotes.Depth -lt $subFolderInfo.MyPSNotes.Depth) {
                    $myPSNotes.Depth = $subFolderInfo.MyPSNotes.Depth
                }
                $myPSNotes.Exceptions.AddRange($subFolderInfo.MyPSNotes.Exceptions)
            }
    }
    catch
    {
        $myPSNotes.Exceptions.Add($_)
    }

    $myPSNotes.ProcTime.End = [System.DateTime]::Now

    Add-Member -InputObject $folderInfo -NotePropertyName MyPSNotes -NotePropertyValue $myPSNotes

    return $folderInfo
}

function Get-MyPSFileList
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $FolderPath,
        [int]
        $DepthOffset = -1,
        [switch]
        $NeedHash,
        [switch]
        $TsvFormat
    )

    $folderInfo = Get-Item -LiteralPath $FolderPath -Force

    if ($folderInfo.Attributes.IsReparsePoint) { return }
    if ($folderInfo.Attributes.IsNotDirectory) { return }

    $folderPathNodes = $folderInfo.FullName -split '\\'
    $actualDepth = $folderPathNodes.Count - 1
    if ($folderPathNodes[-1] -eq '') { $actualDepth-- }

    if ($DepthOffset -lt 0)
    {
        $DepthOffset = $actualDepth
        if ($TsvFormat)
        {
            $headerFields = @(
                'FolderPath'
                'FileName'
                'FileSize'
                'ModifiedTime'
                'PathLength(char)'
                'PathLength(sjisBytes)'
                'Depth(relative)'
                'Depth(actual)'
                'Group1'
                'Group2'
                'Group3'
                'BaseName'
                'Extension'
                'IsReadOnly'
                'IsHidden'
                'IsTemporary'
                'IsSystemFile'
                'IsReparsePoint'
                'FileHash'
                'OutputTime'
            )
            Write-Output ($headerFields -join "`t")
        }
    }

    $relativeDepth = $actualDepth - $DepthOffset
    $relativePathNodes = $folderPathNodes[$DepthOffset..$actualDepth]
    $relativePathNodes[0] = '.'

    $group1 = $relativePathNodes[0..1] -join '\'
    $group2 = $relativePathNodes[0..2] -join '\'
    $group3 = $relativePathNodes[0..3] -join '\'

    $sjisEncoding = [System.Text.Encoding]::GetEncoding('shift_jis')

    Get-ChildItem -LiteralPath $FolderPath -Force |
        ForEach-Object {
            if ($_.Attributes.IsDirectory)
            {
                $paramSet = @{
                    FolderPath      = $_.FullName
                    DepthOffset     = $DepthOffset
                    NeedHash        = $NeedHash
                    TsvFormat       = $TsvFormat
                }
                Get-MyPSFileList @paramSet
            }
            else
            {
                $modifiedTime = $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
                $pathLengthBySjisBytes = $sjisEncoding.GetByteCount($_.FullName)

                $isReadOnly     = $_.Attributes.IsReadOnly
                $isHidden       = $_.Attributes.IsHidden
                $isTemporary    = $_.Attributes.IsTemporary
                $isSystemFile   = $_.Attributes.IsSystem
                $isReparsePoint = $_.Attributes.IsReparsePoint

                $fileHash = $null
                if ($NeedHash)
                {
                    $fileHash = ($_ | Get-FileHash -Algorithm SHA1)
                    $fileHash = "$($fileHash.Algorithm):$($fileHash.Hash.ToLower())"
                }
                $outputTime = [System.DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')

                if ($TsvFormat)
                {
                    $detailFields = @(
                        $_.DirectoryName
                        $_.Name
                        $_.Length
                        $modifiedTime
                        $_.FullName.Length
                        $pathLengthBySjisBytes
                        $relativeDepth
                        $actualDepth
                        $group1
                        $group2
                        $group3
                        $_.BaseName
                        $_.Extension
                        $isReadOnly
                        $isHidden
                        $isTemporary
                        $isSystemFile
                        $isReparsePoint
                        $fileHash
                        $outputTime
                    )
                    Write-Output ($detailFields -join "`t")
                }
                else
                {
                    [PSCustomObject]@{
                        FolderPath              = $_.DirectoryName
                        FileName                = $_.Name
                        FileSize                = $_.Length
                        ModifiedTime            = $modifiedTime
                        'PathLength(char)'      = $_.FullName.Length
                        'PathLength(sjisBytes)' = $pathLengthBySjisBytes
                        'Depth(relative)'       = $relativeDepth
                        'Depth(actual)'         = $actualDepth
                        Group1                  = $group1
                        Group2                  = $group2
                        Group3                  = $group3
                        BaseName                = $_.BaseName
                        Extension               = $_.Extension
                        'IsReadOnly'            = $isReadOnly
                        'IsHidden'              = $isHidden
                        'IsTemporary'           = $isTemporary
                        'IsSystemFile'          = $isSystemFile
                        'IsReparsePoint'        = $isReparsePoint
                        FileHash                = $fileHash
                        OutputTime              = $outputTime
                    }
                }
            }
        }
}

function Get-MyPSFileInfo
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $FilePath,
        [Parameter(Position=1)]
        [String]
        $HashAlgorithm = 'SHA1'
    )

    $fileInfo = Get-Item -Path $FilePath -Force
    $fileHash = Get-FileHash -Path $FilePath -Algorithm $HashAlgorithm

    $byteReadOption = Get-MyPSByteOption
    $headByte = Get-Content -Path $FilePath @byteReadOption -Head 1
    $tailByte = Get-Content -Path $FilePath @byteReadOption -Tail 1

    $myPSNotes = [PSCustomObject]@{
        RawPath = $FilePath
        HeadByte = $headByte
        TailByte = $tailByte
        Hash = @{
            $HashAlgorithm = $fileHash.Hash.ToLower()
        }
    }

    Add-Member -InputObject $fileInfo -NotePropertyName MyPSNotes -NotePropertyValue $myPSNotes

    return $fileInfo
}

function Get-MyPSTextFileInfo
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $FilePath,
        [Parameter(Position=1)]
        [String]
        $HashAlgorithm = 'SHA1',
        [Parameter()]
        [String]
        $Encoding = 'OEM'
    )

    $fileInfo = Get-MyPSFileInfo -FilePath $FilePath -HashAlgorithm $HashAlgorithm

    $rowsCount = @{
        Total = [int]0
        Blank = [int]0
    }

    Get-Content -Path $FilePath -Encoding $Encoding |
        ForEach-Object {
            $rowsCount.Total++
            if ($_ -eq '') { $rowsCount.Blank++ }
        }

    Add-Member -InputObject $fileInfo.MyPSNotes -NotePropertyName RowsCount -NotePropertyValue $rowsCount

    return $fileInfo
}

function Get-MyPSPathLengthWarning
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $BaseFolderPath = '.',
        [int]
        $LimitLength = 240
    )

    $sjisEncoding = [Text.Encoding]::GetEncoding('shift_jis')
    $items = (cmd /c "cd ""$BaseFolderPath"" & dir /a- /b /s *")

    foreach ($item in $items)
    {
        $sjisBytes = $sjisEncoding.GetBytes($item)
        $length = $sjisBytes.Length
        if ($length -le $LimitLength) { continue }
        [PSCustomObject]@{
            Length = $length
            Path = $item
        }
    }
}

function Get-MyPSLeafFolders
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $BaseFolderPath = '.'
    )

    $subFolders = (cmd /c "cd ""$BaseFolderPath"" & dir /ad /b /s")

    if ($nul -eq $subFolders)
    {
        Write-Output (Get-Item -Path $BaseFolderPath -Force).FullName
        return
    }

    $prevFolder = ''
    Sort-Object -InputObject $subFolders -Descending |
        ForEach-Object {
            if ($prevFolder -notlike "$_*")
            {
                Write-Output $_
            }
            $prevFolder = $_
        } |
        Sort-Object
}

function Get-MyPSEmptyFolders
{
    param
    (
        [Parameter(Position=0)]
        [String]
        $BaseFolderPath = '.'
    )

    Get-MyPSLeafFolders -BaseFolderPath $BaseFolderPath |
        ForEach-Object {
            $folderInfo = Get-Item -Path $_ -Force
            if ($folderInfo.GetFiles().Count -eq 0)
            {
                Write-Output $_
            }
        }
}

Set-Alias -Name ver     -Value Get-MyPSVersionString
Set-Alias -Name pd      -Value Move-MyPSCurrentDirectory
Set-Alias -Name syntax  -Value Get-MyPSCommandSyntax
Set-Alias -Name src     -Value Get-MyPSScriptBlock
Set-Alias -Name source  -Value Get-MyPSScriptBlock
Set-Alias -Name tt      -Value Set-MyPSWindowTitle

$paramSet = @{
    TypeName    = 'System.String'
    MemberType  = 'ScriptMethod'
}
Update-TypeData @paramSet -MemberName SplitByLength -Value {
    param (
        [Parameter(Position=0)]
        [int]
        $Length
    )

    for ($i = 0; $i -lt $this.Length; $i += $Length)
    {
        try
        {
            $this.Substring($i, $Length)
        }
        catch
        {
            $this.Substring($i)
        }
    }
}

Update-TypeData @paramSet -MemberName HexStringToBytes -Value {
    $this.SplitByLength(2) |
        ForEach-Object {
            [System.Convert]::ToByte($_, 16)
        }
}

Update-TypeData @paramSet -MemberName HexStringToBase64 -Value {
    [System.Convert]::ToBase64String($this.HexStringToBytes())
}

Update-TypeData @paramSet -MemberName OctStringToBytes -Value {
    $this.SplitByLength(3) |
        ForEach-Object {
            [System.Convert]::ToByte($_, 8)
        }
}

Update-TypeData @paramSet -MemberName OctStringToBase64 -Value {
    [System.Convert]::ToBase64String($this.OctStringToBytes())
}

Update-TypeData @paramSet -MemberName BinStringToBytes -Value {
    $this.SplitByLength(8) |
        ForEach-Object {
            [System.Convert]::ToByte($_, 2)
        }
}

Update-TypeData @paramSet -MemberName BinStringToBase64 -Value {
    [System.Convert]::ToBase64String($this.BinStringToBytes())
}

$paramSet = @{
    TypeName    = 'System.Management.Automation.ExternalScriptInfo'
    MemberType  = 'ScriptProperty'
    MemberName  = 'DirectoryName'
}
Update-TypeData @paramSet -Value {
    return $this.Path.Substring(0, $this.Path.Length - $this.Name.Length - 1)
}

$paramSet = @{
    TypeName    = 'System.IO.FileAttributes'
    MemberType  = 'ScriptProperty'
}
Update-TypeData @paramSet -MemberName IsDirectory -Value {
    return ($this -band [System.IO.FileAttributes]::Directory) -ne 0
}

Update-TypeData @paramSet -MemberName IsNotDirectory -Value {
    return ($this -band [System.IO.FileAttributes]::Directory) -eq 0
}

Update-TypeData @paramSet -MemberName IsReadOnly -Value {
    return ($this -band [System.IO.FileAttributes]::ReadOnly) -ne 0
}

Update-TypeData @paramSet -MemberName IsHidden -Value {
    return ($this -band [System.IO.FileAttributes]::Hidden) -ne 0
}

Update-TypeData @paramSet -MemberName IsTemporary -Value {
    return ($this -band [System.IO.FileAttributes]::Temporary) -ne 0
}

Update-TypeData @paramSet -MemberName IsSystem -Value {
    return ($this -band [System.IO.FileAttributes]::System) -ne 0
}

Update-TypeData @paramSet -MemberName IsReparsePoint -Value {
    return ($this -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
}

$paramSet = @{
    TypeName    = 'System.IO.FileInfo'
    MemberType  = 'ScriptMethod'
}
Update-TypeData @paramSet -MemberName GetHeadBytes -Value {
    param
    (
        [Parameter(Position=0)]
        [int]
        $Length = 1
    )
    $byteOption = Get-MyPSByteOption
    $this | Get-Content @byteOption -Head $Length
}

Update-TypeData @paramSet -MemberName GetTailBytes -Value {
    param
    (
        [Parameter(Position=0)]
        [int]
        $Length = 1
    )
    $byteOption = Get-MyPSByteOption
    $this | Get-Content @byteOption -Tail $Length
}

Update-TypeData @paramSet -MemberName GetFileHash -Value {
    param
    (
        [Parameter(Position=0)]
        [String]
        $Algorithm = 'Git'
    )

    if ($Algorithm -ne 'Git')
    {
        return ($this | Get-FileHash -Algorithm $Algorithm)
    }

    [System.IO.MemoryStream]$memoryStream = $null
    [System.IO.FileStream]$fileStream = $null

    try
    {
        $gitBlobHeaderBytes = [System.Text.Encoding]::ASCII.GetBytes("blob $($this.Length)`0")

        $memoryStream = [System.IO.MemoryStream]::new()
        $memoryStream.Write($gitBlobHeaderBytes, 0, $gitBlobHeaderBytes.Length)

        $fileStream = $this.OpenRead()
        $fileStream.CopyTo($memoryStream)

        [void]$memoryStream.Seek(0, [System.IO.SeekOrigin]::Begin)

        $gitBlobHash = Get-FileHash -InputStream $memoryStream -Algorithm SHA1

        $gitBlobHash.Algorithm = 'GitBlob(SHA1)'
        $gitBlobHash.Path = $this.FullName

        return $gitBlobHash
    }
    catch
    {
        throw
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
}

$paramSet = @{
    TypeName    = @(
                    'Microsoft.Powershell.Utility.FileHash'         # v5
                    'Microsoft.PowerShell.Commands.FileHashInfo'    # v7
                )[(Get-MyPSVersionIndex)]
}
Update-TypeData @paramSet -MemberType ScriptProperty -MemberName Base64 -Value {
    return $this.Hash.HexStringToBase64()
}
Update-TypeData @paramSet -MemberType ScriptMethod -MemberName GetCaption -Value {
    return $this.Algorithm + ': ' + $this.Hash.ToLower()
}
Update-TypeData @paramSet -MemberType ScriptMethod -MemberName GetCaptionByBase64 -Value {
    return $this.Algorithm + ': ' + $this.Base64
}

Remove-Variable -Name paramSet
