#region Set-BluGenieServiceJob (Function)
Function Set-BluGenieServiceJob {
    <#
        .SYNOPSIS
            Set-BluGenieServiceJob is an add-on to manage the ServiceJob Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieServiceJob is an add-on to manage the ServiceJob status in the BluGenie Console.

            Send the artifact to the remote machine to be run by the BluGenie Service.
            Note: This will only work if the BluGenie service is running
                    If not, the artifact will fallback to the remote connection execution process.

        .PARAMETER SetTrue
            Description: Enable ServiceJob
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Disable ServiceJob
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieServiceJob
            Description: Toggle the ServiceJob setting (True to False or False to True)
            Notes:

        .EXAMPLE
            Command: Set-BluGenieServiceJob -SetTrue
            Description: Enable ServiceJob
            Notes:

        .EXAMPLE
            Command: Set-BluGenieServiceJob -SetFalse
            Description: Disable ServiceJob
            Notes:

        .EXAMPLE
            Command: Set-BluGenieServiceJob -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieServiceJob -WalkThrough
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
        [Alias('Set-BGServiceJob','SetServiceJob', 'ServiceJob')]
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
                    $Global:BGServiceJob = $False

                    break
                }

                {$SetTrue} {
                    $Global:BGServiceJob = $True

                    break
                }

                {$Toggle} {
                    If (-not $Global:BGServiceJob) {
                        $Global:BGServiceJob = $False
                    }

                    Switch ($Global:BGServiceJob.ToString()) {
                        'True' {
                            $Global:BGServiceJob = $False

                            break
                        }

                        'False' {
                            $Global:BGServiceJob = $True

                            break
                        }

                        Default {
                            $Global:BGServiceJob = $False
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetServiceJobText = "$Global:BGServiceJob".PadRight(25,' ') + "|| `t"
            $SetServiceJobMsg = '..ServiceJob Value..'
            write-host -NoNewline $("`n{0}" -f $SetServiceJobText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetServiceJobMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
    #endregion Set-BluGenieServiceJob (Function)