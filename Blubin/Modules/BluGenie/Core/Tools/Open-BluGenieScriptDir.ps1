#region Open-BluGenieScriptDir (Function)
    Function Open-BluGenieScriptDir
    {
        <#
            .SYNOPSIS
                Open-BluGenieScriptDir is a quick way to open up the current $ScriptDirectory from the Console
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('ScriptDir','OSD','Open-ScriptDir')]
        [OutputType([String])]
        Param
        (
        )

        If
        (
            $(Test-Path -Path $ScriptDirectory -ErrorAction SilentlyContinue)
        )
        {
            Start-Process -FilePath $ScriptDirectory -ErrorAction SilentlyContinue
        }
    }
#endregion Open-BluGenieScriptDir (Function)