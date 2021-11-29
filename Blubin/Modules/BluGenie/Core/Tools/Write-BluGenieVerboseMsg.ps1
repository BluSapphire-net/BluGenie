#region Write-BluGenieVerboseMsg (Function)
function Write-BluGenieVerboseMsg
{
<#
    .SYNOPSIS
        Write-BluGenieVerboseMsg is used to display Time Stamped, Verbose Messages to the screen

    .DESCRIPTION
        Write-BluGenieVerboseMsg is used to display Time Stamped, Verbose Messages to the screen

        You can view overall progress, elapsed time from one message to the next, change color and even check for an existing flag before displaying the message.

    .PARAMETER Message
        Description: Message to display
        Notes:  
        Alias: Msg
        ValidateSet:  

    .PARAMETER Color
        Description: Select the Color of the output
        Notes: Default value is ( White )
        Alias: 
        ValidateSet: 'Black','Blue','Cyan','DarkBlue','DarkCyan','DarkGray','DarkGreen','DarkMagenta','DarkRed','DarkYellow','Gray','Green','Magenta','Red','White','Yellow'

    .PARAMETER Status
        Description: Set the type of Message 
        Notes: The elapsed time from one message to another depends on what Status type you select. The default value is '....' for generic, continued messaging 
        Alias:
        ValidateSet: 'StopTimer','StartTimer','....','StartTask','StopTask'

    .PARAMETER CheckFlag
        Description: CheckFlag will allow you to check to see if another variable is either True/False or Exists/Not Exists.
        Notes: This will allow you to show messages based on another set action.
        Alias:
        ValidateSet: 

    .PARAMETER ClearTimers
        Description: Clear the global tracking time stamps 
        Notes:  
        Alias:
        ValidateSet: 

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: $null = Write-BluGenieVerboseMsg -ClearTimers
        Description: Clear global tracking time stamps
        Notes: If you don't pass it to $null you will get a $true/$false when the process has ran

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Message "Starting" -Color 'Yellow' -Status 'StartTimer' -CheckFlag MyVerboseParam
        Description: Setup the 1st overall message and timestamp with a message in Yellow, only if MyVerboseParam variable either (Exists or is $true)
        Notes: If -CheckFlag is used the variable name (not the variable - no dollar sign) needs to be set.  If the variable is true or exists the message will show, 
               if the variable is either false or doesn't exists the message will not show

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Msg "Running a Sub Task" -Color 'Cyan' -Status 'StartTask'
        Description: Start a new timestamp track, with a message in Cyan
        Notes: 

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Msg "Just another message" -Color 'White' -Status '....'
        Description: Send a generic message in White, elasped time is based on the last StartTask Timestamp
        Notes: 

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Msg "Just another message 2" -Color 'White' -Status '....'
        Description: Send a 2nd generic message in White, elasped time is based on the last StartTask Timestamp
        Notes: 

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Message "Stopping Sub Task" -Color 'Yellow' -Status 'StopTask'
        Description: Stop and Reset the timestamp block, and display a message in Yellow
        Notes: 

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Msg "Stopping" -Color 'Yellow' -Status 'StopTimer' -CheckFlag MyVerboseParam
        Description: Stop and Reset the timestamp block, remove all global time stamps, and display a message in Yellow, only if MyVerboseParam variable either (Exists or is $true)
        Notes: If -CheckFlag is used the variable name (not the variable - no dollar sign) needs to be set.  If the variable is true or exists the message will show, 
               if the variable is either false or doesn't exists the message will not show

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Write-BluGenieVerboseMsg -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1911.1201
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Dynamic Help Function
        * Build Version Details     :
                                        ~ 1911.1201: * [Michael Arroyo] Posted
                                                    
#>
    [Alias('Write-VerboseMsg')]
    param
    (
        [Parameter(ValueFromPipeline=$true,
                   Position=0)]
        [string]$Message,

        [ValidateSet('Black','Blue','Cyan','DarkBlue','DarkCyan','DarkGray','DarkGreen','DarkMagenta','DarkRed','DarkYellow','Gray','Green','Magenta','Red','White','Yellow')]
        [string]$Color = 'White',

        [ValidateSet('StopTimer','StartTimer','....','StartTask','StopTask')]
        [string]$Status = "....",

        [string]$CheckFlag,

        [switch]$ClearTimers,

        [Alias('Help')]
        [switch]$Walkthrough
    )

    #region WalkThrough (Dynamic Help)
        If
        (
            $Walkthrough
        )
        {
            If
            (
                $($PSCmdlet.MyInvocation.InvocationName)
            )
            {
                $Function = $($PSCmdlet.MyInvocation.InvocationName)
            }
            Else
            {
                If
                (
                    $Host.Name -match 'ISE'
                )
                {
                    $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            }

            If
            (
                Test-Path -Path Function:\Invoke-WalkThrough -ErrorAction SilentlyContinue
            )
            {
                If
                (
                    $Function -eq 'Invoke-WalkThrough'
                )
                {
                    #Disable Invoke-WalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                    Return
                }
            }
            Else
            {
                Get-Help -Name $Function -Full
                Return
            }
        }
    #endregion WalkThrough (Dynamic Help)

    #region Clear Global Timers
        If
        (
            $ClearTimers
        )
        {
            $Global:GlobalVerboseMsgStart = $null
            $Global:GlobalVerboseMsgNext = $null
            $Global:GlobalVerboseMsgStop = $null

            Return $($true)
        }
    #endregion Clear Global Timers

    #region Msg Parameter Check
        If
        (
            -Not $Message
        )
        {
            Return
        }
    #endregion Msg Parameter Check

    #region Check an existing flag / variable before processing message
        If
        (
            $CheckFlag
        )
        {
            If
            (
                -Not $(Get-Item -Path $('Variable:\{0}' -f $CheckFlag) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value)
            )
            {
                Return
            }
        }
    #endregion Check an existing flag / variable before processing message

    #region Main
        #region Set Global Start
            If
            (
                -Not $Global:GlobalVerboseMsgStart
            )
            {
                $Global:GlobalVerboseMsgStart = Get-Date
            }
        #endregion Set Global Start

        #region Process Message
            Switch
            (
                $Status
            )
            {
                'StartTimer'
                { 
                    $Global:GlobalVerboseMsgStart = Get-Date
                    $Global:GlobalVerboseMsgNext = Get-Date
                    $Timer1 = $Global:GlobalVerboseMsgStart.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer2 = $Global:GlobalVerboseMsgNext.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer3 = $(New-TimeSpan -Start $Global:GlobalVerboseMsgStart -End $Global:GlobalVerboseMsgNext -ErrorAction SilentlyContinue).ToString() -replace '(.*\.\d\d).*','$1'
                    Write-Host $("[{0}]|[{1}]|[{2}]`t-`t [{3}]`t- {4}" -f $Timer1,$Timer2,$Timer3, $Status, $Message) -ForegroundColor $Color
                    break
                }
                
                'StopTimer'
                { 
                    $VerboseMsgStopTimer = Get-Date
                    $Timer1 = $Global:GlobalVerboseMsgStart.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer2 = $VerboseMsgStopTimer.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer3 = $(New-TimeSpan -Start $Global:GlobalVerboseMsgStart -End $VerboseMsgStopTimer -ErrorAction SilentlyContinue).ToString() -replace '(.*\.\d\d).*','$1'
                    Write-Host $("[{0}]|[{1}]|[{2}]`t-`t [{3}]`t- {4}" -f $Timer1,$Timer2,$Timer3, $Status, $Message) -ForegroundColor $Color

                    $Global:GlobalVerboseMsgStart = $null
                    $Global:GlobalVerboseMsgNext = $null
                    $Global:GlobalVerboseMsgStop = $null
                    break
                }
                
                'StartTask'
                {
                    If
                    (
                        -Not $Global:GlobalVerboseMsgNext
                    )
                    {
                        $Global:GlobalVerboseMsgNext = Get-Date
                    }

                    $VerboseMsgNowTimer = Get-Date
                    
                    $Timer1 = $Global:GlobalVerboseMsgNext.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer2 = $VerboseMsgNowTimer.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer3 = $(New-TimeSpan -Start $Global:GlobalVerboseMsgNext -End $VerboseMsgNowTimer -ErrorAction SilentlyContinue).ToString() -replace '(.*\.\d\d).*','$1'
                    Write-Host $("[{0}]|[{1}]|[{2}]`t-`t [{3}]`t- {4}" -f $Timer1,$Timer2,$Timer3, $Status, $Message) -ForegroundColor $Color
                    break
                }
                
                'StopTask'
                { 
                    If
                    (
                        -Not $Global:GlobalVerboseMsgNext
                    )
                    {
                        $Global:GlobalVerboseMsgNext = Get-Date
                    }
                    $Global:GlobalVerboseMsgStop = Get-Date
                    
                    $Timer1 = $Global:GlobalVerboseMsgNext.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer2 = $Global:GlobalVerboseMsgStop.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer3 = $(New-TimeSpan -Start $Global:GlobalVerboseMsgNext -End $Global:GlobalVerboseMsgStop -ErrorAction SilentlyContinue).ToString() -replace '(.*\.\d\d).*','$1'
                    Write-Host $("[{0}]|[{1}]|[{2}]`t-`t [{3}]`t- {4}" -f $Timer1,$Timer2,$Timer3, $Status, $Message) -ForegroundColor $Color

                    $Global:GlobalVerboseMsgNext = $null
                    $Global:GlobalVerboseMsgStop = $null
                    break
                }

                Default
                {
                    If
                    (
                        -Not $Global:GlobalVerboseMsgNext
                    )
                    {
                        $Global:GlobalVerboseMsgNext = Get-Date
                    }

                    $VerboseMsgNowTimer = Get-Date
                    
                    $Timer1 = $Global:GlobalVerboseMsgNext.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer2 = $VerboseMsgNowTimer.ToString('Dyy.MM.dd|THH.mm.ss.tt')
                    $Timer3 = $(New-TimeSpan -Start $Global:GlobalVerboseMsgNext -End $VerboseMsgNowTimer -ErrorAction SilentlyContinue).ToString() -replace '(.*\.\d\d).*','$1'
                    Write-Host $("[{0}]|[{1}]|[{2}]`t-`t [{3}]`t`t- {4}" -f $Timer1,$Timer2,$Timer3, $Status, $Message) -ForegroundColor $Color
                    break
                }
            }
        #endregion Process Message
    #endregion Main
}
#endregion Write-BluGenieVerboseMsg (Function)