#region Set-BluGenieDebugger (Function)
Function Set-BluGenieDebugger {
<#
    .SYNOPSIS
        Set-BluGenieDebugger is an add-on to manage the Debugger Status in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieDebugger is an add-on to manage the Debugger status in the BluGenie Console.

        Debugger will enable logging of the BluGenie debug information to $env:SystemDrive\Windows\Temp\BluGenieDebug.txt
        Data includes:
            o The the BluGenie Arguments passed to this host
            o The current BluGenie Module Path
            o The Current PowerShell Execution Policy
            o All System, Current Session, and Current Script Variables

    .PARAMETER SetTrue
        Description: Enable debugging
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER SetFalse
        Description: Disable debugging
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieDebugger
        Description: Toggle the Debugger setting (True to False or False to True)
        Notes:

    .EXAMPLE
        Command: Set-BluGenieDebugger -SetTrue
        Description: Enable debugging
        Notes:

    .EXAMPLE
        Command: Set-BluGenieDebugger -SetFalse
        Description: Disable debugging
        Notes:

    .EXAMPLE
        Command: Set-BluGenieDebugger -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Set-BluGenieDebugger -WalkThrough
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
    [Alias('Set-Debug','SetDebug')]
    Param
    (
        [Switch]$SetTrue,

        [Switch]$SetFalse,

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
        $Toggle = $False
        If ($(-Not $SetTrue) -and $(-Not $SetFalse)) {
            $Toggle = $true
        }

        Switch ($null) {
            {$SetFalse} {
                $Global:ConsoleDebug = $False
                $Global:BGDebugger = $False

                break
            }

            {$SetTrue} {
                $Global:ConsoleDebug = $True
                $Global:BGDebugger = $True

                break
            }

            {$Toggle} {
                If (-not $Global:ConsoleDebug) {
                    $Global:ConsoleDebug = $false
                    $Global:BGDebugger = $False
                }

                Switch ($Global:ConsoleDebug.ToString()) {
                    'True' {
                        $Global:ConsoleDebug = $False
                        $Global:BGDebugger = $False

                        break
                    }

                    'False' {
                        $Global:ConsoleDebug = $True
                        $Global:BGDebugger = $True

                        break
                    }

                    Default {
                        $Global:ConsoleDebug = $False
                        $Global:BGDebugger = $False
                    }
                }
            }
        }
    #endregion Main

    #region Output
        $SetTrappingText = "$Global:ConsoleDebug".PadRight(25,' ') + "|| `t"
        $SetTrappingMsg = '..Trap Value..'
        write-host -NoNewline $("`n{0}" -f $SetTrappingText) -ForegroundColor Yellow
        Write-Host -NoNewline $SetTrappingMsg -ForegroundColor Green

        Write-Host "`n"
    #endregion Output
}
#endregion Set-BluGenieDebugger (Function)