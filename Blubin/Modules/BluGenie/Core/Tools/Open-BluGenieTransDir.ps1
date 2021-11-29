#region Open-BluGenieTransDir (Function)
    Function Open-BluGenieTransDir
    {
        <#
            .SYNOPSIS
                Open-BluGenieTransDir is a quick way to open up the current $TranscriptsDir from the Console
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('TransDir','OTD','Open-TransDir')]
        [OutputType([String])]
        Param
        (
        )

        If
        (
            $(Test-Path -Path $TranscriptsDir -ErrorAction SilentlyContinue)
        )
        {
            Start-Process -FilePath $TranscriptsDir -ErrorAction SilentlyContinue
        }
    }
#endregion Open-BluGenieTransDir (Function)