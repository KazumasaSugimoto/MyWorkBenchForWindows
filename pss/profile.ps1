function prompt {

#   "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
    "PS $($executionContext.SessionState.Path.CurrentLocation)`n> ";

}

function ver {

<#
    .SYNOPSIS
        Put PSVersion String.
#>

    $PSVersionTable.PSVersion.ToString()

}

function pd {

<#
    .SYNOPSIS
        pushd/popd helper.
#>

    param
    (
        [String]$Path = ''
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
