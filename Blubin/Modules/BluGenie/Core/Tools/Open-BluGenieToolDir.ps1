#region Open-BluGenieToolDir (Function)
    Function Open-BluGenieToolDir
    {
        <#
            .SYNOPSIS
                Open-BluGenieToolDir is a quick way to open up the current Tools Directory from the Console
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('ToolsDir','OTools','Open-ToolDir')]
        [OutputType([String])]
        Param
        (
        )

        If
        (
            $(Test-Path -Path $('{0}\Tools' -f $ScriptDirectory) -ErrorAction SilentlyContinue)
        )
        {
            Start-Process -FilePath $('{0}\Tools' -f $ScriptDirectory) -ErrorAction SilentlyContinue
        }
        Else
        {
            Write-Host 'There are no tools associated with this session.' -ForegroundColor White
        }
    }
#endregion Open-BluGenieToolDir (Function)