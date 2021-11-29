#region Get-BluGenieHostingVersion (Function)
    Function Get-BluGenieHostingVersion
    {
        <#
            .SYNOPSIS
                Show Hosting Shell Version Information

            .EXAMPLE
                BluGenie Shell: Get-BluGenieHostingVersion

                Command Line: BluGenie.exe "Get-BluGenieHostingVersion"

                This will display the hosting shell version information
        #>
        [CmdletBinding(ConfirmImpact='Low')]
        [Alias('Version','Ver','Get-HostingVersion')]
        [OutputType([String])]
        Param
        (
        )

        $PSVerStr = $('Hosting Version: {0}' -f $PSVersionTable.PSVersion.ToString())
        $BGVerStr = $('BGConLib: {0}' -f $LibVersion)

        Write-Host $("`n{0}" -f $PSVerStr) -ForegroundColor Green
        Write-Host $("{0}`n" -f $BGVerStr) -ForegroundColor Green

        #$PSVerStr | Out-File -FilePath $TranscriptsFile -Append
        #$BGVerStr | Out-File -FilePath $TranscriptsFile -Append
    }
#endregion Get-BluGenieHostingVersion (Function)