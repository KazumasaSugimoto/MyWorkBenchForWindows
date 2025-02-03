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

Set-Alias -Name ver -Value Get-MyPSVersionString
Set-Alias -Name pd  -Value Move-MyPSCurrentDirectory
