function prompt {

#   "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
    "PS $($executionContext.SessionState.Path.CurrentLocation)`n> ";

}

function Get-MyPSVersionString {

<#
    .SYNOPSIS
        Put PSVersion String.
#>

    $PSVersionTable.PSVersion.ToString()

}

function Move-MyPSCurrentDirectory {

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

function Get-MyPSCommandSyntax {

<#
    .SYNOPSIS
        put command syntax.
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
            $Name = $result.ResolvedCommandName
        }
    }
    Get-Command -Name $Name -Syntax

}

function Get-MyPSScriptBlock {

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
            Select-Object -InputObject $result -ExpandProperty ScriptBlock
        }
    }

}

Set-Alias -Name ver     -Value Get-MyPSVersionString
Set-Alias -Name pd      -Value Move-MyPSCurrentDirectory
Set-Alias -Name syntax  -Value Get-MyPSCommandSyntax
Set-Alias -Name src     -Value Get-MyPSScriptBlock
Set-Alias -Name source  -Value Get-MyPSScriptBlock
