#region Invoke-BluGenieWipe (Function)
Function Invoke-BluGenieWipe
{
<#
    .SYNOPSIS
        Invoke-BluGenieWipe is an add-on to reset all set options in the BluGenie Console

    .DESCRIPTION
        Invoke-BluGenieWipe is an add-on to reset all set options in the BluGenie Console

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Invoke-BluGenieWipe
        Description: Reset all parameters in the BluGenie Console
        Notes: Parameters
                * Systems
                * Range
                * Commands
                * ParallelCommands
                * PostCommands
                * JSONJob
                * ThreadCount
                * JobID
                * Debug
                * JobTimeOut
                * Trap

    .EXAMPLE
        Command: Invoke-BluGenieWipe -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGenieWipe -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1908.0501
        * Latest Author             :
        * Latest Build Version      : 21.02.0101
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            :
        * Link                      :
            ~
        * Dependencies              :
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 1908.0501:• [Michael Arroyo] Posted
            ~ 1908.2101:• [Michael Arroyo] Added support for the ( Trap ) parameter
            ~ 2001.2701:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                        • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                        • [Michael Arroyo] Added support for the ( JobTimeOut ) parameter
                        • [Michael Arroyo] Added support for the ( Debug ) parameter
                        • [Michael Arroyo] Added support for the ( JobID ) parameter
            ~ 21.02.0101• [Michael Arroyo] Added support for the ( ServiceJob ) parameter
                        • [Michael Arroyo] Added support for the ( RemoveMods ) parameter
                        • [Michael Arroyo] Added support for the ( UpdateMods ) parameter
#>
    [cmdletbinding()]
    [Alias('Wipe')]
    Param
    (
        [Alias('Help')]
        [Switch]$Walkthrough
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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['Wipe'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Wipe'].StartTime = $($StartTime).DateTime
        $HashReturn['Wipe']['Rulenames'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Wipe'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Reset Global Variables
            [System.Collections.ArrayList]$global:ConsoleSystems = @()
            [System.Collections.ArrayList]$global:ConsoleRange = @()
            [System.Collections.ArrayList]$global:ConsoleCommands = @()
            [String]$global:ConsoleJSONJob = ''
            [String]$global:ConsoleJobID = ''
            [Int]$global:ConsoleThreadCount = 50
            [System.Collections.ArrayList]$global:ConsoleParallelCommands = @()
            [System.Collections.ArrayList]$global:ConsolePostCommands = @()
            [Switch]$global:ConsoleTrap = $false
            [Int]$global:ConsoleJobTimeout = 120
            [System.String]$global:ConsoleDebug = $false
            [System.String]$global:BGRemoveMods = $false
            [System.String]$global:BGUpdateMods = $false
            [System.String]$global:BGServiceJob = $false
        #endregion Reset Global Variables

        #region Reset Options
            $RemoveFilter = @(
                'Systems',
                'Range',
                'Commands',
                'ParallelCommands',
                'PostCommands',
                'JSONJob',
                'ThreadCount',
                'Trap',
                'JobID',
                'JobTimeOut',
                'Debug',
                'RemoveMods',
                'UpdateMods',
                'ServiceJob'
            )

            $RemoveFilter | ForEach-Object `
            -Process `
            {
                $WipeText = "$_".PadRight(25,' ') + "|| `t"
                $WipeMsg = '..Data Reset..'
                write-host -NoNewline $("`n{0}" -f $WipeText) -ForegroundColor Yellow
                Write-Host -NoNewline $WipeMsg -ForegroundColor Green
            }

            Write-Host "`n"
        #endregion Reset Options
    #endregion Main
}
#endregion Invoke-BluGenieWipe (Function)