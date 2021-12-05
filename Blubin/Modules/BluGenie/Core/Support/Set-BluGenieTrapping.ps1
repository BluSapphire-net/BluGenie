#region Set-BluGenieTrapping (Function)
    Function Set-BluGenieTrapping {
        <#
        .SYNOPSIS
            Set-BluGenieTrapping is an add-on to control Remote Host log trapping in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieTrapping is an add-on to control Remote Host log trapping in the BluGenie Console.

            Trap information is captured to both a file and the Event Log.
                o FilePath = <$env:SystemDrive>\Windows\Temp\BG<$JobID>-<$PID>-<10_Digit_GUID>.log
                o Event Info:
                    ~ EventLogName = 'Application'
                    ~ Source = 'BluGenie'
                    ~ EntryType = 'Information'
                    ~ EventID = 7114
                o Data captured using Posh 2
                    ~ Data will be logged using ConvertTo-Xml -as String
                o Data captured using Posh 3 and Above
                    ~ Data will be logged using ConvertTo-JSON

            Information Trapped:
                o JobID
                o Hostname
                o Commands
                o ParallelCommands
                o PostCommands
                o FullDumpPath

            Command Alias:
                o Set-BGTrap
                o SetTrap
                o Trap (For Help Only - "Trap" is a Posh Built-In Command)

        .PARAMETER SetTrue
            Description: Set Trapping Information Flag to $true
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER SetFalse
            Description: Set Trapping Information Flag to $false
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description: An automated process to walk through the current function and all the parameters
            Notes:
            Alias:
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieTrapping
            Description: This will toggle the Trap indicator from (True to False) or (False to True)
            Notes:
            Output:

        .EXAMPLE
            Command: Set-BluGenieTrapping -SetTrue
            Description: This will set the Trap indicator to True
            Notes:
            Output:

        .EXAMPLE
            Command: Set-BluGenieTrapping -SetFalse
            Description: This will set the Trap indicator to False
            Notes:
            Output:

        .OUTPUTS
                TypeName: System.String

        .NOTES
            * Original Author           : Michael Arroyo
            * Original Build Version    : 1908.2201
            * Latest Author             :
            * Latest Build Version      :
            * Comments                  :
            * Dependencies              :
                ~
            * Build Version Details     :
                ~ 1908.2201: * [Michael Arroyo] Posted
        #>

        [CmdletBinding(ConfirmImpact='Medium')]
        [Alias('Set-BGTrap','SetTrap','Trap')]
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
            Switch ($null) {
                {$SetFalse -eq $true} {
                    $Global:ConsoleTrap = $False
                    break
                }

                {$SetTrue -eq $True} {
                    $Global:ConsoleTrap = $true
                    break
                }

                Default {
                    If (-Not $Global:ConsoleTrap) {
                        $Global:ConsoleTrap = $false
                    }

                    Switch ($Global:ConsoleTrap.ToString()) {
                        'True' {
                            $Global:ConsoleTrap = $False
                            break
                        }

                        'False' {
                            $Global:ConsoleTrap = $true
                        }
                    }
                }
            }
        #endregion Main

        #region Output
            $SetTrappingText = "$Global:ConsoleTrap".PadRight(25,' ') + "|| `t"
            $SetTrappingMsg = '..Trap Value..'
            write-host -NoNewline $("`n{0}" -f $SetTrappingText) -ForegroundColor Yellow
            Write-Host -NoNewline $SetTrappingMsg -ForegroundColor Green

            Write-Host "`n"
        #endregion Output
    }
#endregion Set-BluGenieTrapping (Function)