#region Set-BluGenieNoBanner (Function)
Function Set-BluGenieNoBanner {
    <#
        .SYNOPSIS
            Set-BluGenieNoBanner is an add-on to manage the NoBanner Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieNoBanner is an add-on to manage the NoBanner status in the BluGenie Console.

            Do not display the BluGenie Welcome Screen.

            Note: This option is set to $false by default.
                    This is only valid when using it in an automated job / artifact.

        .PARAMETER SetTrue
            Description: Enable NoBanner
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable NoBanner
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieNoBanner
            Description: Toggle the NoBanner setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoBanner -SetTrue
            Description: Enable NoBanner
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoBanner -SetFalse
            Description: Disable NoBanner
            Notes:

        .EXAMPLE
            Command: Set-BluGenieNoBanner -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieNoBanner -WalkThrough
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
        [Alias('Set-BGNoBanner','SetNoBanner', 'NoBanner')]
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
                    $Global:BGNoBanner = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGNoBanner = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGNoBanner) {
                        $Global:BGNoBanner = $False
                    }

                    Switch ($Global:BGNoBanner.ToString()) {
                        'True' {
                            $Global:BGNoBanner = $False

                            break
                        }

                        'False' {
                            $Global:BGNoBanner = $True

                            break
                        }

                        Default {
                            $Global:BGNoBanner = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetNoBannerText = "$Global:BGNoBanner".PadRight(25,' ') + "|| `t"
            $SetNoBannerMsg = '..NoBanner Value..'
            write-host -NoNewline $("`n{0}" -f $SetNoBannerText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetNoBannerMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieNoBanner (Function)