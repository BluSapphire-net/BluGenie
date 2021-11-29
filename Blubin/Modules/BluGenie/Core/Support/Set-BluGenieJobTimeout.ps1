#region Set-BluGenieJobTimeout (Function)
Function Set-BluGenieJobTimeout {
<#
    .SYNOPSIS
        Set-BluGenieJobTimeout is an add-on to manage the Job Timeout in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieJobTimeout is an add-on to manage the Job Timeout in the BluGenie Console.

        Being able to invoke multiple runspaces at once allows BluGenie the ability to run code inside of each runspace independent of the others.
        This option will set the timeout value for each job.  If that time value is ever reached, the job will exit and return a timeout error.

    .PARAMETER Timeout
        Description: Job Timeout value
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Remove
        Description: Remove the current value
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieJobTimeout '5'
        Description: Set Job Timeout
        Notes: The Timeout is an [Int]

    .EXAMPLE
        Command: Set-BluGenieJobId -Timeout '160'
        Description: Set Job Timeout using the default command name while using the Timeout parameter
        Notes: The Timeout is an [Int]

    .EXAMPLE
        Command: Set-JobTimeout -Timeout '30'
        Description: Set Job Timeout using the Alias command name while using the Job Timeout parameter
        Notes: The Timeout is an [Int]

    .EXAMPLE
        Command: Set-BluGenieJobTimeout -Reset
        Description: Reset the Job Timeout to 120 minutes
        Notes:

    .EXAMPLE
        Command: Set-BluGenieJobId -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Set-BluGenieJobId -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.06.0201
        * Latest Author             :
        * Latest Build Version      :
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            :
        * Link                      :
            ~
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 20.06.0201: * [Michael Arroyo] Posted
#>
    [cmdletbinding()]
    [Alias('Set-JobTimeout','JobTimeout')]
    Param
    (
        [Parameter(Position=0)]
        [Int]$Timeout,

        [Switch]$Reset,

        [Alias('Help')]
        [Switch]$Walkthrough
    )

    #region WalkThrough (Dynamic Help)
        If ($Walkthrough) {
            If ($($PSCmdlet.MyInvocation.InvocationName)) {
                $Function = $($PSCmdlet.MyInvocation.InvocationName)
            } Else {
                If ($Host.Name -match 'ISE') {
                    $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            }

            If (Get-Command | Select-Object -Property Invoke-WalkThrough) {
                If ($Function -eq 'Invoke-WalkThrough') {
                    #Disable Invoke-WalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                    Return
                } Else {
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                    Return
                }
            } Else {
                Get-Help -Name $Function -Full
                Return
            }
        }
    #endregion WalkThrough (Dynamic Help)

    #region Main
        Switch ($null) {
            #region Reset value
                {$Reset} {
                    [Int]$Global:ConsoleJobTimeout = 120
                    $ConsoleJobTimeoutText = "Job Timeout".PadRight(40,' ') + "|| `t"
                    $ConsoleJobTimeoutMsg = '..Reset..'
                    Write-host -NoNewline $("`n{0}" -f $ConsoleJobTimeoutText) -ForegroundColor Yellow
                    Write-Host -NoNewline $ConsoleJobTimeoutMsg -ForegroundColor Green
                    Write-Host "`n"

                    Break
                }
            #endregion Remove value

            #region Default
                Default {
                    If (-Not $Timeout) {
                        $ConsoleJobTimeoutText = "Job Timeout Value".PadRight(40,' ') + "|| `t"
                        $ConsoleJobTimeoutMsg = $('..Not Set..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleJobTimeoutText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleJobTimeoutMsg -ForegroundColor Red
                        Write-Host "`n"
                    } Else {
                        $ConsoleJobTimeoutText = "$Timeout".PadRight(40,' ') + "|| `t"
                        $ConsoleJobTimeoutMsg = '..Updated Job Timeout..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleJobTimeoutText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleJobTimeoutMsg -ForegroundColor Green
                        Write-Host "`n"
                        [String]$Global:ConsoleJobTimeout = $Timeout
                    }
                }
            #endregion Default
        }
    #endregion Main
}
#endregion Set-BluGenieJobTimeout (Function)