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
        Get-Command -Name $Name -Syntax
        $retVals = Get-Help -Name $Name |
            Select-Object -ExpandProperty returnValues -ErrorAction Ignore
        if ($retVals -ne $nul)
        {
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
    (Get-Host).UI.RawUI.WindowTitle
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

    if ($PSVersionTable.PSVersion.Major -le 5)
    {
        $headByte = Get-Content -Path $FilePath -Encoding Byte -Head 1
        $tailByte = Get-Content -Path $FilePath -Encoding Byte -Tail 1
    }
    else
    {
        $headByte = Get-Content -Path $FilePath -AsByteStream -Head 1
        $tailByte = Get-Content -Path $FilePath -AsByteStream -Tail 1
    }

    $MyPSNotes = [PSCustomObject]@{
        RawPath = $FilePath
        HeadByte = $headByte
        TailByte = $tailByte
        Hash = @{
            $HashAlgorithm = $fileHash.Hash.ToLower()
        }
    }

    Add-Member -InputObject $fileInfo -NotePropertyName MyPSNotes -NotePropertyValue $MyPSNotes

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

Set-Alias -Name ver     -Value Get-MyPSVersionString
Set-Alias -Name pd      -Value Move-MyPSCurrentDirectory
Set-Alias -Name syntax  -Value Get-MyPSCommandSyntax
Set-Alias -Name src     -Value Get-MyPSScriptBlock
Set-Alias -Name source  -Value Get-MyPSScriptBlock
Set-Alias -Name tt      -Value Set-MyPSWindowTitle
