#region Open-BluGenieLogDir (Function)
    Function Open-BluGenieLogDir
    {
        <#
            .SYNOPSIS
                Open-BluGenieLogDir is a quick way to open up the last processed log directory from the Console
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('LogDir','OLD','Open-LogDir')]
        [OutputType([String])]
        Param
        (
        )

        If
        (
            $(Test-Path -Path $CurLogDirectory -ErrorAction SilentlyContinue)
        )
        {
            Start-Process -FilePath $CurLogDirectory -ErrorAction SilentlyContinue
        }
        Else
        {
            Write-Host 'There is no log directory currently for this session.  Please run a job and try again' -ForegroundColor White
        }
    }
#endregion Open-BluGenieLogDir (Function)