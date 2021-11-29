#region Set-BluGenieNoSetRes (Function)
Function Set-BluGenieNoSetRes {
    <#
        .SYNOPSIS
            Set-BluGenieNoSetRes is an add-on to manage the NoSetRes Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieNoSetRes is an add-on to manage the NoSetRes status in the BluGenie Console.

            Set the NoSetRes value so to not update the frame of the Console.  Use the OS's default command prompt size.
            If this option is set to True, the Console Windows Frame will be adjusted to better fit the Verbose Messaging.

        .PARAMETER SetTrue
            Description: Enable NoSetRes
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable NoSetRes
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieNoSetRes
            Description: Toggle the NoSetRes setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoSetRes -SetTrue
            Description: Enable NoSetRes
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoSetRes -SetFalse
            Description: Disable NoSetRes
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoSetRes -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieNoSetRes -WalkThrough
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
        [Alias('Set-BGNoSetRes','SetNoSetRes', 'NoSetRes')]
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
                    $Global:BGNoSetRes = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGNoSetRes = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGNoSetRes) {
                        $Global:BGNoSetRes = $False
                    }

                    Switch ($Global:BGNoSetRes.ToString()) {
                        'True' {
                            $Global:BGNoSetRes = $False

                            break
                        }

                        'False' {
                            $Global:BGNoSetRes = $True

                            break
                        }

                        Default {
                            $Global:BGNoSetRes = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetNoSetResText = "$Global:BGNoSetRes".PadRight(25,' ') + "|| `t"
            $SetNoSetResMsg = '..NoSetRes Value..'
            write-host -NoNewline $("`n{0}" -f $SetNoSetResText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetNoSetResMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieNoSetRes (Function)