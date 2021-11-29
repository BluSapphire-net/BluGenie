#region Set-BluGenieNoExit (Function)
Function Set-BluGenieNoExit {
    <#
        .SYNOPSIS
            Set-BluGenieNoExit is an add-on to manage the NoExit Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieNoExit is an add-on to manage the NoExit status in the BluGenie Console.

            Setting this option will stay in the Console after executing an automated Job or command from the CLI.

        .PARAMETER SetTrue
            Description: Enable NoExit
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable NoExit
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieNoExit
            Description: Toggle the NoExit setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoExit -SetTrue
            Description: Enable NoExit
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoExit -SetFalse
            Description: Disable NoExit
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoExit -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieNoExit -WalkThrough
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
        [Alias('Set-BGNoExit','SetNoExit', 'NoExit')]
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
                    $Global:BGNoExit = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGNoExit = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGNoExit) {
                        $Global:BGNoExit = $False
                    }

                    Switch ($Global:BGNoExit.ToString()) {
                        'True' {
                            $Global:BGNoExit = $False

                            break
                        }

                        'False' {
                            $Global:BGNoExit = $True

                            break
                        }

                        Default {
                            $Global:BGNoExit = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetNoExitText = "$Global:BGNoExit".PadRight(25,' ') + "|| `t"
            $SetNoExitMsg = '..NoExit Value..'
            write-host -NoNewline $("`n{0}" -f $SetNoExitText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetNoExitMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieNoExit (Function)