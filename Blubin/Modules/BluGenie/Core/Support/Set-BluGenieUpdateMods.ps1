#region Set-BluGenieUpdateMods (Function)
Function Set-BluGenieUpdateMods {
    <#
        .SYNOPSIS
            Set-BluGenieUpdateMods is an add-on to manage the UpdateMods Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieUpdateMods is an add-on to manage the UpdateMods status in the BluGenie Console.

            Force all managed BluGenie files and folders to be updated on the remote machine

        .PARAMETER SetTrue
            Description: Enable UpdateMods
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable UpdateMods
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieUpdateMods
            Description: Toggle the UpdateMods setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieUpdateMods -SetTrue
            Description: Enable UpdateMods
            Notes:

        .EXAMPLE
            Command: Set-BluGenieUpdateMods -SetFalse
            Description: Disable UpdateMods
            Notes:

        .EXAMPLE
            Command: Set-BluGenieUpdateMods -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieUpdateMods -WalkThrough
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
        [Alias('Set-BGUpdateMods','SetUpdateMods', 'UpdateMods')]
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
                    $Global:BGUpdateMods = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGUpdateMods = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGUpdateMods) {
                        $Global:BGUpdateMods = $False
                    }

                    Switch ($Global:BGUpdateMods.ToString()) {
                        'True' {
                            $Global:BGUpdateMods = $False

                            break
                        }

                        'False' {
                            $Global:BGUpdateMods = $True

                            break
                        }

                        Default {
                            $Global:BGUpdateMods = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetUpdateModsText = "$Global:BGUpdateMods".PadRight(25,' ') + "|| `t"
            $SetUpdateModsMsg = '..UpdateMods Value..'
            write-host -NoNewline $("`n{0}" -f $SetUpdateModsText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetUpdateModsMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieUpdateMods (Function)