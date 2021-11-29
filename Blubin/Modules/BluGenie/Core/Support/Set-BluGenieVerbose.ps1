#region Set-BluGenieVerbose (Function)
Function Set-BluGenieVerbose {
    <#
        .SYNOPSIS
            Set-BluGenieVerbose is an add-on to manage the Verbose Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieVerbose is an add-on to manage the Verbose status in the BluGenie Console.

            Verbose is used to display Time Stamped Messages to the screen. You can view overall progress, elapsed time from one message to the
            next.

        .PARAMETER SetTrue
            Description: Enable Verbose
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable Verbose
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieVerbose
            Description: Toggle the Verbose setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieVerbose -SetTrue
            Description: Enable Verbose
            Notes:

        .EXAMPLE
            Command: Set-BluGenieVerbose -SetFalse
            Description: Disable Verbose
            Notes:

        .EXAMPLE
            Command: Set-BluGenieVerbose -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieVerbose -WalkThrough
            Description: Call Help Information [2]
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .OUTPUTS
            TypeName: String

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 21.11.1801
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
                ~ 21.11.1801: * [Michael Arroyo] Posted
    #>
        [cmdletbinding()]
        [Alias('Set-BGVerbose','SetVerbose', 'Verbose')]
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
                    $Global:BGVerbose = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGVerbose = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGVerbose) {
                        $Global:BGVerbose = $False
                    }

                    Switch ($Global:BGVerbose.ToString()) {
                        'True' {
                            $Global:BGVerbose = $False

                            break
                        }

                        'False' {
                            $Global:BGVerbose = $True

                            break
                        }

                        Default {
                            $Global:BGVerbose = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetVerboseText = "$Global:BGVerbose".PadRight(25,' ') + "|| `t"
            $SetVerboseMsg = '..Verbose Value..'
            write-host -NoNewline $("`n{0}" -f $SetVerboseText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetVerboseMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieVerbose (Function)