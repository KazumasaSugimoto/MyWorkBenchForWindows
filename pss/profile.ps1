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
        $Parameter = ''
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
        $retVals = Get-Help -Name $Name |
            Select-Object -ExpandProperty returnValues -ErrorAction Ignore
        if ($retVals -ne $nul)
        {
            Write-Output "`nReturnValues:"
            Write-Output $retVals
        }
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

    $fileInfo = Get-Item -Path $FilePath
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
