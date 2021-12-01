#region Set Script Settings
    #region Create Hash
        $BluGenieInfo = @{}
    #endregion Create Hash

    #region Script File and Path Values
        $BluGenieInfo['PSScriptRoot'] = $PSScriptRoot

        If ($BluGenieInfo['PSScriptRoot'] -eq '') {
            If ($Host.Name -match 'ISE') {
                $BluGenieInfo['PSScriptRoot'] = Split-Path -Path $psISE.CurrentFile.FullPath -Parent
            }
        }
    #endregion Script File and Path Values

    #region Script Settings Values
        $BluGenieInfo['ScriptSettings'] = @{}
        $BluGenieInfo['ScriptSettings']['TimeStamp'] = $('D{0}' -f $(Get-Date -Format dd.MM.yyyy-hh.mm.ss.ff.tt)) -replace '-','_T'
        $BluGenieInfo['ScriptSettings']['CurrentUser'] = $($env:USERNAME)
        $BluGenieInfo['ScriptSettings']['CurrentComputer'] = $env:COMPUTERNAME.ToUpper()
        $BluGenieInfo['ScriptSettings']['WorkingPath'] = $BluGenieInfo.PSScriptRoot
        $BluGenieInfo['ScriptSettings']['LoadedFunctions'] = @()
        $BluGenieInfo['ScriptSettings']['LoadedVariables'] = @('BluGenieInfo')
        $BluGenieInfo['ScriptSettings']['LoadedAliases'] = @()
        $BluGenieInfo['ScriptSettings']['LoadedModules'] = @()
        $BluGenieInfo['ScriptSettings']['Log'] = @()
    #endregion Script Settings Values

    #region Set  Global Module Variables and Project Information
        #region Pull the Scripts Parent directory information
            If (-Not $env:BluGenieRoot) {
                $ScriptDirectory = $BluGenieInfo.PSScriptRoot
                $TranscriptsDir = $('{0}\Windows\Temp\BluGenie\Transcripts' -f $env:SystemDrive)
                $TranscriptsFile = $('{0}\BluGenie_Transcript_{1}.log' -f $TranscriptsDir, $CurDate)

                New-Item -Path $('{0}\Windows\Temp\BluGenie' -f $env:SystemDrive) -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null
                New-Item -Path $TranscriptsDir -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null

                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ScriptDirectory'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'TranscriptsDir'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'TranscriptsFile'
            } Else {
                $ScriptDirectory = $($env:BluGenieRoot)

                #region Detect Config File
                    Switch ($null) {
                        #region Check if Config.JSON exists
                            {$(Test-Path -Path $('{0}\Blubin\Modules\Tools\Config.JSON' -f $ScriptDirectory))} {
                                $ToolsConfigFile = $('{0}\Blubin\Modules\Tools\Config.JSON' -f $ScriptDirectory)
                                break
                            }
                        #endregion Check if Config.JSON exists

                        #region Check if Config.YAML exists
                            {$(Test-Path -Path $('{0}\Blubin\Modules\Tools\Config.YAML' -f $ScriptDirectory))} {
                                $ToolsConfigFile = $('{0}\Blubin\Modules\Tools\Config.YAML' -f $ScriptDirectory)
                                break
                            }
                        #endregion Check if Config.YAML exists
                    }
                #endregion Detect Config File

                $ToolsDirectory = $('{0}\Blubin\Modules\Tools' -f $ScriptDirectory)
            }
        #endregion Pull the Scripts Parent directory information

        #region Set Script Variables if running as a Module
            $ErrorActionPreference = "silentlycontinue"

            If (-Not $env:BluGenieRoot) {
                $("Loading by the Module Only:`n") | Out-File -FilePath $TranscriptsFile

                #region Detect Config File
                    Switch ($null) {
                        #region Check if Config.JSON exists
                            {$(Test-Path -Path $('{0}\..\Tools\Config.JSON' -f $ScriptDirectory))} {
                                $ToolsConfigFile = $('{0}\..\Tools\Config.JSON' -f $ScriptDirectory)
                                break
                            }
                        #endregion Check if Config.JSON exists

                        #region Check if Config.YAML exists
                            {$(Test-Path -Path $('{0}\..\Tools\Config.YAML' -f $ScriptDirectory))} {
                                $ToolsConfigFile = $('{0}\..\Tools\Config.YAML' -f $ScriptDirectory)
                                break
                            }
                        #endregion Check if Config.YAML exists
                    }
                #endregion Detect Config File

                [String]$ToolsDirectory = $('{0}\..\Tools' -f $ScriptDirectory)
                [System.Collections.ArrayList]$ConsoleSystems = @()
                [System.Collections.ArrayList]$ConsoleRange = @()
                [System.Collections.ArrayList]$ConsoleCommands = @()
                [String]$ConsoleJSONJob = ''
                [String]$ConsoleJobID = ''
                [Int]$ConsoleThreadCount = 50
                [System.Collections.ArrayList]$ConsoleParallelCommands = @()
                [System.Collections.ArrayList]$ConsolePostCommands = @()
                [Switch]$ConsoleTrap = $false
                [Int]$ConsoleJobTimeout = 120
                [System.String]$ConsoleDebug = $BGDebugger
                [String]$command = $null
                [bool]$BGVerbose = $false
                [bool]$BgHidefromHelp = $false
                [bool]$BGConsole = $true
                [bool]$BGDebugger = $false
                [String]$BGJSONJob = $null
                [bool]$BGNoSetRes = $false
                [bool]$BGNoExit = $false
                [bool]$BGNoBanner = $false
                [bool]$BGUpdateMods = $false
                [bool]$BGServiceJob = $false
                [Int]$BGMemory = 512

                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ToolsConfigFile'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ToolsDirectory'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleSystems'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleRange'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleCommands'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleJSONJob'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleJobID'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleThreadCount'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleParallelCommands'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsolePostCommands'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleTrap'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleJobTimeout'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ConsoleDebug'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'command'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGVerbose'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BgHidefromHelp'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGConsole'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGDebugger'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGJSONJob'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGNoSetRes'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGNoExit'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGNoBanner'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGUpdateMods'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGServiceJob'
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BGMemory'
            }
        #endregion Set Script Variable if running as a Module

        #region Update Module Path
            If (-Not $env:BluGenieRoot) {
                $BluGenieModulePath = Split-Path -Path $ScriptDirectory -Parent
                $env:PSModulePath = $BluGenieModulePath + $([System.IO.Path]::PathSeparator) + $env:PSModulePath
                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'BluGenieModulePath'
            }
        #endregion Update Module Path
    #endregion Set  Global Module Variables and Project Information
#endregion Set Script Settings

#region Main
    #region Invoke Script Block (Initial Process)
        $BluGenieInfo['ScriptSettings']['Log'] +=  "`nSetting up Remote ScriptBlock"

        $InvokeScriptBlock = {
            #region Script block variables
                $CurSystem = $_
                $ScriptDirectory = $parameter.ScriptDirectory
                $TranscriptsDir = $parameter.TranscriptsDir
                $ToolsDirectory = $parameter.ToolsDirectory
                $JobTranscriptsDir = $parameter.JobIDDir
                $JobID = $parameter.JobID
                $WinRMSettings = $parameter.RemoteWSManConfig
                $BGUpdateMods = $parameter.BGUpdateMods
                $BGServiceJob = $parameter.BGServiceJob
                $BGServiceJobFile = $parameter.BGServiceJobFile
            #endregion Script block variables

            #region Update Module Path
                If ($env:BluGenieRoot) {
                    $BluGenieModulePath = $('{0}\Blubin\Modules\' -f $ScriptDirectory)
                } Else {
                    $BluGenieModulePath = Split-Path -Path $ScriptDirectory -Parent
                }
                #$BluGenieModulePath = $('{0}\Blubin\Modules\' -f $ScriptDirectory)
                $env:PSModulePath = $BluGenieModulePath + $([System.IO.Path]::PathSeparator) + $env:PSModulePath
            #endregion Update Module Path

            #region Load BluGenie Helper Modules
                Import-Module 'BluGenie' -Force -ErrorAction SilentlyContinue
            #endregion Load BluGenie Helper Modules

            #region IP Check
                If ($CurSystem -match '\d+?\.\d+?\.\d+?\.\d*') { #IP was used.  Convert back to hostname
                    $LogFileName = $CurSystem
                    Try {
                        $DNSCurSystem = [net.dns]::GetHostByAddress($CurSystem) | Select-Object -ExpandProperty Hostname
                        $CurSystem = Get-WmiObject -ComputerName $DNSCurSystem -Class Win32_OperatingSystem -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CSName
                    } Catch {
                        $DNSCurSystem = 'No_Valid_Hostname'
                    }
                } Else {
                    $LogFileName = $CurSystem
                    $DNSCurSystem = $CurSystem
                }
            #endregion IP Check

            #region This is the script block being sent to the remote host
            $SendScriptBlock = {
                #region Script Variables
                    #$FireWallRuleEnum = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').FireWallRuleEnum
                    $Commands = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').commands
                    $AgentParallelCommands = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').AgentParallelCommands
                    $AgentPostCommands = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').AgentPostCommands
                    $JobID = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').JobID

                    $IPString = $(Get-WMiObject -Class win32_networkadapterconfiguration | `
                        Where-Object {$_.ipaddress -ne $null -and $_.defaultipgateway -ne $null} | `
                        Select-Object -First 1 -ExpandProperty IPAddress | Select-String -Pattern '\.')

                    If ($IPString) {
                        $LocalIP = $IPString.ToString().Trim()
                    }

                    $BGADInfo = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').ADInfo
                    $BGTools = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').BGTools
                    $BGDebug = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').Debug
                    $BGTrap = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').Trap
                    $BGServiceJob = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').BGServiceJob
                    $BGServiceJobFile = $(Get-Item -Path Variable:\Args | Select-Object -ExpandProperty 'Value').BGServiceJobFile
                    $ReturnTrapData = $false
                    $TrapReturn = ''

                    $JsonReturn = @{}
                    $JsonReturn.jobid = "$JobID"
                    $JsonReturn."$JobID" = @{
                        ip = "$LocalIP"
                        "$LocalIP" = @{
                            hostname = "$($env:COMPUTERNAME)"

                            "$($env:COMPUTERNAME)" = @{
                                PID = $PID
                                ServiceJob = $BGServiceJob
                                commands = @()
                                parallelcommands = @()
                                postcommands = @()
                            }
                        }
                    }
                #endregion Script Variables

                #region Update Module Path
                    If ($env:PSModulePath -match 'BluGenie\\Modules;') {
                        $BluGenieModulePath = $($($env:PSModulePath -split ';' | Select-String -Pattern 'BluGenie') -replace '\n')
                    } Else {
                        $BluGenieModulePath = $('{0}\BluGenie\Modules' -f $Env:ProgramFiles)
                        $env:PSModulePath = $BluGenieModulePath + $([System.IO.Path]::PathSeparator) + $env:PSModulePath
                    }
                #endregion Update Module Path

                #region Update Execution Policy
                    $CurPolicy = $(Get-ExecutionPolicy | Out-String).Trim()
                    Set-ExecutionPolicy -ExecutionPolicy Bypass
                #endregion Update Execution Policy

                #region Load BluGenie Helper Modules
                    If (-Not $(Get-Module | Where-Object -FilterScript { $_.Name -eq 'BluGenie'})) {
                        #$QueryModules = Get-ChildItem -Path $BluGenieModulePath -Directory | Select-Object -Property FullName,BaseName
                        $QueryModules = Get-ChildItem -Path $BluGenieModulePath | Where-Object -FilterScript { $_.Mode -match 'd....'} | `
                            Select-Object -Property FullName,BaseName
                        $ModulesLoaded = @()
                        ForEach ($CurQueryModule in $QueryModules) {
                            Try {
                                If ($BGVerbose) {
                                    Import-Module -Name $CurQueryModule.FullName -ErrorAction Stop -Verbose -Force
                                    $ModulesLoaded += $CurQueryModule | Select-Object -Property @{ Name        = 'Module'
                                                                                                    Expression = {$CurQueryModule.BaseName}
                                                                                                },
                                                                                                @{ Name        = 'Path'
                                                                                                    Expression = {$CurQueryModule.FullName}
                                                                                                }
                                } Else {
                                    Import-Module -Name $_.FullName -ErrorAction Stop
                                    $ModulesLoaded += $CurQueryModule | Select-Object -Property @{ Name        = 'Module'
                                                                                                    Expression = {$CurQueryModule.BaseName}
                                                                                                },
                                                                                                @{ Name        = 'Path'
                                                                                                    Expression = {$CurQueryModule.FullName}
                                                                                                }
                                }
                            } Catch {} #Do Nothing
                        }
                    }
                #endregion Load BluGenie Helper Modules

                #region Update Execution Policy back to the default
                    Set-ExecutionPolicy -ExecutionPolicy $CurPolicy
                #endregion Update Execution Policy back to the default

                #region *** Debug Argument on Remote System ***
                    If ($BGDebug) {
                        "[BluGenie Arguments]" | Out-File -FilePath `
                            $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Force

                        $Args | Format-List | Out-String | `
                                Out-File -FilePath $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append

                        "[BluGenie Settings]`n`n" | Out-File -FilePath `
                                $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append

                        $("Name  : BluGenieModulePath`nValue : {0}`n" -f $BluGenieModulePath) | Out-File -FilePath `
                            $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append

                        $("Name  : CurPolicy`nValue : {0}`n" -f $CurPolicy) | Out-File -FilePath `
                            $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append

                        "`n`n[System Variables]" | Out-File -FilePath `
                            $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append

                        Get-Item -path Env:\ | Format-List | Out-String | Out-File -FilePath `
                            $('{0}\Windows\Temp\BluGenieDebug.txt' -f $env:SystemDrive) -Append
                    }
                #endregion *** Debug Argument on Remote System ***

                #region Main
                    $LoadedAsServiceJob = $false
                    If ($BGServiceJob -and $($PSVersionTable.PSVersion.Major -ge 3)) {
                        If ($(Get-Service | Where-Object -Property Name -eq 'BluGenie' | Select-Object -ExpandProperty Status) -eq 'Running') {
                            $LoadedAsServiceJob = $true
                            $BGServicePath = $('{0}\BluGenie\Modules\BGService\Jobs' -f $Env:ProgramFiles)

                            $BGServiceJobFile | Out-File -FilePath $('{0}\{1}.JSON' -f $BGServicePath, $JobID) -Force
                        }
                    }

                    If (-Not $LoadedAsServiceJob) {
                        #region Process job type
                            #region command section
                                If ($Commands) {
                                    ForEach ($GlbCurJobCommand in $Commands) {
                                        $JobReturn = Invoke-Command -ScriptBlock $([ScriptBlock]::Create($GlbCurJobCommand))

                                        If ($GlbCurJobCommand -match 'Get-BluGenieTrapData.*-OverWrite') {
                                            $ReturnTrapData = $true
                                            $TrapReturn = $JobReturn
                                        }

                                        $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME) += @{
                                            $GlbCurJobCommand = @{
                                                return = $JobReturn
                                            }
                                        }

                                        $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME).commands += @($GlbCurJobCommand)

                                        $null = Remove-Variable $GlbCurJobCommand -ErrorAction SilentlyContinue -Force
                                    }
                                }
                            #endregion command section

                            #region parallelcommands section
                                If ($AgentParallelCommands) {
                                    If ($PSVersionTable.psversion.major -eq '2') {
                                        $AgentParallelCommands | ForEach-Object `
                                        -Process `
                                        {
                                            $GlbCurJobCommand = $_

                                            $JobReturn = Invoke-Command -ScriptBlock $([ScriptBlock]::Create($GlbCurJobCommand))

                                            $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME) += @{
                                                $GlbCurJobCommand = @{
                                                    return = $JobReturn
                                                }
                                            }

                                            $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME).commands += @($GlbCurJobCommand)

                                            $null = Remove-Variable $GlbCurJobCommand -ErrorAction SilentlyContinue -Force
                                        }
                                    } Else {
                                        $JobReturn = Start-RunSpace -commands $AgentParallelCommands -StatusMessage Quiet

                                        If ($JobReturn) {
                                            ForEach ($CurJobKey in $($JobReturn.AllJobResults.Keys | `
                                                Where-Object -FilterScript { $_ -match '^Job\d+'})) {
                                                    $CurJobObject = $($JobReturn).AllJobResults.Item("$CurJobKey")
                                                    $CurJobData = $CurJobObject.Results
                                                    $CurJobCommand = $CurJobObject.Command

                                                    $CurObjtoHash = @{
                                                        return = @{}
                                                    }

                                                    ForEach ($CurJobDataKey in $CurJobData.keys) {
                                                        $CurJobDataKey = $_
                                                        $CurJobDataValue = $CurJobData.("$CurJobDataKey")
                                                        $CurObjtoHash.return["$CurJobDataKey"] = $CurJobDataValue
                                                    }

                                                    $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME) += @{
                                                        $CurJobCommand = $CurObjtoHash
                                                    }
                                            }
                                        }

                                        # *** Remove Comment to export the Parameters to the local file system for review ***
                                        #$AgentParallelCommands | Out-File -FilePath C:\AgentParallelCommands.txt -Force
                                        #$JsonReturn | Out-File -FilePath C:\JsonReturn.txt -Force

                                        $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME).parallelcommands += $AgentParallelCommands
                                        #$JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME).parallelerrors = @($JobReturn.JobData.errors)

                                        $null = Remove-Variable $JobReturn -ErrorAction SilentlyContinue -Force
                                    }
                                }
                            #endregion parallelcommands section

                            #region postcommands section
                                If ($AgentPostCommands) {
                                    ForEach ($GlbCurJobCommand in $AgentPostCommands) {
                                        $JobReturn = Invoke-Command -ScriptBlock $([ScriptBlock]::Create($GlbCurJobCommand))

                                        $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME) += @{
                                            $GlbCurJobCommand = @{
                                                return = $JobReturn
                                            }
                                        }

                                        $JsonReturn.$($jobid).$($localip).$($env:COMPUTERNAME).postcommands += @($GlbCurJobCommand)

                                        $null = Remove-Variable $GlbCurJobCommand -ErrorAction SilentlyContinue -force
                                    }
                                }
                            #endregion command section
                        #endregion Process job type
                    }
                #endregion Main

                #region Trap Return to local machine
                    If ($BGTrap) {
                        $FullDumpPath = $('{0}\Windows\Temp\BG{1}-{2}-{3}.log' -f $($env:SystemDrive), $JobID, $PID, $(New-BluGenieUID -Delimiter '' -NumOfSets 2 -ErrorAction SilentlyContinue))

                        $TrapEventMsg = New-Object -TypeName PSObject -Property @{
                            JobID            = $($jobid)
                            Hostname         = $($env:COMPUTERNAME)
                            Commands         = $Commands
                            ParallelCommands = $AgentParallelCommands
                            PostCommands     = $AgentPostCommands
                            FullDumpPath     = $FullDumpPath
                        }

                        $TrapEventMsg = $($($TrapEventMsg | ConvertTo-Xml -as String) `
                            -replace '\<\?xml\sversion\=\"1\.0\" encoding\=\"utf\-8\"\?\>' `
                            -replace '\<\?xml\sversion\=\"1\.0\"\?\>' `
                            -replace '\<Object\sType\=\"System\.Management\.Automation\.PSCustomObject\"\>' `
                            -replace '\<Objects\>' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.Collections\.ArrayList\"\s\/\>','$1:' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.Object\[\]\"\s\/\>','$1:' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.String\"\>\<\/Property\>','$1:' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.Object\"\s\/\>','$1:' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.String\"\>(.*?)\<\/Property\>','$1: $2' `
                            -replace '\<Property\sName\=\"(.*)\"\sType\=\"System\.Int32\"\>(.*?)\<\/Property\>','$1: $2' `
                            -replace '^\s+\<Object Type\=\"System\.Management\.Automation\.PSCustomObject\"\>' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.Collections\.ArrayList\"\>','$1:' `
                            -replace '\<\/Object\>|\<\/Objects\>' `
                            -replace '\<Property\sName\=\"(.*?)\"\sType\=\"System\.Object\[\]\"\>','$1:' `
                            -replace '\s\s\<Property\sType\=\"System\.String\"\>(.*?)\<\/Property\>','- $1' `
                            -replace '\<Property\sName\=\"(.*?)"\sType\=\"System\.Object\[\]\"\s\/\>' `
                            -replace '\<\/Property\>\s+' `
                            -replace '^\s+','    ').trimend()
                        $TrapEventLogName = 'Application'
                        $TrapSource = 'BluGenie'
                        $TrapEntryType = 'Information'
                        $TrapEventID = 7114

                        If (-not [System.Diagnostics.EventLog]::SourceExists($TrapSource)) {
                            $null = New-EventLog -LogName $TrapEventLogName -Source $TrapSource -ErrorAction SilentlyContinue
                        }

                        #$null = Write-EventLog -LogName $TrapEventLogName -Source $TrapSource -EntryType $TrapEntryType -EventID $TrapEventID -Message $( ConvertTo-Yaml -Data $TrapEventMsg )
                        $null = Write-EventLog -LogName $TrapEventLogName -Source $TrapSource -EntryType $TrapEntryType -EventID $TrapEventID -Message $( $TrapEventMsg )

                        If ($PSVersionTable.PSVersion.Major -gt 2) {
                            $JsonReturn | ConvertTo-Json -Depth 10 -Compress | Out-File -FilePath $FullDumpPath -ErrorAction SilentlyContinue
                        } Else {
                            $JsonReturn | Export-Clixml -Path $FullDumpPath -ErrorAction SilentlyContinue
                        }
                    }
                #endregion Trap Return to local machine

                #region ReturnTrapData
                    If ($ReturnTrapData) {
                        $TrapJobID = $TrapReturn.jobid
                        $TrapIP = $TrapReturn."$TrapJobID".ip
                        $TrapHostname = $TrapReturn."$TrapJobID"."$TrapIP".hostname

                        $JsonReturn = $TrapReturn.GetBluGenieTrapData.JobData
                    }
                #endregion ReturnTrapData

                Return $JsonReturn
            }
            #endregion This is the script block being sent to the remote host

            #region Copy Modules
                If (-Not $($DNSCurSystem -eq 'localhost')) {
                    If ($BGUpdateMods) {
                        $ModuleSource = @()

                        ForEach ($BMModuleItem in $(Get-Childitem -Path $BluGenieModulePath -File -Recurse | Select-Object -Property FullName)) {
                                If ($ToolsConfig.ExcludedCopyFiles.Name.Count -eq 1) {
                                    If ($BMModuleItem -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name).Replace('\','\\')) {
                                        $ModuleSource += $BMModuleItem.FullName
                                    }
                                } Else {
                                    If ($BMModuleItem -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name -Join '|').Replace('\','\\')) {
                                        $ModuleSource += $BMModuleItem.FullName
                                    }
                                }
                            }

                        $null = Send-BluGenieItem -Source $ModuleSource `
                                        -Destination $('{0}\BluGenie\Modules\' -f $Env:ProgramFiles) `
                                        -RelativePath $($BluGenieModulePath) -ToSession -ComputerName $DNSCurSystem `
                                        -Force -ErrorAction SilentlyContinue
                    } Else {
                        $ModuleSource = @()

                        ForEach ($BMModuleItem  in $(Get-Childitem -Path $BluGenieModulePath -File -Recurse | Select-Object -Property FullName)) {
                                If ($ToolsConfig.ExcludedCopyFiles.Name.Count -eq 1) {
                                    If ($BMModuleItem -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name).Replace('\','\\')) {
                                        $ModuleSource += $BMModuleItem.FullName
                                    }
                                } Else {
                                    If ($BMModuleItem -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name -Join '|').Replace('\','\\')) {
                                        $ModuleSource += $BMModuleItem.FullName
                                    }
                                }
                            }

                        $null = Send-BluGenieItem -Source $ModuleSource `
                                        -Destination $('{0}\BluGenie\Modules\' -f $Env:ProgramFiles) `
                                        -RelativePath $($BluGenieModulePath) -ToSession -ComputerName $DNSCurSystem `
                                        -ErrorAction SilentlyContinue
                    }
                }
            #endregion Copy Modules

            #region Offline Data Hash Table
                $AppendOfflineDataHash = @{}
            #endregion Offline Data Hash Table

            #region Argument Hash (To be sent as arguments to the remote machine)
                #region Testing - Run in the ISE to track output (Parameter Tracking)
                    If ($host.name -match 'ISE') {
                        $parameter | ConvertTo-Json | Out-File -FilePath $('{0}\Parameter_{1}.txt' -f $TranscriptsDir, $DNSCurSystem) -Force -ErrorAction SilentlyContinue
                    }
                #endregion Testing - Run in the ISE to track output (Parameter Tracking)

                $ArgHash = @{}
                #$ArgHash.FireWallRuleEnum = $(Publish-BluGenieFirewallRules)
                $ArgHash.BGAgentFunctions = $BGAgent
                $ArgHash.commands = @()
                $ArgHash.AgentParallelCommands = $parameter.remoteparallelcommands
                $ArgHash.AgentPostCommands = $parameter.remotepostcommands
                $ArrRunSpaceCommands = @()
                $ArgHash.Debug = $parameter.Debug
                $ArgHash.Trap = $parameter.Trap
                $ArgHash.BGTools = $parameter.ToolsConfig
                $ArgHash.BGServiceJob = $BGServiceJob
                $ArgHash.BGServiceJobFile = $BGServiceJobFile

                If ($parameter.Command)
                {
                    ForEach($ParamCmd in $($parameter.Command)) {
                        #Run commands prior to processing the remote node job
                        Switch ($ParamCmd) {
                            {$ParamCmd -match 'Get-ADMachineInfo'} {
                                $DistinguishedName = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine' -Name 'Distinguished-Name' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Distinguished-Name'
                                $SystemBaseName = $('DC={0}' -f $($DistinguishedName -split ('\,DC\=',2) | Select-Object -Skip 1 -First 1))

                                $ADSISearcher = [ADSISearcher]$('(&(cn={0})(objectClass=computer))' -f $CurSystem)
                                $ADSISearcher.SearchRoot = [ADSI]"LDAP://$SystemBaseName"
                                $LDAPInfo = $($ADSISearcher.FindOne().Properties)

                                $error.Clear()
                                #region Update LDAP Object
                                    $LDAPInfo.Add('accountexpiresdate',@($(ConvertTo-Date -accountExpires $($LDAPInfo.accountexpires) -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('badpasswordtimedate',@($(ConvertTo-Date -accountExpires $($LDAPInfo.badpasswordtime) -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('lastlogondate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.lastlogon))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('lastlogontimestampdate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.lastlogontimestamp))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('pwdlastsetdate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.pwdlastset))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('whencreateddate',@($(Get-Date -Date $($LDAPInfo.whencreated) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                                    $LDAPInfo.Add('whenchangeddate',@($(Get-Date -Date $($LDAPInfo.whenchanged) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))

                                    $ArgHash.ADInfo = $LDAPInfo
                                #endregion


                                $AppendOfflineDataHash.'Get-ADMachineInfo' = @{
                                    return = @{
                                        ADMachineInfo = @{
                                            ADMachineInfo = $ArgHash.ADInfo
                                        }
                                    }
                                }

                                $AppendData = $true
                                $ArgHash.Commands += $_
                            }

                            {$ParamCmd -match 'Send-Item'} {
                                $SendItemCommand = $('{0} -ComputerName {1}' -f $_, $DNSCurSystem)
                                $ArrRunSpaceCommands += $SendItemCommand

                                #Invoke on Agent or comment out to Run for RunSpace Only
                                #$ArgHash.Commands += $_
                            }

                            {$ParamCmd -match 'Install-Harvester'} {
                                #Invoke on Agent or comment out to Run for RunSpace Only
                                $InstallHarvesterCommand = $('{0} -ComputerName {1}' -f $_, $DNSCurSystem)

                                Switch -Regex ($_.ToLower()) {
                                    '\-uninstall' {
                                        $ArgHash.Commands += $InstallHarvesterCommand
                                        break
                                    }

                                    '\-install' {
                                        $ArgHash.Commands += $InstallHarvesterCommand -replace ('\-install','')
                                        $ArrRunSpaceCommands += $InstallHarvesterCommand -replace ('\-install','-copyonly')
                                        break
                                    }

                                    '\-copyonly'{
                                        $ArrRunSpaceCommands += $InstallHarvesterCommand
                                        break
                                    }

                                    default {
                                        $ArgHash.Commands += $('{0} -install' -f $InstallHarvesterCommand)
                                        $ArrRunSpaceCommands += $('{0} -copyonly' -f $InstallHarvesterCommand)
                                    }
                                }
                            }
                            {$ParamCmd -match 'Install-SysMon'} {
                                #Invoke on Agent or comment out to Run for RunSpace Only
                                $InstallSysMonCommand = $('{0} -ComputerName {1}' -f $ParamCmd, $DNSCurSystem)

                                Switch -Regex ($_.ToLower()) {
                                    '\-uninstall' {
                                        $ArgHash.Commands += $InstallSysMonCommand
                                        break
                                    }

                                    '\-install' {
                                        $ArgHash.Commands += $InstallSysMonCommand -replace ('\-install','')
                                        $ArrRunSpaceCommands += $InstallSysMonCommand -replace ('\-install','-copyonly')
                                        break
                                    }

                                    '\-copyonly' {
                                        $ArgHash.Commands += $InstallSysMonCommand
                                        break
                                    }

                                    default {
                                        $ArgHash.Commands += $('{0} -install' -f $InstallSysMonCommand)
                                        $ArrRunSpaceCommands += $('{0} -copyonly' -f $InstallSysMonCommand)
                                    }
                                }
                            }

                            Default {
                                $ArgHash.Commands += $ParamCmd
                            }
                        }
                    }
                }

                #region JSON Job ID
                    $ArgHash.JSONJob = $parameter.JSONJob
                    If ($ArgHash.JSONJOb) {
                        $ArgHash.JSON = $true
                    } else {
                        $ArgHash.JSON = $false
                    }

                    $ArgHash.JobID = $parameter.JobID
                #endregion

            #endregion Argument Hash (To be sent as arguments to the remote machine)

            #region WinRM Check and Execute remote command(s)
                If (-Not $($DNSCurSystem -eq 'localhost')) {
                    $ReturnWinRMInfo = $(Enable-BluGenieWinRMoverWMI -ComputerName $DNSCurSystem -ReturnDetails)

                    If ($ReturnWinRMInfo.EnableWinRM.Enabled) {
                        If ($ReturnWinRMInfo.EnableWinRM.PSVersion -eq 2) {
                            $ReturnWinRMInfo = $null
                            $ReturnWinRMInfo = $(Enable-BluGenieWinRMoverWMI -ComputerName $DNSCurSystem -ReturnDetails `
                                -SetValues `
                                -MaxConcurrentUsers $WinRMSettings.PS2.MaxConcurrentUsers`
                                -MaxProcessesPerShell $WinRMSettings.PS2.MaxProcessesPerShell`
                                -MaxMemoryPerShellMB $WinRMSettings.PS2.MaxMemoryPerShellMB`
                                -MaxShellsPerUser $WinRMSettings.PS2.MaxShellsPerUser`
                                -MaxShellRunTime $WinRMSettings.PS2.MaxShellRunTime
                            )
                        } Else {
                            $ReturnWinRMInfo = $null
                            $ReturnWinRMInfo = $(Enable-BluGenieWinRMoverWMI -ComputerName $DNSCurSystem -ReturnDetails `
                                -SetValues `
                                -MaxConcurrentUsers $WinRMSettings.PS3.MaxConcurrentUsers`
                                -MaxProcessesPerShell $WinRMSettings.PS3.MaxProcessesPerShell`
                                -MaxMemoryPerShellMB $WinRMSettings.PS3.MaxMemoryPerShellMB`
                                -MaxShellsPerUser $WinRMSettings.PS3.MaxShellsPerUser`
                                -MaxShellRunTime $WinRMSettings.PS3.MaxShellRunTime
                            )
                        }
                    }
                }

                Try {
                    $CurSysIP = [Net.Dns]::GetHostAddresses("$DNSCurSystem") |
                                Where-Object { $_.AddressFamily -eq 'InterNetwork' } |
                                Select-Object -ExpandProperty IPAddressToString -First 1
                } Catch {
                    $CurSysIP = 'No_Valid_IP'
                }

                #region Create Hash Table Return
                    $MyReturn = @{}
                    $MyReturn.jobid = $JobID
                    $MyReturn.$($JobID) = @{}
                    $MyReturn.$($JobID).ip = $CurSysIP
                    $MyReturn.$($JobID).$($CurSysIP) = @{}
                    $MyReturn.$($JobID).$($CurSysIP).hostname = $DNSCurSystem
                    $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem) = @{}
                    $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem).commands = @()
                    $MyReturn.WinRMEnabled = ''
                    $MyReturn.RunspaceId = $(New-BluGenieUID -ErrorAction SilentlyContinue)
                #endregion Create Hash Table Return

                If ($ReturnWinRMInfo.EnableWinRM.Enabled -or $DNSCurSystem -eq 'localhost') {
                    #region Process RunSpace Commands
                        If ($ArrRunSpaceCommands) {
                            ForEach ($CurScriptString in $ArrRunSpaceCommands) {
                                $CurScriptBlock = [Scriptblock]::Create($CurScriptString)
                                $CurScriptBlockReturn = Invoke-Command -ScriptBlock $CurScriptBlock
                                $CurCommandName = $($CurScriptString |  Select-String -Pattern '(^\w*\-\w*)').Matches[0].Value
                                $CurCommandNameNoHyphen = $($CurCommandName -replace ('-', ''))


                                $AppendOfflineDataHash.$($CurCommandName) = @{}
                                $AppendOfflineDataHash.$($CurCommandName).return = $CurScriptBlockReturn

                                $AppendData = $true
                            }
                        }
                    #endregion Process RunSpace Commands

                    If ($ArgHash.commands -or $ArgHash.AgentParallelCommands -or $ArgHash.AgentPostCommands) {
                        #region Copy Tools to Remote Host
                            ForEach ($CurTool in $($parameter.ToolsConfig)) {
                                $CurSrc = $CurTool.FullPath
                                $CurDst = $('{0}\{1}' -f $CurTool.RemoteDestination, $CurTool.Name)

                                If ($BGUpdateMods) {
                                    $null = Send-Item -Source $CurSrc -Destination $CurDst -Force -ToSession -ComputerName $DNSCurSystem -ErrorAction SilentlyContinue
                                } Else {
                                    $null = Send-Item -Source $CurSrc -Destination $CurDst -ToSession -ComputerName $DNSCurSystem -ErrorAction SilentlyContinue
                                }
                            }

                            $ArgHash.ToolsConfig =  $parameter.ToolsConfig
                        #endregion Copy Tools to Remote Host

                        #region Testing - Run in the ISE to track output (ArgHash Tracking)
                            If ($host.name -match 'ISE') {
                                [PSCustomObject]@{
                                    AgentPostCommands     = $ArgHash.AgentPostCommands
                                    #FireWallRuleEnum      = $($ArgHash.FireWallRuleEnum).Keys | Where-Object -FilterScript { $_ -ne 'Names' }
                                    JSON                  = $ArgHash.JSON
                                    JobID                 = $ArgHash.JobID
                                    Commands              = $ArgHash.commands
                                    AgentParallelCommands = $ArgHash.AgentParallelCommands
                                    BGAgentFunctions      = $ArgHash.BGAgentFunctions.Keys
                                    JSONJob               = $ArgHash.JSONJob
                                    ToolsConfig           = $ArgHash.ToolsConfig
                                    Trap                  = $ArgHash.Trap
                                } | ConvertTo-Json | Out-File -FilePath $('{0}\ArgHash_{1}.txt' -f $TranscriptsDir, $DNSCurSystem) -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Testing - Run in the ISE to track output (ArgHash Tracking)

                        If ($DNSCurSystem -eq 'localhost') {
                            $RemoteReturn = $(Invoke-Command -ScriptBlock $SendScriptBlock -ArgumentList $ArgHash)
                        } Else {
                            $RemoteReturn = $(Invoke-Command -ComputerName $DNSCurSystem -ScriptBlock $SendScriptBlock -ArgumentList $ArgHash)
                        }

                        #region Testing - Run in the ISE to track output (RemoteReturn Tracking)
                            If ($host.name -match 'ISE') {
                                $RemoteReturn | ConvertTo-Json -Depth 10 | Out-File -FilePath $('{0}\RemoteReturn_{1}.txt' -f $TranscriptsDir, $DNSCurSystem) -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Testing - Run in the ISE to track output (RemoteReturn Tracking)

                        If ($RemoteReturn) {
                            $CurRemoteJob = $RemoteReturn.jobid
                            $CurRemoteIP = $RemoteReturn.$($CurRemoteJob).ip
                            $CurRemoteHost = $RemoteReturn.$($CurRemoteJob).$($CurRemoteIP).hostname

                            $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem) = $RemoteReturn.$($CurRemoteJob).$($CurRemoteIP).$($($CurRemoteHost).Split('.')[0])

                            If (-Not $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem)) {
                                $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem) = $RemoteReturn.$($CurRemoteJob).$($CurRemoteIP).$($CurRemoteHost)
                            }
                        }
                        $MyReturn.WinRMEnabled = $($ReturnWinRMInfo.EnableWinRM)

                        If ($AppendData -eq $true) {
                            ForEach ($CurOfflineDataHash in $AppendOfflineDataHash) {
                                $CurOfflineDataHash = $_
                                $CurOfflineDataHashKey = $($CurOfflineDataHash.Keys[0] | Out-String).Trim()
                                $CurOfflineDataHashValue = [PSCustomObject]$CurOfflineDataHash.Values

                                If ($CurOfflineDataHashValue) {
                                    $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem).$($CurOfflineDataHashKey) = $($CurOfflineDataHashValue)
                                }
                            }
                            $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem).commands += $AppendOfflineDataHash.keys
                        }
                    } Else {
                        #region 1st Level
                            $MyReturn.RunspaceId = 'No Commands'
                            $MyReturn.WinRMEnabled = $ReturnWinRMInfo.EnableWinRM
                        #endregion

                        #region 3rd Level
                            If ($AppendData) {
                                $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem) += $AppendOfflineDataHash
                                $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem).commands += $AppendOfflineDataHash.keys
                            }
                        #endregion
                    }
                } Else {
                    #region 1st Level
                        $MyReturn.RunspaceId = 'Offline'
                        $MyReturn.WinRMEnabled = $ReturnWinRMInfo.EnableWinRM
                    #endregion

                    #region 3rd Level
                        If ($AppendData) {
                            $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem) += $AppendOfflineDataHash
                            $MyReturn.$($JobID).$($CurSysIP).$($DNSCurSystem).commands += $AppendOfflineDataHash.keys
                        }
                    #endregion
                }

                #$($MyReturn | ConvertTo-Json -Depth 10 -Compress) -replace '\":(\d.*?)([}|,])','":"$1"$2' -replace '\"Commands\":"N/A"','"Commands":[{}]' -replace '\"Hash\":\{\}','"Hash":""' -replace '(\"LastTaskResult\"\:)([^\"].*?)([}|,])','$1"$2"$3' -replace '(\"Value\":)([^\"]\w+)','$1"$2"'  -replace '(\"Data\":)([^\"]\w+)','$1"$2"' -replace '(\"comment\":)([^\"]\w+)','$1"$2"' | Out-File -FilePath $('{0}\InProgress\{1}.JSON' -f $JobTranscriptsDir,$LogFileName) -Encoding utf8
                $($MyReturn | ConvertTo-Json -Depth 20 -Compress) | Out-File -FilePath $('{0}\InProgress\{1}.JSON' -f $JobTranscriptsDir,$LogFileName) -Encoding utf8
            #endregion WinRM Check and Execute remote command(s)
        }

        $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'InvokeScriptBlock'

        $BluGenieInfo['ScriptSettings']['Log'] +=  "Remote ScriptBlock Set up"
    #endregion Invoke Script Block (Initial Process)

    #region Load BluGenie Helper Modules
        $PSVersionArray = $pSVersionTable.PSCompatibleVersions | ForEach-Object -Process { $('{0}.{1}' -f $_.Major,$_.Minor) }

        $ModulesLoaded = @()

        $PSContainsList = '2.0','3.0','4.0','5.0','5.1','6.0','6.1','6.2','7.0','7.1'
        #region Activate Nested Modules
            ForEach ($PSContionItem in $PSContainsList) {
                If ($PSVersionArray -contains $PSContionItem) {
                    $QueryModules = Get-ChildItem -Path $(Join-Path `
                        -Path $($BluGenieInfo.ScriptSettings.Workingpath) -ChildPath $('Dependencies\Posh{0}Min' -f $PSContionItem)) | `
                        Where-Object -FilterScript { $_.Mode -match 'd....'} | Select-Object -Property FullName,BaseName

                    If ($QueryModules) {
                        ForEach ($CurQueryModule in $QueryModules) {
                            Try {
                                If (Get-Module | Where-Object -FilterScript { $_.Name -eq $CurQueryModule.BaseName }) {
                                    Remove-Module $CurQueryModule.BaseName -Force -ErrorAction SilentlyContinue
                                }

                                Import-Module -Name $CurQueryModule.FullName -Force -ErrorAction Stop

                                $ModulesLoaded += $CurQueryModule | Select-Object -Property @{ Name        = 'Module'
                                                                                                Expression = {$CurQueryModule.BaseName}
                                                                                            },
                                                                                            @{ Name        = 'Path'
                                                                                                Expression = {$CurQueryModule.FullName}
                                                                                            }
                            } Catch {} #Don't Process

                            $CurQueryModule = $null
                        }
                    }

                    $QueryModules = $null
                }
            }
        #endregion Activate Nested Modules

        $BluGenieInfo['ScriptSettings']['LoadedModules'] += $ModulesLoaded
    #endregion Load BluGenie Helper Modules

    #region Query Core Path
        $BluGenieFunctions = Get-ChildItem -Path $(Join-Path -Path $($BluGenieInfo.ScriptSettings.Workingpath) -ChildPath 'Core') -Filter '*.ps1' -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -Property BaseName,FullName
    #endregion Query Core Path

    #region Update based on Config
        If ($ToolsConfigFile) {
            #region Load Config
                $BluGenieInfo['ScriptSettings']['Log'] += $('Loading $ToolsConfig from ({0})' -f $ToolsConfigFile)

                If ($ToolsConfigFile -match '.*\.YAML$') {
                    $ToolsConfig = $(Get-Content -Path $ToolsConfigFile -ErrorAction SilentlyContinue) | ConvertFrom-Yaml `
                        -ErrorAction SilentlyContinue
                } Else {
                    $ToolsConfig = $(Get-Content -Path $ToolsConfigFile -ErrorAction SilentlyContinue) | Out-String | ConvertFrom-Json `
                        -ErrorAction SilentlyContinue
                }

                $BluGenieInfo['ScriptSettings']['LoadedVariables'] += 'ToolsConfig'
                $BluGenieInfo['ScriptSettings']['Log'] += "Loaded ToolsConfig`n"
            #endregion Load Config

            #region Setup WSMan Configuration
                $BluGenieInfo['ScriptSettings']['Log'] += 'Loading WSMan Configuration'

                $RestartWSMan = $false
                If ($(Get-Service -Name Winrm).Status -eq 'Running') {
                    Switch ($null) {
                        #Shell Settings
                        {$(Get-Item -Path WSMan:\localhost\Shell\MaxConcurrentUsers | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.MaxConcurrentUsers)} {
                            $null = Set-Item -Path WSMan:\localhost\Shell\MaxConcurrentUsers -Value $($ToolsConfig.WSManConfig.MaxConcurrentUsers) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Shell\MaxProcessesPerShell | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.MaxProcessesPerShell)} {
                            $null = Set-Item -Path WSMan:\localhost\Shell\MaxProcessesPerShell -Value $($ToolsConfig.WSManConfig.MaxProcessesPerShell) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.MaxMemoryPerShellMB)} {
                            $null = Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value $($ToolsConfig.WSManConfig.MaxMemoryPerShellMB) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Shell\MaxShellsPerUser | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.MaxShellsPerUser)} {
                            $null = Set-Item -Path WSMan:\localhost\Shell\MaxShellsPerUser -Value $($ToolsConfig.WSManConfig.MaxShellsPerUser) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        #Plugin Quota Settings
                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentUsers | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxConcurrentUsers)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentUsers -Value $($ToolsConfig.WSManConfig.QuotasMaxConcurrentUsers) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxProcessesPerShell | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxProcessesPerShell)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxProcessesPerShell -Value $($ToolsConfig.WSManConfig.QuotasMaxProcessesPerShell) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxShells | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxShells)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxShells -Value $($ToolsConfig.WSManConfig.QuotasMaxShells) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxShellsPerUser | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxShellsPerUser)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxShellsPerUser -Value $($ToolsConfig.WSManConfig.QuotasMaxShellsPerUser) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentCommandsPerShell | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxConcurrentCommandsPerShell)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentCommandsPerShell -Value $($ToolsConfig.WSManConfig.QuotasMaxConcurrentCommandsPerShell) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }

                        {$(Get-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB | Select-Object -ExpandProperty Value) -notmatch $($ToolsConfig.WSManConfig.QuotasMaxMemoryPerShellMB)} {
                            $null = Set-Item -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB -Value $($ToolsConfig.WSManConfig.QuotasMaxMemoryPerShellMB) -ErrorAction SilentlyContinue -Force -WarningAction Ignore
                            $RestartWSMan = $true
                        }
                    }

                    #region Restart WinRM if any of the configurations changed
                        If ($RestartWSMan) {
                            $null = Restart-Service -Name WinRM -Force
                        }
                    #endregion Restart WinRM if any of the configurations changed

                    #region Output WinRM Settings
                        $BluGenieInfo['ScriptSettings']['Log'] += $("WinRM Settings:`n")
                        $BluGenieInfo['ScriptSettings']['Log'] += 'WSMan:\localhost\Shell'
                        $BluGenieInfo['ScriptSettings']['Log'] += Get-ChildItem -Path WSMan:\localhost\Shell -ErrorAction Ignore | `
                            Select-Object -Property Name,Value
                        $BluGenieInfo['ScriptSettings']['Log'] += "`nWSMan:\localhost\Plugin\microsoft.powershell\Quotas`n"
                        $BluGenieInfo['ScriptSettings']['Log'] += Get-ChildItem -Path WSMan:\localhost\Plugin\microsoft.powershell\Quotas `
                            -ErrorAction Ignore | Select-Object -Property Name,Value
                        $BluGenieInfo['ScriptSettings']['Log'] += "`n"
                        $BluGenieInfo['ScriptSettings']['Log'] += $('WSManConfigUpdated = {0}' -f $RestartWSMan)
                    #endregion Output WinRM Settings
                }

                $BluGenieInfo['ScriptSettings']['Log'] += "Loaded WSMan Configuration"
            #endregion Setup WSMan Configuration
        }
    #endregion Update based on Config

    #region Copy Downloaded Tools
        $BluGenieInfo['ScriptSettings']['Log'] += "`nDetecting Needed Project files"

        Switch ($null) {
            {Test-Path -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon.exe') -ErrorAction SilentlyContinue} {
                $null = Copy-Item -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon.exe') -Destination $ToolsDirectory\SysMon\ -Force -ErrorAction SilentlyContinue
            }

            {Test-Path -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon64.exe') -ErrorAction SilentlyContinue} {
                $null = Copy-Item -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon64.exe') -Destination $ToolsDirectory\SysMon\ -Force -ErrorAction SilentlyContinue
            }
        }
    #endregion Copy Downloaded Tools

    #region Detect Needed Project Files
        $BluGenieInfo['ScriptSettings']['Log'] += $("`nChecking External Tools:`n")

        #region WinBeats
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\WinlogBeat\winlogbeat.exe' -f $ToolsDirectory), $( Test-Path -Path $('{0}\WinlogBeat\winlogbeat.exe' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\WinlogBeat\winlogbeat.yml' -f $ToolsDirectory), $( Test-Path -Path $('{0}\WinlogBeat\winlogbeat.yml' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\WinlogBeat\fields.yml' -f $ToolsDirectory), $( Test-Path -Path $('{0}\WinlogBeat\fields.yml' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
        #endregion WinBeats

        #region SysMon
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\SysMon\blu_sysmonconfig.xml' -f $ToolsDirectory), $( Test-Path -Path $('{0}\SysMon\blu_sysmonconfig.xml' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\SysMon\Sysmon.exe' -f $ToolsDirectory), $( Test-Path -Path $('{0}\SysMon\Sysmon.exe' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
            $BluGenieInfo['ScriptSettings']['Log'] += $("{0} - OnDisk:{1}`n" -f $('{0}\Blubin\SysMon\Sysmon64.exe' -f $ToolsDirectory), $( Test-Path -Path $('{0}\SysMon\Sysmon64.exe' -f $ToolsDirectory) -ErrorAction SilentlyContinue ) )
        #endregion SysMon

        $BluGenieInfo['ScriptSettings']['Log'] +=  'Detected Needed Project files'
    #endregion Detect Needed Project Files

    #region Dynamically Build Functions from .PS1 files
        If ($BluGenieFunctions) {
            ForEach ($BluGenieFunctionItem in $BluGenieFunctions) {
                Try {
                    . $($BluGenieFunctionItem | Select-Object -ExpandProperty FullName)
                    $BluGenieInfo['ScriptSettings']['LoadedFunctions'] += $($BluGenieFunctionItem | Select-Object -ExpandProperty BaseName)
                } Catch {} #Nothing
            }
        }
    #endregion Dynamically Build Functions from .PS1 files

    #region Set Alias's (This was done to move to the new module standard and also support Posh 2)
        $null = Set-Alias -Name 'HelpMenu' -Value 'New-BluGenieHelpMenu' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'HM' -Value 'New-BluGenieHelpMenu' -Force -Description 'BluGenie'
        $null = Set-Alias -Name '??' -Value 'New-BluGenieHelpMenu' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Run' -Value 'Invoke-BluGenieProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'LogDir' -Value 'Open-BluGenieLogDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'OLD' -Value 'Open-BluGenieLogDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Log' -Value 'Open-BluGenieLog' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'OL' -Value 'Open-BluGenieLog' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ScriptDir' -Value 'Open-BluGenieScriptDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'OSD' -Value 'Open-BluGenieScriptDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'TransDir' -Value 'Open-BluGenieTransDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'OTD' -Value 'Open-BluGenieTransDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ToolsDir' -Value 'Open-BluGenieToolDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'OTools' -Value 'Open-BluGenieToolDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Ping' -Value 'Resolve-BluGenieDnsName' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Connect' -Value 'Connect-BluGenieToSystem' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Systems' -Value 'Set-BluGenieSystems' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Commands' -Value 'Set-BluGenieCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ParallelCommands' -Value 'Set-BluGenieParallelCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'PostCommands' -Value 'Set-BluGeniePostCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ThreadCount' -Value 'Set-BluGenieThreadCount' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Range' -Value 'Set-BluGenieRange' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Wipe' -Value 'Invoke-BluGenieWipe' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Settings' -Value 'Get-BluGenieSettings' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetTrap' -Value 'Set-BluGenieTrapping' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Trap' -Value 'Set-BluGenieTrapping' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Trap' -Value 'Set-BluGenieTrapping' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'JobId' -Value 'Set-BluGenieJobId' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetDebug' -Value 'Set-BluGenieDebugger' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'JobTimeout' -Value 'Set-BluGenieJobTimeout' -Force -Description 'BluGenie'
		$null = Set-Alias -Name 'GUI' -Value 'Show-BluGenieGUI' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Yara' -Value 'Invoke-BluGenieYara' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Build-Command' -Value 'New-BluGenieCommand' -Force -Description 'BluGenie'
        #-----------
        $null = Set-Alias -Name 'Add-FirewallRule' -Value 'Add-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Clear-Memory' -Value 'Clear-BlugenieMemory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Connect-ToSystem' -Value 'Connect-BluGenieToSystem' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-SID2UserName' -Value 'Convert-BluGenieSID2UserName' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-Size' -Value 'Convert-BluGenieSize' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-UserName2SID' -Value 'Convert-BluGenieUserName2SID' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-UTCtoLocal' -Value 'Convert-BluGenieUTCtoLocal' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ConvertTo-Date' -Value 'ConvertTo-BluGenieDate' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Disable-AllFirewallRules' -Value 'Disable-BluGenieAllFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Disable-FirewallRule' -Value 'Disable-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-AllFirewallRules' -Value 'Enable-BluGenieAllFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-FirewallRule' -Value 'Enable-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-WinRMoverWMI' -Value 'Enable-BluGenieWinRMoverWMI' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Expand-ArchivePS2' -Value 'Expand-BluGenieArchivePS2' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Format-Event' -Value 'Format-BluGenieEvent' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ADMachineInfo' -Value 'Get-BluGenieADMachineInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-AuditProcessTracking' -Value 'Get-BluGenieAuditProcessTracking' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-AutoRuns' -Value 'Get-BluGenieAutoRuns' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ChildItemList' -Value 'Get-BluGenieChildItemList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-COMObjectInfo' -Value 'Get-BluGenieCOMObjectInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-CurrentSessionAliases' -Value 'Get-BluGenieCurrentSessionAliases' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-CurrentSessionFunctions' -Value 'Get-BluGenieCurrentSessionFunctions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-CurrentSessionVariables' -Value 'Get-BluGenieCurrentSessionVariables' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ErrorAction' -Value 'Get-BluGenieErrorAction' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-FileADS' -Value 'Get-BluGenieFileADS' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-FilePermissions' -Value 'Get-BluGenieFilePermissions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-FileSnapshot' -Value 'Get-BluGenieFileSnapshot' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-FileStreams' -Value 'Get-BluGenieFileStreams' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-FirewallRules' -Value 'Get-BluGenieFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-HashInfo' -Value 'Get-BluGenieHashInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-HostingVersion' -Value 'Get-BluGenieHostingVersion' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-IPrange' -Value 'Get-BluGenieIPrange' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-LiteralPath' -Value 'Get-BluGenieLiteralPath' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-LoadedRegHives' -Value 'Get-BluGenieLoadedRegHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-LockingProcess' -Value 'Get-BluGenieLockingProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-MRUActivityView' -Value 'Get-BluGenieMRUActivityView' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ProcessList' -Value 'Get-BluGenieProcessList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-Registry' -Value 'Get-BluGenieRegistry' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-RegistryProcessTracking' -Value 'Get-BluGenieRegistryProcessTracking' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-RegSnapshot' -Value 'Get-BluGenieRegSnapshot' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-RunSpaceSessionAliases' -Value 'Get-BluGenieRunSpaceSessionAliases' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-RunSpaceSessionFunctions' -Value 'Get-BluGenieRunSpaceSessionFunctions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-RunSpaceSessionVariables' -Value 'Get-BluGenieRunSpaceSessionVariables' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-SchTaskInfo' -Value 'Get-BluGenieSchTaskInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ScriptDirectory' -Value 'Get-BluGenieScriptDirectory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ServiceList' -Value 'Get-BluGenieServiceList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-SessionAliasList' -Value 'Get-BluGenieSessionAliasList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-SessionFunctionList' -Value 'Get-BluGenieSessionFunctionList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-SessionVariableList' -Value 'Get-BluGenieSessionVariableList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-Settings' -Value 'Get-BluGenieSettings' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-Signature' -Value 'Get-BluGenieSignature' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-SystemInfo' -Value 'Get-BluGenieSystemInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-ToolsDirectory' -Value 'Get-BluGenieToolsDirectory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-TranscriptsDir' -Value 'Get-BluGenieTranscriptsDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-TranscriptsFile' -Value 'Get-BluGenieTranscriptsFile' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-TrapData' -Value 'Get-BluGenieTrapData' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-WindowsTitle' -Value 'Get-BluGenieWindowsTitle' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-WindowsUpdates' -Value 'Get-BluGenieWindowsUpdates' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Install-Harvester' -Value 'Install-BluGenieHarvester' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Install-SysMon' -Value 'Install-BluGenieSysMon' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-FileBrowser' -Value 'Invoke-BluGenieFileBrowser' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-LoadAllProfileHives' -Value 'Invoke-BluGenieLoadAllProfileHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-NetStat' -Value 'Invoke-BluGenieNetStat' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-Parallel' -Value 'Invoke-BluGenieParallel' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-Process' -Value 'Invoke-BluGenieProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-ProcessHash' -Value 'Invoke-BluGenieProcessHash' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-PSQuery' -Value 'Invoke-BluGeniePSQuery' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-ThreadLock' -Value 'Invoke-BluGenieThreadLock' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-UnLoadAllProfileHives' -Value 'Invoke-BluGenieUnLoadAllProfileHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-WalkThrough' -Value 'Invoke-BluGenieWalkThrough' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Walk' -Value 'Invoke-BluGenieWalkThrough' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-Wipe' -Value 'Invoke-BluGenieWipe' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Join-Objects' -Value 'Join-BluGenieObjects' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-Command' -Value 'New-BluGenieCommand' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-HelpMenu' -Value 'New-BluGenieHelpMenu' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-SessionInfo' -Value 'New-BluGenieSessionInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-TimeStamp' -Value 'New-BluGenieTimeStamp' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-UID' -Value 'New-BluGenieUID' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-Log' -Value 'Open-BluGenieLog' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-LogDir' -Value 'Open-BluGenieLogDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-ScriptDir' -Value 'Open-BluGenieScriptDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-ToolDir' -Value 'Open-BluGenieToolDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-TransDir' -Value 'Open-BluGenieTransDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Publish-FirewallRules' -Value 'Publish-BluGenieFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-File' -Value 'Remove-BluGenieFile' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-FirewallRule' -Value 'Remove-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Resolve-DnsName' -Value 'Resolve-BluGenieDnsName' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Send-Item' -Value 'Send-BluGenieItem' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-AuditProcessPol' -Value 'Set-BluGenieAuditProcessPol' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Commands' -Value 'Set-BluGenieCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Debugger' -Value 'Set-BluGenieDebugger' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-FirewallGPOStatus' -Value 'Set-BluGenieFirewallGPOStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-FirewallStatus' -Value 'Set-BluGenieFirewallStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-JobId' -Value 'Set-BluGenieJobId' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-JobTimeout' -Value 'Set-BluGenieJobTimeout' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ParallelCommands' -Value 'Set-BluGenieParallelCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-PostCommands' -Value 'Set-BluGeniePostCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Prefetch' -Value 'Set-BluGeniePrefetch' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ProcessCPUAffinity' -Value 'Set-BluGenieProcessCPUAffinity' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ProcessPriority' -Value 'Set-BluGenieProcessPriority' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Range' -Value 'Set-BluGenieRange' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-RemoteDesktopProcess' -Value 'Set-BluGenieRemoteDesktopProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-SessionInfo' -Value 'Set-BluGenieSessionInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Systems' -Value 'Set-BluGenieSystems' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ThreadCount' -Value 'Set-BluGenieThreadCount' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Trapping' -Value 'Set-BluGenieTrapping' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Show-GUI' -Value 'Show-BluGenieGUI' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Show-More' -Value 'Show-BluGenieMore' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Start-NewProcess' -Value 'Start-BluGenieNewProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Start-RunSpace' -Value 'Start-BluGenieRunSpace' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Test-IsFileLocked' -Value 'Test-BluGenieIsFileLocked' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Test-IsMutexAvailable' -Value 'Test-BluGenieIsMutexAvailable' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Trace-FireWallStatus' -Value 'Trace-BluGenieFireWallStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Update-FirewallProfileStatus' -Value 'Update-BluGenieFirewallProfileStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Update-Sysinternals' -Value 'Update-BluGenieSysinternals' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Write-VerboseMsg' -Value 'Write-BluGenieVerboseMsg' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetVerbose' -Value 'Set-BluGenieVerbose' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Verbose' -Value 'Set-BluGenieVerbose' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetNoSetRes' -Value 'Set-BluGenieNoSetRes' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'NoSetRes' -Value 'Set-BluGenieNoSetRes' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetNoExit' -Value 'Set-BluGenieNoExit' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'NoExit' -Value 'Set-BluGenieNoExit' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetNoBanner' -Value 'Set-BluGenieNoBanner' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'NoBanner' -Value 'Set-BluGenieNoBanner' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetUpdateMods' -Value 'Set-BluGenieUpdateMods' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'UpdateMods' -Value 'Set-BluGenieUpdateMods' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetServiceJob' -Value 'Set-BluGenieServiceJob' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ServiceJob' -Value 'Set-BluGenieServiceJob' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-Cores' -Value 'Set-BluGenieCores' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Cores' -Value 'Set-BluGenieCores' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ProcessPriority' -Value 'Set-BluGenieProcessPriority' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Priority' -Value 'Set-BluGenieProcessPriority' -Force -Description 'BluGenie'
    #endregion Set Alias's (This was done to move to the new module standard and also support Posh 2)

    #region Set Alias's (New Alias Name based on request)
        #These will be added to the Functions at a later point.
        $null = Set-Alias -Name 'Add-BGFirewallRule' -Value 'Add-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Clear-BGMemory' -Value 'Clear-BlugenieMemory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Connect-BGToSystem' -Value 'Connect-BluGenieToSystem' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-BGSID2UserName' -Value 'Convert-BluGenieSID2UserName' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-BGSize' -Value 'Convert-BluGenieSize' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-BGUserName2SID' -Value 'Convert-BluGenieUserName2SID' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Convert-BGUTCtoLocal' -Value 'Convert-BluGenieUTCtoLocal' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ConvertTo-BGDate' -Value 'ConvertTo-BluGenieDate' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Disable-BGAllFirewallRules' -Value 'Disable-BluGenieAllFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Disable-BGFirewallRule' -Value 'Disable-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-BGAllFirewallRules' -Value 'Enable-BluGenieAllFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-BGFirewallRule' -Value 'Enable-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Enable-BGWinRMoverWMI' -Value 'Enable-BluGenieWinRMoverWMI' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Expand-BGArchivePS2' -Value 'Expand-BluGenieArchivePS2' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Format-BGEvent' -Value 'Format-BluGenieEvent' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGADMachineInfo' -Value 'Get-BluGenieADMachineInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGAuditProcessTracking' -Value 'Get-BluGenieAuditProcessTracking' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGAutoRuns' -Value 'Get-BluGenieAutoRuns' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGChildItemList' -Value 'Get-BluGenieChildItemList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGCOMObjectInfo' -Value 'Get-BluGenieCOMObjectInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGCurrentSessionAliases' -Value 'Get-BluGenieCurrentSessionAliases' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGCurrentSessionFunctions' -Value 'Get-BluGenieCurrentSessionFunctions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGCurrentSessionVariables' -Value 'Get-BluGenieCurrentSessionVariables' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGErrorAction' -Value 'Get-BluGenieErrorAction' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGFileADS' -Value 'Get-BluGenieFileADS' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGFilePermissions' -Value 'Get-BluGenieFilePermissions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGFileSnapshot' -Value 'Get-BluGenieFileSnapshot' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGFileStreams' -Value 'Get-BluGenieFileStreams' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGFirewallRules' -Value 'Get-BluGenieFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGHashInfo' -Value 'Get-BluGenieHashInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGHelp' -Value 'Get-BluGenieHelp' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGHostingVersion' -Value 'Get-BluGenieHostingVersion' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGIPrange' -Value 'Get-BluGenieIPrange' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGLiteralPath' -Value 'Get-BluGenieLiteralPath' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGLoadedRegHives' -Value 'Get-BluGenieLoadedRegHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGLockingProcess' -Value 'Get-BluGenieLockingProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGMRUActivityView' -Value 'Get-BluGenieMRUActivityView' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGProcessList' -Value 'Get-BluGenieProcessList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRegistry' -Value 'Get-BluGenieRegistry' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRegistryProcessTracking' -Value 'Get-BluGenieRegistryProcessTracking' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRegSnapshot' -Value 'Get-BluGenieRegSnapshot' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRunSpaceSessionAliases' -Value 'Get-BluGenieRunSpaceSessionAliases' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRunSpaceSessionFunctions' -Value 'Get-BluGenieRunSpaceSessionFunctions' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGRunSpaceSessionVariables' -Value 'Get-BluGenieRunSpaceSessionVariables' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSchTaskInfo' -Value 'Get-BluGenieSchTaskInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGScriptDirectory' -Value 'Get-BluGenieScriptDirectory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGServiceList' -Value 'Get-BluGenieServiceList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSessionAliasList' -Value 'Get-BluGenieSessionAliasList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSessionFunctionList' -Value 'Get-BluGenieSessionFunctionList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSessionVariableList' -Value 'Get-BluGenieSessionVariableList' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSettings' -Value 'Get-BluGenieSettings' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSignature' -Value 'Get-BluGenieSignature' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGSystemInfo' -Value 'Get-BluGenieSystemInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGToolsDirectory' -Value 'Get-BluGenieToolsDirectory' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGTranscriptsDir' -Value 'Get-BluGenieTranscriptsDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGTranscriptsFile' -Value 'Get-BluGenieTranscriptsFile' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGTrapData' -Value 'Get-BluGenieTrapData' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGWindowsTitle' -Value 'Get-BluGenieWindowsTitle' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGWindowsUpdates' -Value 'Get-BluGenieWindowsUpdates' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Install-BGHarvester' -Value 'Install-BluGenieHarvester' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Install-BGSysMon' -Value 'Install-BluGenieSysMon' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGFileBrowser' -Value 'Invoke-BluGenieFileBrowser' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGLoadAllProfileHives' -Value 'Invoke-BluGenieLoadAllProfileHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGNetStat' -Value 'Invoke-BluGenieNetStat' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGParallel' -Value 'Invoke-BluGenieParallel' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGProcess' -Value 'Invoke-BluGenieProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGProcessHash' -Value 'Invoke-BluGenieProcessHash' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGPSQuery' -Value 'Invoke-BluGeniePSQuery' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGThreadLock' -Value 'Invoke-BluGenieThreadLock' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGUnLoadAllProfileHives' -Value 'Invoke-BluGenieUnLoadAllProfileHives' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGWalkThrough' -Value 'Invoke-BluGenieWalkThrough' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGWipe' -Value 'Invoke-BluGenieWipe' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Join-BGObjects' -Value 'Join-BluGenieObjects' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGCommand' -Value 'New-BluGenieCommand' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGHelpMenu' -Value 'New-BluGenieHelpMenu' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGSessionInfo' -Value 'New-BluGenieSessionInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGTimeStamp' -Value 'New-BluGenieTimeStamp' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGUID' -Value 'New-BluGenieUID' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-BGLog' -Value 'Open-BluGenieLog' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-BGLogDir' -Value 'Open-BluGenieLogDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-BGScriptDir' -Value 'Open-BluGenieScriptDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-BGToolDir' -Value 'Open-BluGenieToolDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Open-BGTransDir' -Value 'Open-BluGenieTransDir' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Publish-BGFirewallRules' -Value 'Publish-BluGenieFirewallRules' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-BGFile' -Value 'Remove-BluGenieFile' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-BGFirewallRule' -Value 'Remove-BluGenieFirewallRule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Resolve-BGDnsName' -Value 'Resolve-BluGenieDnsName' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Send-BGItem' -Value 'Send-BluGenieItem' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGAuditProcessPol' -Value 'Set-BluGenieAuditProcessPol' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGCommands' -Value 'Set-BluGenieCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGDebugger' -Value 'Set-BluGenieDebugger' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGFirewallGPOStatus' -Value 'Set-BluGenieFirewallGPOStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGFirewallStatus' -Value 'Set-BluGenieFirewallStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGJobId' -Value 'Set-BluGenieJobId' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGJobTimeout' -Value 'Set-BluGenieJobTimeout' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGParallelCommands' -Value 'Set-BluGenieParallelCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGPostCommands' -Value 'Set-BluGeniePostCommands' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGPrefetch' -Value 'Set-BluGeniePrefetch' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGProcessCPUAffinity' -Value 'Set-BluGenieProcessCPUAffinity' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGProcessPriority' -Value 'Set-BluGenieProcessPriority' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGRange' -Value 'Set-BluGenieRange' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGRemoteDesktopProcess' -Value 'Set-BluGenieRemoteDesktopProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGSessionInfo' -Value 'Set-BluGenieSessionInfo' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGSystems' -Value 'Set-BluGenieSystems' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGThreadCount' -Value 'Set-BluGenieThreadCount' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGTrapping' -Value 'Set-BluGenieTrapping' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Show-BGGUI' -Value 'Show-BluGenieGUI' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Show-BGMore' -Value 'Show-BluGenieMore' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Start-BGNewProcess' -Value 'Start-BluGenieNewProcess' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Start-BGRunSpace' -Value 'Start-BluGenieRunSpace' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Test-BGIsFileLocked' -Value 'Test-BluGenieIsFileLocked' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Test-BGIsMutexAvailable' -Value 'Test-BluGenieIsMutexAvailable' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Trace-BGFireWallStatus' -Value 'Trace-BluGenieFireWallStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Update-BGFirewallProfileStatus' -Value 'Update-BluGenieFirewallProfileStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Update-BGSysinternals' -Value 'Update-BluGenieSysinternals' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Write-BGVerboseMsg' -Value 'Write-BluGenieVerboseMsg' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGYara' -Value 'Invoke-BluGenieYara' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-SQLLQuery' -Value 'Invoke-BluGenieSQLLQuery' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGSQLLQuery' -Value 'Invoke-BluGenieSQLLQuery' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SQLLQ' -Value 'Invoke-BluGenieSQLLQuery' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGServiceStatus' -Value 'Get-BluGenieServiceStatus' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'New-BGService' -Value 'New-BluGenieService' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-BGService' -Value 'Remove-BluGenieService' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Stop-BGService' -Value 'Stop-BluGenieService' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Remove-BGModule' -Value 'Remove-BluGenieModule' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'BGHelp' -Value 'Get-BluGenieHelp' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Publish-BGArtifact' -Value 'Publish-BluGenieArtifact' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'BGArtifact' -Value 'Publish-BluGenieArtifact' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Artifact' -Value 'Publish-BluGenieArtifact' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-Analyzer' -Value 'Invoke-BluGenieAnalyzer' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGAnalyzer' -Value 'Invoke-BluGenieAnalyzer' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGADGroups' -Value 'Get-BluGenieADGroups' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGADG' -Value 'Get-BluGenieADGroups' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ADG' -Value 'Get-BluGenieADGroups' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGADGroupMembers' -Value 'Get-BluGenieADGroupMembers' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Get-BGADGM' -Value 'Get-BluGenieADGroupMembers' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'ADGM' -Value 'Get-BluGenieADGroupMembers' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Invoke-BGPython' -Value 'Invoke-BluGeniePython' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'BGPython' -Value 'Invoke-BluGeniePython' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Format-BGEvent' -Value 'Format-BluGenieEvent' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'BGEvent' -Value 'Format-BluGenieEvent' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-ScriptCredentials' -Value 'Set-BluGenieScriptCredentials' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'SetCred' -Value 'Set-BluGenieScriptCredentials' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGVerbose' -Value 'Set-BluGenieVerbose' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGNoSetRes' -Value 'Set-BluGenieNoSetRes' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGNoExit' -Value 'Set-BluGenieNoExit' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGNoBanner' -Value 'Set-BluGenieNoBanner' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGUpdateMods' -Value 'Set-BluGenieUpdateMods' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGServiceJob' -Value 'Set-BluGenieServiceJob' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGCores' -Value 'Set-BluGenieCores' -Force -Description 'BluGenie'
        $null = Set-Alias -Name 'Set-BGProcessPriority' -Value 'Set-BluGenieProcessPriority' -Force -Description 'BluGenie'
    #endregion Set Alias's (New Alias Name based on request)

    #region Dynamically Build Alias List

            $BluGenieInfo['ScriptSettings']['LoadedAliases'] += $(Get-Alias | Where-Object -FilterScript { $_.Description -eq 'BluGenie' } | `
                Select-Object -Property Name,Definition)

    #endregion Dynamically Build Alias List

    #region Update Function List with 3rd party Moudle Functions
        $BluGenieInfo['ScriptSettings']['LoadedFunctions'] += $($BluGenieInfo['ScriptSettings']['LoadedModules'] | ForEach-Object `
            -Process `
            {
                Get-Command -Module $_.Module | Select-Object -ExpandProperty Name
            }
        )
    #endregion Update Function List with 3rd party Moudle Functions

    #region Export Module Members
        Export-ModuleMember `
        -Function $($BluGenieInfo.ScriptSettings.LoadedFunctions) `
        -Alias $($BluGenieInfo['ScriptSettings']['LoadedAliases'] | Select-Object -ExpandProperty Name) `
        -Variable $($BluGenieInfo['ScriptSettings']['LoadedVariables'])
    #endregion Export Module Members
#endregion Main