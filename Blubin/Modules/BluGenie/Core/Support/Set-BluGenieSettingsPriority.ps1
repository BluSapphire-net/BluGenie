#region Set-BluGenieSettingsPriority (Function)
Function Set-BluGenieSettingsPriority {
    <#
        .SYNOPSIS
            Set-BluGenieSettingsPriority is an add-on to manage the Process Priority Status in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieSettingsPriority is an add-on to manage the Process Priority Status in the BluGenie Console.

            Select the priority level of the cuurent job.
                0 = Low
                1 = Below Normal
                2 = Normal
                3 = Above Normal
                4 = High
                5 = Realtime

        .PARAMETER Priority
            Description:  Select the priority level of the cuurent job.
            Notes:  0 = Low
                    1 = "Below Normal"
                    2 = Normal
                    3 = "Above Normal"
                    4 = High
                    5 = Realtime
            Alias:
            ValidateSet: '0','Low','1','Below Normal','2','Normal','3','Above Normal','4','High','5','Realtime'

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieSettingsPriority -Priority 4
            Description: Set the current BluGenie Job to [High] using and Int
            Notes:

        .EXAMPLE
            Command: Set-BluGenieSettingsPriority -Priority Realtime
            Description: Set the current BluGenie Job to [Realtime] using a String
            Notes:

        .EXAMPLE
            Command: Set-BluGenieSettingsPriority Low
            Description: Set the current BluGenie Job to [Low] using Position 0 (No Parameter Named)
            Notes:

        .EXAMPLE
            Command: Set-BGProcessPriority Normal
            Description: Set the current BluGenie Job to [Normal] using the ShorHand BluGenie Alias
            Notes:

        .EXAMPLE
            Command: Priority Normal
            Description: Set the current BluGenie Job to [Normal] using the ShorHand Alias
            Notes:

        .EXAMPLE
            Command: Set-BluGenieSettingsPriority -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Set-BluGenieSettingsPriority -WalkThrough
            Description: Call Help Information [2]
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .OUTPUTS
            TypeName: String

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 21.11.3001
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
                ~ 21.11.3001: * [Michael Arroyo] Posted
    #>
        [cmdletbinding()]
        [Alias('Set-BGSettingsPriority','Set-SettingsPriority','Priority')]
        Param
        (
            [Parameter(Position=0)]
            [ValidateSet('0','Low','1','Below Normal','2','Normal','3','Above Normal','4','High','5','Realtime')]
            [String]$Priority,

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
            Switch ($Null) {
                {$Priority -ne $Null} {
                    Switch -Regex ($Priority) {
                        '^0$|^Low$' {
                            [Int32]$Global:BGPriority = 0
                            Break
                        }

                        '^1$|^Below Normal$' {
                            [Int32]$Global:BGPriority = 1
                            Break
                        }

                        '^2$|^Normal$' {
                            [Int32]$Global:BGPriority = 2
                            Break
                        }

                        '^3$|^Above Normal$' {
                            [Int32]$Global:BGPriority = 3
                            Break
                        }

                        '^4$|^High$' {
                            [Int32]$Global:BGPriority = 4
                            Break
                        }

                        '^5$|^Realtime$' {
                            [Int32]$Global:BGPriority = 5
                            Break
                        }
                    }

                    Write-Host 'Process Priority' -ForegroundColor Yellow
                    $SetPriorityText = "$Global:BGPriority".PadRight(25,' ') + "|| `t"
                    $SetPriorityMsg = '..Priority Value..'
                    write-host -NoNewline $("`n{0}" -f $SetPriorityText) -ForegroundColor Yellow
                    Write-Host -NoNewline $SetPriorityMsg -ForegroundColor Green

                    Write-Host "`n"
                }

                Default {
                    Write-Host 'Process Priority' -ForegroundColor Yellow
                    $SetPriorityText = "$Global:BGPriority".PadRight(25,' ') + "|| `t"
                    $SetPriorityMsg = '..Priority Value..'
                    write-host -NoNewline $("`n{0}" -f $SetPriorityText) -ForegroundColor Yellow
                    Write-Host -NoNewline $SetPriorityMsg -ForegroundColor Green

                    Write-Host "`n"
                }
            }
        #endregion Main
    }
    #endregion Set-BluGenieSettingsPriority (Function)