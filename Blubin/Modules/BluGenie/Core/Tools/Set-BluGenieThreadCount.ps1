#region Set-BluGenieThreadCount (Function)
Function Set-BluGenieThreadCount
{
<#
    .SYNOPSIS
        Set-BluGenieThreadCount is an add-on to manage the ThreadCount in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieThreadCount is an add-on to manage the ThreadCount in the BluGenie Console

        We use PowerShell Runspace Pools for Multithreading. ThreadCount is used to define the maximum number of threads we wish to run at
        one time.

    .PARAMETER Count
        Description: ThreadCount value
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Reset
        Description: Reset the current value back to 50
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieThreadCount '25'
        Description: Set Thread Count
        Notes: The value is a [Int]

    .EXAMPLE
        Command: Set-BluGenieThreadCount -Count '1000'
        Description: Set JobID using the Count parameter
        Notes: The value is a [Int]

    .EXAMPLE
        Command: ThreadCount -Count '1000'
        Description: Set JobID using the Alias command name while using the JOB ID parameter
        Notes: The value is a [Int]

    .EXAMPLE
        Command: Set-BluGenieThreadCount -Reset
        Description: Reset the Thread Count back to the default which is 50
        Notes:

    .EXAMPLE
        Command: Set-BluGenieThreadCount -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Set-BluGenieThreadCount -WalkThrough
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
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 20.06.0201: * [Michael Arroyo] Posted
#>
    [cmdletbinding()]
    [Alias('Set-ThreadCount','ThreadCount')]
    Param
    (
        [Parameter(Position=0)]
        [Int]$Count,

        [Switch]$Reset,

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
                {$Reset} {
                    [String]$Global:ConsoleThreadCount = 50
                    $ConsoleThreadCountText = "Thread Count".PadRight(40,' ') + "|| `t"
                    $ConsoleThreadCountMsg = '..Reset..'
                    Write-host -NoNewline $("`n{0}" -f $ConsoleThreadCountText) -ForegroundColor Yellow
                    Write-Host -NoNewline $ConsoleThreadCountMsg -ForegroundColor Green
                    Write-Host "`n"

                    Break
                }
            #endregion Remove value

            #region Default
                Default {
                    If (-Not $Count) {
                        $ConsoleThreadCountText = "Thread Count".PadRight(40,' ') + "|| `t"
                        $ConsoleThreadCountMsg = $('..Not Set..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleThreadCountText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleThreadCountMsg -ForegroundColor Red
                        Write-Host "`n"
                    } Else {
                        $ConsoleThreadCountText = "$Count".PadRight(40,' ') + "|| `t"
                        $ConsoleThreadCountMsg = '..Updated Thread Count..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleThreadCountText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleThreadCountMsg -ForegroundColor Green

                        Write-Host "`n"
                        [String]$Global:ConsoleThreadCount = $Count
                    }
                }
            #endregion Default
        }
    #endregion Main
}
#endregion Set-BluGenieThreadCount (Function)