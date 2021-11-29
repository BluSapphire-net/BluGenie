#region Publish-BluGenieArtifact (Function)
Function Publish-BluGenieArtifact
{
<#
    .SYNOPSIS
        Manage Artifact data from a JSON/YAML file to query local and remote systems for a specfic Indicator of compromise or IOC

    .DESCRIPTION
        Import, Export, and Review Artifact data from a JSON/YAML file.
        Artifacts are contructed logic to query local and remote systems for a specfic Indicator of compromise or IOC

        IOC is a forensic term that refers to the evidence on a device that points out to a security breach. The data
        of IOC is gathered after a suspicious incident, security event or unexpected call-outs from the network.

    .PARAMETER Import
        Description: Import a JSON/YAML Artifact to use to query local and remote systems for a specfic IOC
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Export
        Description: Export the BluGenie Console settings into a JSON/YAML Artifact
        Notes: YAML is the default export type.  If you want to change it set -Exporttype 'JSON'
        Alias:
        ValidateSet: 'YAML','JSON'

    .PARAMETER Review
		Description: Review a JSON/YAML Artifact without overwritting any predefined Artifact settings
		Notes:  In the BluGenie Conole you can manually update the Artifact settings even while reviewing another Artifact
		Alias:
		ValidateSet:

    .PARAMETER Remove
		Description: Remove the currently selected Artifact
		Notes: If there is no Artifact selected and you run the -Import parameter you will be given a file dialog to choose an Artifact
		Alias:
		ValidateSet:

    .PARAMETER ExportType
		Description: Select what Artifact format to export to.
		Notes:  The default is 'YAML'
		Alias:
		ValidateSet: 'YAML','JSON'

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Publish-BluGenieArtifact -Artifact <File Path>
        Description: Use this commadn to set the Artifact and get it ready for importing or review
        Notes: This option uses the default cmdlet name

    .EXAMPLE
        Command: Publish-BGArtifact -Artifact .
        Description: Use this command to quickly bring up the file select dialog to manually select the Artifact to import
        Notes: This option uses the Short-Hand cmdlet name

    .EXAMPLE
		Command: BGArtifact -Review
		Description: Use this command to show any issues with the currently selected Artifact.
		Notes: This option uses the BG Alias name

    .EXAMPLE
		Command: BGArtifact -Artifact .\Artifacts\TestPack.YAML -Review
		Description: Use this command to Select the Artifact and to process a Review on it with a single command
		Notes:

    .EXAMPLE
		Command: BGArtifact -Import
		Description: Use this command to import and utilize an Artifact
		Notes: If an Artifact was not previsouly set, a file select dialog will be displayed to manually select the Artifact to import

    .EXAMPLE
		Command: BGArtifact -Artifact .\Artifacts\TestPack.YAML -Import
		Description: Use this command to Select and Import an Artifact to process
		Notes:

    .EXAMPLE
		Command: BGArtifact -ExportType 'JSON' -Export .\QueryOpenPorts
		Description: Use this command to export an Artifact to a JSON formated file.
		Notes: Items will be saved in the .\Artifacts\ Directory

    .EXAMPLE
		Command: BGArtifact -Export .\QueryOpenPorts
		Description: Use this command to export an Artifact to a YAML formated file.
		Notes: YAML is the default export format.  Items will be saved in the .\Artifacts\ Directory

    .EXAMPLE
        Command: BGArtifact -Help
        Description: Use this command to provide you with an interactive help system to show more examples and commands
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: BGArtifact -WalkThrough
        Description: Use this command to provide you with an interactive help system to show more examples and commands
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1908.0501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.04.1901
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            :
        * Link                      :
                                        ~
        * Dependencies              :
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               - Get-ErrorAction will round up any errors into a simple object
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    ~ 1908.0501:* [Michael Arroyo] Posted
    ~ 1908.0801:* [Michael Arroyo] Added the ( Remove ) parameter and process
                * [Michael Arroyo] Added the ( Review ) parameter and process
                * [Michael Arroyo] Added the ( Export ) parameter and process
                * [Michael Arroyo] Updated the ( Import ) process to wipe the JSON job file name after it imports the data into the
                                    console
                * [Michael Arroyo] Added more error control around the Console variable check
    ~ 1908.2201:* [Michael Arroyo] Added support for the ( Trap ) value from the Job file
                * [Michael Arroyo] Updated the ( Import ) process from a Switch Statement to Multiple If Statements for better
                                    management.
    ~ 2001.2701:* [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                * [Michael Arroyo] Added support for the ( JobTimeOut ) parameter
                * [Michael Arroyo] Added support for the ( Debug ) parameter
                * [Michael Arroyo] Added support for the ( JobID ) parameter
    ~ 2004.3001:* [Michael Arroyo] Updated the Convertfrom-JSON functions to support older JSON file formats.
    ~ 20.05.2101• [Michael Arroyo] Updated to support Posh 2.0
    ~ 20.06.2701• [Michael Arroyo] Added the missing JSON/Setting properties.  Info was missing when picking a .JSON file from the File Explorer.
    ~ 20.07.0601• [Michael Arroyo] Updated the BGNoSetRes process to also disable the Console updates if enabled.
                • [Michael Arroyo] Added support for the ( RemoveMods ) parameter
                • [Michael Arroyo] Added support for the ( UpdateMods ) parameter
    ~ 21.02.0101• [Michael Arroyo] Added support for the ( ServiceJob ) parameter
    ~ 21.03.0801• [Michael Arroyo] Removed all references for the flag RemoveMods.  this action is now its own function
    ~ 21.04.0901• [Michael Arroyo] Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the
                                    information correctly":
                * [Michael Arroyo] Added Alias Edit-BGJSON
                * [Michael Arroyo] Added Alias Edit-BGYAML
                * [Michael Arroyo] Added Alias Edit-JSON
                * [Michael Arroyo] Added Alias Edit-YAML
                * [Michael Arroyo] Added Alias YAML
                * [Michael Arroyo] Added Alias Edit-BluGenieYAML
                * [Michael Arroyo] Added Alias Edit-BGJobPack
                * [Michael Arroyo] Added Alias Edit-JobPack
                * [Michael Arroyo] Added Alias JobPack
                * [Michael Arroyo] Added Alias Edit-BluGenieJobPack
                * [Michael Arroyo] Updated script based on (PSScriptAnalyzerSettings.psd1) linter configuration
                * [Michael Arroyo] Added support for Importing, Editing, Reviewing, and Exporting YAML job files.
                * [Michael Arroyo] Added Parameter ExportType to determine which type to use for export.  Note: The default is YAML
                * [Michael Arroyo] Updated the FileBrowser function to look for YAML as well as JSON
                * [Michael Arroyo] Removed all references of JSON from the verbose messaging and set it to just (Job).
                * [Michael Arroyo] Auto detect the imported file type without a parameter
    ~ 21.04.1901• [Michael Arroyo] Function renamed from Edit-BluGenieJSON.ps1
                * [Michael Arroyo] Removed / Replaced all references to JSON or Job packs.  The new reference is Artifact
                * [Michael Arroyo] Removed Alias Edit-BGJSON
                * [Michael Arroyo] Removed Alias Edit-BGYAML
                * [Michael Arroyo] Removed Alias Edit-JSON
                * [Michael Arroyo] Removed Alias Edit-YAML
                * [Michael Arroyo] Removed Alias YAML
                * [Michael Arroyo] Removed Alias Edit-BluGenieYAML
                * [Michael Arroyo] Removed Alias Edit-BGJobPack
                * [Michael Arroyo] Removed Alias Edit-JobPack
                * [Michael Arroyo] Removed Alias JobPack
                * [Michael Arroyo] Removed Alias Edit-BluGenieJobPack
                * [Michael Arroyo] Updated the FileBrowser function to look for YML as well as JSON and YAML
                * [Michael Arroyo] Auto detect import type based on file content.  This way the file extension can be labled as anything.


#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Publish-BGArtifact','BGArtifact')]
    #region Parameters
        Param
        (
            [String]$Artifact = $global:ConsoleJSONJob,

            [Switch]$Import,

            [String]$Export,

            [Switch]$Remove,

            [Switch]$Review,

            [ValidateSet('YAML','JSON')]
            [String]$ExportType = 'YAML',

            [Alias('Help')]
            [Switch]$Walkthrough
        )
    #endregion Parameters

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

    #region Dynamic parameter update
        If
        (
            $PSVersionTable.PSVersion.Major -eq 2
        )
        {
            $IsPosh2 = $true
        }
        Else
        {
            $IsPosh2 = $false
        }
    #endregion Dynamic parameter update

    #region Main
        Switch
        (
            $null
        )
        {
            #region Export
                {$Export}
                {
                    $ExportHash = @{
                        systems          = $global:ConsoleSystems
                        commands         = $global:ConsoleCommands
                        parallelcommands = $global:ConsoleParallelCommands
                        postcommands     = $global:ConsolePostCommands
                        range            = $global:ConsoleRange
                        jobid            = $global:ConsoleJobID
                        threadcount      = $global:ConsoleThreadCount
                        debug            = $global:ConsoleDebug.ToString()
                        jobtimeout       = $global:ConsoleJobTimeout
                        trap             = $global:ConsoleTrap.ToString()
                        verbose          = $Global:BGVerbose.ToString()
                        nosetres         = $Global:BGNoSetRes.ToString()
                        noexit           = $Global:BGNoExit.ToString()
                        nobanner         = $Global:BGNoBanner.ToString()
                        cores            = $Global:BGCores
                        priority         = $Global:BGPriority
                        memory           = $Global:BGMemory
                        updatemods       = $Global:BGUpdateMods.ToString()
                        servicejob       = $Global:BGServiceJob.ToString()
                    }

                    Try
                    {
                        If
                        (
                            $ExportType -eq 'JSON'
                        )
                        {
                            $ExportHash | ConvertTo-Json | Out-File -FilePath "$('{0}\Artifacts\{1}.JSON' -f $ScriptDirectory, $Export)" `
                                -ErrorAction Stop
                            $ConsoleArtifactText = $('{0}\Artifacts\{1}.JSON' -f $ScriptDirectory, $Export).PadRight(40, ' ') + "`t|| `t"
                        }
                        Else
                        {
                            $ExportHash | ConvertTo-Yaml | Out-File -FilePath "$('{0}\Artifacts\{1}.YAML' -f $ScriptDirectory, $Export)" `
                                -ErrorAction Stop
                            $ConsoleArtifactText = $('{0}\Artifacts\{1}.YAML' -f $ScriptDirectory, $Export).PadRight(40, ' ') + "`t|| `t"
                        }

                        $ConsoleArtifactMsg = $('..Exported..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Green
                        Write-Host "`n"
                    }
                    Catch
                    {
                        $ConsoleArtifactMsg = $('..Failed to Export..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red
                        Write-Host "`n"
                    }

                    break
                }
            #endregion Export

            #region Artifact item
                {$PSBoundParameters.Keys -contains 'Import' -or $Artifact.Length -gt 0 -and $($Remove -ne $true)}
                {
                    If
                    (
                        $Artifact.Length -eq 0 -or $Artifact -eq '.'
                    )
                    {
                        $Artifact = Invoke-FileBrowser -Filter '*.JSON;*.YAML;*.YML' -InitialDirectory $ScriptDirectory
                    }

                    If
                    (
                        Test-Path -Path $Artifact
                    )
                    {
                        $global:ConsoleJSONJob = $Artifact

                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = '..Artifact Set..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Green

                        Write-Host "`n"
                    }
                    Else
                    {
                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = '..Artifact - Could not be found..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red

                        Write-Host "`n"
                    }
                }
            #endregion Artifact item

            #region Review
                {$Review -eq $true}
                {
                    If
                    (
                        $($Artifact.Length -gt 0) -and $(Test-Path -Path $Artifact)
                    )
                    {
                        Try
                        {
                            $ReturnDATA = $(Get-Content -Path $Artifact -ErrorAction SilentlyContinue | `
                                ConvertFrom-Json -ErrorAction Stop | ConvertTo-Json -ErrorAction SilentlyContinue)

                        }
                        Catch
                        {
                            $ReturnDATA = $(Get-Content -Path $global:ConsoleJSONJob -ErrorAction SilentlyContinue | `
                                ConvertFrom-Yaml -ErrorAction Stop | ConvertTo-Yaml -ErrorAction SilentlyContinue)
                        }

                        Return $ReturnDATA
                    }
                    
                    break
                }
            #endregion Review

            #region Remove value
                {$Remove -eq $true}
                {
                    If
                    (
                        $Artifact
                    )
                    {
                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = '..Removed..'
                        Write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Green
                        Write-Host "`n"

                        [String]$global:ConsoleJSONJob = $null
                    }
                    Else
                    {
                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = $('..Not Set..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red
                        Write-Host "`n"
                    }

                    break
                }
            #endregion Remove value

            #region Import item
                {$Import -eq $true}
                {
                    $ArtifactContent = Get-Content -Path $Artifact -ErrorAction SilentlyContinue

                    Try
                    {
                        $ArtifactData = $ArtifactContent | ConvertFrom-Json -ErrorAction Stop
                    }
                    Catch
                    {
                        Try
                        {
                            $ArtifactData = $($ArtifactContent) -join ' ' | ConvertFrom-Json -ErrorAction Stop
                        }
                        Catch
                        {
                            Try
                            {
                                $ArtifactData = $ArtifactContent | ConvertFrom-Yaml -ErrorAction Stop
                            }
                            Catch
                            {
                                $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                                $ConsoleArtifactMsg = $('..Is Invalid..')
                                write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red
                                Write-Host "`n"
                            }
                        }
                    }

                    If
                    (
                        $ArtifactData
                    )
                    {
                        #region Systems Data
                            If
                            (
                                $ArtifactData.systems
                            )
                            {
                                [System.Collections.ArrayList]$global:ConsoleSystems = @()

                                $ArtifactData.systems | ForEach-Object `
                                -Process `
                                {
                                    $null = $global:ConsoleSystems.Add($_)
                                }
                            }
                        #endregion Systems Data

                        #region Threadcount Data
                            If
                            (
                                $ArtifactData.threadcount
                            )
                            {
                                $global:ConsoleThreadCount = $ArtifactData.threadcount
                            }
                        #endregion Threadcount Data

                        #region Range Data
                            If
                            (
                                $ArtifactData.range
                            )
                            {
                                $global:ConsoleRange = $ArtifactData.range
                            }
                        #endregion Range Data

                        #region Commands Data
                            If
                            (
                                $ArtifactData.commands
                            )
                            {
                                [System.Collections.ArrayList]$global:ConsoleCommands = @()

                                $ArtifactData.commands | ForEach-Object `
                                -Process `
                                {
                                    $null = $global:ConsoleCommands.Add($_)
                                }
                            }
                        #endregion Commands Data

                        #region ParallelCommands Data
                            If
                            (
                                $ArtifactData.parallelcommands
                            )
                            {
                                [System.Collections.ArrayList]$global:ConsoleParallelCommands = @()

                                $ArtifactData.parallelcommands | ForEach-Object `
                                -Process `
                                {
                                    $null = $global:ConsoleParallelCommands.Add($_)
                                }
                            }
                        #endregion ParallelCommands Data

                        #region PostCommands Data
                            If
                            (
                                $ArtifactData.postcommands
                            )
                            {
                                [System.Collections.ArrayList]$global:ConsolePostCommands = @()

                                $ArtifactData.postcommands | ForEach-Object `
                                -Process `
                                {
                                    $null = $global:ConsolePostCommands.Add($_)
                                }
                            }
                        #endregion PostCommands Data

                        #region Trap Data
                            If
                            (
                                $ArtifactData.trap
                            )
                            {
                                If
                                (
                                    $($ArtifactData.trap).toString() -eq 'True'
                                )
                                {
                                    $global:ConsoleTrap = $true
                                }
                                Else
                                {
                                    $global:ConsoleTrap = $false
                                }
                            }
                        #endregion Range Data

                        #region ID Data
                            If
                            (
                                $ArtifactData.jobid
                            )
                            {
                                $global:ConsoleJobID = $ArtifactData.jobid
                            }
                        #endregion ID Data

                        #region Debug Data
                            If
                            (
                                $ArtifactData.debug
                            )
                            {
                                If
                                (
                                    $($ArtifactData.debug).toString() -eq 'True'
                                )
                                {
                                    $global:ConsoleDebug = $true
                                }
                                Else
                                {
                                    $global:ConsoleDebug = $false
                                }
                            }
                        #endregion Debug Data

                        #region Artifact Timeout Data
                            If
                            (
                                $ArtifactData.jobtimeout
                            )
                            {
                                $global:ConsoleJobTimeout = $ArtifactData.jobtimeout
                            }
                        #endregion Artifact Timeout Data

                        #region Verbose Data
                            If
                            (
                                $ArtifactData.Verbose
                            )
                            {
                                If
                                (
                                    $($ArtifactData.Verbose).toString() -eq 'True'
                                )
                                {
                                    $global:BGVerbose = $true
                                }
                                Else
                                {
                                    $global:BGVerbose = $false
                                }
                            }
                        #endregion Verbose Data

                        #region NoSetRes Data
                            If
                            (
                                $ArtifactData.NoSetRes
                            )
                            {
                                If
                                (
                                    $($ArtifactData.NoSetRes).toString() -eq 'True'
                                )
                                {
                                    $global:BGNoSetRes = $true
                                    $global:Console = $false
                                }
                                Else
                                {
                                    $global:BGNoSetRes = $false
                                    $global:Console = $true
                                }
                            }
                        #endregion NoSetRes Data

                        #region NoExit Data
                            If
                            (
                                $ArtifactData.NoExit
                            )
                            {
                                If
                                (
                                    $($ArtifactData.NoExit).toString() -eq 'True'
                                )
                                {
                                    $global:BGNoExit = $true
                                }
                                Else
                                {
                                    $global:BGNoExit = $false
                                }
                            }
                        #endregion NoExit Data

                        #region NoBanner Data
                            If
                            (
                                $ArtifactData.NoBanner
                            )
                            {
                                If
                                (
                                    $($ArtifactData.NoBanner).toString() -eq 'True'
                                )
                                {
                                    $global:BGNoBanner = $true
                                }
                                Else
                                {
                                    $global:BGNoBanner = $false
                                }
                            }
                        #endregion NoBanner Data

                        #region Cores Data
                            If
                            (
                                $ArtifactData.Cores
                            )
                            {
                                $global:BGCores = $ArtifactData.Cores
                            }
                        #endregion Cores Data

                        #region Priority Data
                            If
                            (
                                $ArtifactData.Priority
                            )
                            {
                                $global:BGPriority = $ArtifactData.Priority
                            }
                        #endregion Priority Data

                        #region Memory Data
                            If
                            (
                                $ArtifactData.Memory
                            )
                            {
                                $global:BGMemory = $ArtifactData.Memory
                            }
                        #endregion Memory Data

                        #region UpdateMods Data
                            If
                            (
                                $ArtifactData.UpdateMods
                            )
                            {
                                If
                                (
                                    $($ArtifactData.UpdateMods).toString() -eq 'True'
                                )
                                {
                                    $global:BGUpdateMods = $true
                                }
                                Else
                                {
                                    $global:BGUpdateMods = $false
                                }
                            }
                        #endregion UpdateMods Data

                        #region Service Artifact Data
                            If
                            (
                                $ArtifactData.ServiceJob
                            )
                            {
                                If
                                (
                                    $($ArtifactData.ServiceJob).toString() -eq 'True'
                                )
                                {
                                    $global:BGServiceJob = $true
                                }
                                Else
                                {
                                    $global:BGServiceJob = $false
                                }
                            }
                        #endregion Service Artifact Data

                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = '..Imported..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Green

                        Write-Host "`n"
                    }
                    Else
                    {
                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = '..Data failed to import..'
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red

                        Write-Host "`n"
                    }

                    [String]$global:ConsoleJSONJob = $null

                    $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                    $ConsoleArtifactMsg = '..Removed..'
                    Write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                    Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Green
                    Write-Host "`n"

                    break
                }
            #endregion Import item

            #region Default (Show value)
                Default
                {
                    If
                    (
                        $Artifact
                    )
                    {
                        $ConsoleArtifactText = "$Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = $('..Artifact..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Green
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Yellow
                        Write-Host "`n"
                    }
                    Else
                    {
                        $ConsoleArtifactText = "Artifact".PadRight(40,' ') + "|| `t"
                        $ConsoleArtifactMsg = $('..Not Set..')
                        write-host -NoNewline $("`n{0}" -f $ConsoleArtifactText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleArtifactMsg -ForegroundColor Red
                        Write-Host "`n"
                    }
                }
            #endregion Default (Show list values)
        }
    #endregion Main
}
#endregion Publish-BluGenieArtifact (Function)