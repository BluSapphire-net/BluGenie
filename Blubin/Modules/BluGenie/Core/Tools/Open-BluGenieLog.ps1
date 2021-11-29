#region Open-BluGenieLog (Function)
    Function Open-BluGenieLog
    {
        <#
            .SYNOPSIS
                Open-BluGenieLog is a quick way to open up the last processed log file from the Console
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('Log','OL','Open-Log')]
        [OutputType([String])]
        Param
        (
        )

        If
        (
            $(Test-Path -Path $curLogfile -ErrorAction SilentlyContinue)
        )
        {
            Start-Process -FilePath $curLogfile -ErrorAction SilentlyContinue
        }
        Else
        {
            Write-Host 'There are no log files for this session.  Please run a job and try again' -ForegroundColor White
        }
    }
#endregion Open-BluGenieLog (Function)