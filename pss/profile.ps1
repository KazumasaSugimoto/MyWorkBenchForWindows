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
        [switch]
        $NeedPathLength,
        [switch]
        $TsvFormat
    )

    $folderInfo = Get-Item -LiteralPath $FolderPath -Force

    if ($folderInfo.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { return }
    if (-not ($folderInfo.Attributes -band [System.IO.FileAttributes]::Directory)) { return }

    Get-ChildItem -LiteralPath $FolderPath -Force |
        ForEach-Object {
            if ($_.Attributes -band [System.IO.FileAttributes]::Directory)
            {
                $paramSet = @{
                    FolderPath      = $_.FullName
                    NeedPathLength  = $NeedPathLength
                    TsvFormat       = $TsvFormat
                }
                Get-MyPSFileList @paramSet
            }
            else
            {
                $pathLength = $null
                if ($NeedPathLength)
                {
                    $sjisEncoding = [System.Text.Encoding]::GetEncoding('shift_jis')
                    $pathLength = $sjisEncoding.GetByteCount($_.FullName)
                }

                if ($TsvFormat)
                {
                    Write-Output "$($_.DirectoryName)`t$($_.Name)`t$($_.Length)`t$pathLength"
                }
                else
                {
                    [PSCustomObject]@{
                        FolderPath  = $_.DirectoryName
                        FileName    = $_.Name
                        FileSize    = $_.Length
                        PathLength  = $pathLength
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
