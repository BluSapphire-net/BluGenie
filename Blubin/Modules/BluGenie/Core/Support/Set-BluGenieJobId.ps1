#region Set-BluGenieJobId (Function)
Function Set-BluGenieJobId
{
<#
    .SYNOPSIS
        Set-BluGenieJobId is an add-on to manage the Job ID in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieJobId is an add-on to manage the Job ID in the BluGenie Console

        A Job ID is an identifier that helps you track the progress of a job.

    .PARAMETER ID
        Description: JobID value
        Notes:  If left blank the value will be converted to a DateTime value at runtime
        Alias:
        ValidateSet:

    .PARAMETER Remove
        Description: Remove the current value
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieJobId 'ID5564'
        Description: Set JobID using the default command name
        Notes: The ID is a string

    .EXAMPLE
        Command: Set-BluGenieJobId -ID 'ID5564'
        Description: Set JobID using the default command name while using the JOB ID parameter
        Notes: The ID is a string

    .EXAMPLE
        Command: Set-JobId -ID 'ID5564'
        Description: Set JobID using the Alias command name while using the JOB ID parameter
        Notes: The ID is a string

    .EXAMPLE
        Command: Set-BluGenieJobId -Remove
        Description: Remove the Job ID.
        Notes: If no Job ID is set.  The current time and date will be used instead.

    .EXAMPLE
        Command: Set-BluGenieJobId -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Set-BluGenieJobId -WalkThrough
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
    [Alias('Set-JobId','JobId')]
    Param
    (
        [Parameter(Position=0)]
        [String]$ID,

        [Switch]$Remove,

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
            #region Remove value
                {$Remove} {
                    [String]$Global:ConsoleJobID = $null
                    $ConsoleJobIDText = "Job ID".PadRight(40,' ') + "|| `t"
                    $ConsoleJobIDMsg = '..Removed..'
                    Write-host -NoNewline $("`n{0}" -f $ConsoleJobIDText) -ForegroundColor Yellow
                    Write-Host -NoNewline $ConsoleJobIDMsg -ForegroundColor Green
                    Write-Host "`n"

                    Break
                }
            #endregion Remove value

            #region Default
                Default {
                    If (-Not $ID) {
                        $ConsoleJobIDText = "Job ID Value".PadRight(40,' ') + "|| `t"
                        $ConsoleJobIDMsg = $('..Not Set..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleJobIDText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleJobIDMsg -ForegroundColor Red
                        Write-Host "`n"
                    } Else {
                        $ConsoleJobIDText = "$ID".PadRight(40,' ') + "|| `t"
                        $ConsoleJobIDMsg = '..Updated Job ID..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleJobIDText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleJobIDMsg -ForegroundColor Green

                        Write-Host "`n"
                        [String]$Global:ConsoleJobID = $ID
                    }
                }
            #endregion Default
        }
    #endregion Main
}
#endregion Set-BluGenieJobId (Function)