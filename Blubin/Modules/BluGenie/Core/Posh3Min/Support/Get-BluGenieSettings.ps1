#Requires -Version 3
#region Get-BluGenieSettings (Function)
Function Get-BluGenieSettings
{
<#
    .SYNOPSIS
        Get-BluGenieSettings is an add-on to show all defined values for the current session in the BluGenie Console

    .DESCRIPTION
        Get-BluGenieSettings is an add-on to show all defined values for the current session in the BluGenie Console

    .PARAMETER OutputType
        Description:  Select the format of the Outpuut to display the settings configuration in
        Notes:  The default is 'YAML'
        Alias:
        ValidateSet: 'YAML','JSON','OutUnEscapedJSON'

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Get-BluGenieSettings
        Description: This will output the current BluGenie Console Settings in a JSON format
        Notes:

    .EXAMPLE
        Command: Get-BluGenieSettings -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSettings -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: TypeName: System.String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1908.0501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.04.0701
        * Comments                  :
        * PowerShell Compatibility  : 3,4,5.x
        * Forked Project            :
        * Link                      :
            ~
        * Dependencies              :
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o  New-BluGenieUID or New-UID - Create a New UID
            o  ConvertTo-Yaml - ConvertTo Yaml
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    ~ 1908.0501:• [Michael Arroyo] Posted
    ~ 1908.2101:• [Michael Arroyo] Added support for the ( Trap ) parameter
                • [Michael Arroyo] Updated the default return to Yaml
                • [Michael Arroyo] Added a ( JSON ) parameter to change the output to JSON format
    ~ 2001.2701:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                • [Michael Arroyo] Added support for the ( JobTimeOut ) parameter
                • [Michael Arroyo] Added support for the ( Debug ) parameter
                • [Michael Arroyo] Added support for the ( JobID ) parameter
    ~ 20.05.2101• [Michael Arroyo] Updated function requirment to Posh 3
                • [Michael Arroyo] Added support for the ( UpdateMods ) parameter
    ~ 20.06.0101• [Michael Arroyo] Updated the SettingsHash object.  This is for Posh 3 and up by default.
                • [Michael Arroyo] Added support for the ( UpdateMods ) parameter
                • [Michael Arroyo] Added support for the ( RemoveMods ) parameter
    ~ 21.02.0101• [Michael Arroyo] Added support for the ( ServiceJob ) parameter
    ~ 21.03.0801• [Michael Arroyo] Removed the flag for RemoveMods
    ~ 21.04.0701• [Michael Arroyo] Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the
                                    information correctly"
                • [Michael Arroyo] Updated the Output Type to support YAML, JSON, and OutUnescapedJSON.  The default return is now YAML.
                                    Note:  This is only noticed in the Console view when using the Settings, Get-BGSettings, or
                                    Get-BluGenieSettings
                • [Michael Arroyo] Updated script based on (PSScriptAnalyzerSettings.psd1) linter configuration

#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Settings')]
    Param
    (
        [ValidateSet('YAML','JSON','OutUnEscapedJSON')]
        [string]$OutputType = 'YAML',

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
        $SettingsHash = [PSCustomObject]@{
                                            systems          = ''
                                            commands         = ''
                                            parallelcommands = ''
                                            postcommands     = ''
                                            range            = ''
                                            jobid            = ''
                                            threadcount      = ''
                                            debug            = ''
                                            jobtimeout       = ''
                                            trap             = ''
                                            verbose          = ''
                                            nosetres         = ''
                                            noexit           = ''
                                            nobanner         = ''
                                            cores            = ''
                                            priority         = ''
                                            memory           = ''
                                            updatemods       = ''
                                            servicejob       = ''
                                        }

        #region ConsoleSystems
            If
            (
                -Not $global:ConsoleSystems
            )
            {
                [System.Collections.ArrayList]$global:ConsoleSystems = @()
            }

            $SettingsHash.systems = $global:ConsoleSystems
        #endregion ConsoleSystems

        #region ConsoleCommands
            If
            (
                -Not $global:ConsoleCommands
            )
            {
                [System.Collections.ArrayList]$global:ConsoleCommands = @()
            }

            $SettingsHash.commands = $global:ConsoleCommands
        #endregion ConsoleCommands

        #region ConsoleParallelCommands
            If
            (
                -Not $global:ConsoleParallelCommands
            )
            {
                [System.Collections.ArrayList]$global:ConsoleParallelCommands = @()
            }

            $SettingsHash.parallelcommands = $global:ConsoleParallelCommands
        #endregion ConsoleParallelCommands

        #region ConsolePostCommands
            If
            (
                -Not $global:ConsolePostCommands
            )
            {
                [System.Collections.ArrayList]$global:ConsolePostCommands = @()
            }

            $SettingsHash.postcommands = $global:ConsolePostCommands
        #endregion ConsolePostCommands

        #region ConsoleRange
            If
            (
                -Not $global:ConsoleRange
            )
            {
                [System.Collections.ArrayList]$global:ConsoleRange = @()
            }

            $SettingsHash.range = $global:ConsoleRange
        #endregion ConsoleRange

        #region ConsoleJobID
            If
            (
                -Not $global:ConsoleJobID
            )
            {
                [String]$global:ConsoleJobID = ''
            }

            $SettingsHash.jobid = $global:ConsoleJobID
        #endregion ConsoleJobID

        #region ConsoleThreadCount
            If
            (
                -Not $global:ConsoleThreadCount
            )
            {
                [Int]$global:ConsoleThreadCount = 50
            }

            $SettingsHash.threadcount = $global:ConsoleThreadCount
        #endregion ConsoleThreadCount

        #region ConsoleDebug
            If
            (
                -Not $global:ConsoleDebug
            )
            {
                If
                (
                    $BGDebugger
                )
                {
                    [System.String]$global:ConsoleDebug = $global:BGDebugger
                }
                Else
                {
                    $global:BGDebugger = $false
                    [System.String]$global:ConsoleDebug = $global:BGDebugger
                }
            }

            $SettingsHash.debug = $global:ConsoleDebug
        #endregion ConsoleDebug

        #region ConsoleJobTimeout
            If
            (
                -Not $global:ConsoleJobTimeout
            )
            {
                [Int]$global:ConsoleJobTimeout = 120
            }

            $SettingsHash.jobtimeout = $global:ConsoleJobTimeout
        #endregion ConsoleJobTimeout

        #region ConsoleTrap
            If
            (
                -Not $global:ConsoleTrap
            )
            {
                [Switch]$global:ConsoleTrap = $false
            }

            $SettingsHash.trap = $global:ConsoleTrap.ToString()
        #endregion ConsoleTrap

        #region BGVerbose
            If
            (
                -Not $global:BGVerbose
            )
            {
                $global:BGVerbose = $false
            }

            $SettingsHash.verbose = $global:BGVerbose.ToString()
        #endregion BGVerbose

        #region BGNoSetRes
            If
            (
                -Not $global:BGNoSetRes
            )
            {
                $global:BGNoSetRes = $false
            }

            $SettingsHash.NoSetRes = $global:BGNoSetRes.ToString()
        #endregion BGNoSetRes

        #region BGNoExit
            If
            (
                -Not $global:BGNoExit
            )
            {
                $global:BGNoExit = $false
            }

            $SettingsHash.NoExit = $global:BGNoExit.ToString()
        #endregion BGNoExit

        #region BGNoBanner
            If
            (
                -Not $global:BGNoBanner
            )
            {
                $global:BGNoBanner = $false
            }

            $SettingsHash.NoBanner = $global:BGNoBanner.ToString()
        #endregion BGNoBanner

        #region BGCores
            If
            (
                -Not $global:BGCores
            )
            {
                $IntArrCores = @()

                for
                (
                    $i = 0
                    $i -lt $env:NUMBER_OF_PROCESSORS;
                    $i++
                )
                {
                    $null = $IntArrCores += [Int]$($i + 1)
                }

                $global:BGCores = $IntArrCores
            }

            $SettingsHash.Cores = $global:BGCores
        #endregion BGCores

        #region BGPriority
            If
            (
                -Not $global:BGPriority
            )
            {
                [Int]$global:BGPriority = 2
            }

            $SettingsHash.priority = $global:BGPriority
        #endregion BGPriority

        #region BGMemory
            If
            (
                -Not $global:BGMemory
            )
            {
                [Int]$global:BGMemory = 512
            }

            $SettingsHash.memory = $global:BGMemory
        #endregion BGMemory

        #region BGUpdateMods
            If
            (
                -Not $global:BGUpdateMods
            )
            {
                $global:BGUpdateMods = $false
            }

            $SettingsHash.UpdateMods = $global:BGUpdateMods.ToString()
        #endregion BGUpdateMods

        #region BGServiceJob
            If
            (
                -Not $global:BGServiceJob
            )
            {
                $global:BGServiceJob = $false
            }

            $SettingsHash.ServiceJob = $global:BGServiceJob.ToString()
        #endregion BGServiceJob

    #endregion Create Return hash

    #region Main
        Write-Host $('Current Session Settings{0}' -f "`n") -ForegroundColor Yellow

        Switch
        (
            $OutputType
        )
        {
            'YAML'
            {
                Return $($SettingsHash | ConvertTo-YAML)
                break
            }

            'JSON'
            {
                Return $($SettingsHash | ConvertTo-Json -Depth 10)
                break
            }

            'OutUnEscapedJSON'
            {
                Return $($SettingsHash | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                break
            }
        }
    #endregion Main
}
#endregion Get-BluGenieSettings (Function)