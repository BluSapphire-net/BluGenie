#region Get-BluGenieSystemInfo (Function)
Function Get-BluGenieSystemInfo
{
<#
    .SYNOPSIS
        Return Detailed System Information

    .DESCRIPTION
        Return Detailed System Information based on
            * Logged In users
            * Operating System & Installed Date
            * System Start Time
            * General Computer Information
                - Name
                - Domain
                - Description
                - Manufacturer
                - Model
                - NumberOfProcessors
                - SystemType
                - PrimaryOwnerName
            * Disk size and freespace
            * Memory size and freespace
            * Domain and DC Names
            * PowerShell Version
            * Dot Net Version(s)
            * Windows Updates

    .PARAMETER ShowUpdates
        Description:  Show Windows Updates
        Notes: This is not set by default
        Alias:
        ValidateSet:

    .PARAMETER UseCache
        Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER RemoveCache
        Description: Remove Cache data on completion
        Notes: Cache information is removed right before the data is returned to the calling process
        Alias:
        ValidateSet:

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER DBName
        Description: Database Name (Without extention)
        Notes: The default name is set to 'BluGenie'
        Alias:
        ValidateSet:

    .PARAMETER DBPath
        Description: Path to either Save or Update the Database
        Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
        Alias:
        ValidateSet:

    .PARAMETER UpdateDB
        Description: Save return data to the Sqlite Database
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ForceDBUpdate
        Description: Force an update of the return data to the Sqlite Database
        Notes: By default only new items are saved.  The primary key is ( FullName )
        Alias:
        ValidateSet:

    .PARAMETER NewDBTable
        Description: Delete and Recreate the Database Table
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ClearGarbageCollecting
        Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
        Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: By default the data is returned as a Hash Table
        Alias:
        ValidateSet:

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias:
        ValidateSet:

    .PARAMETER OutYaml
        Description: Return detailed information in Yaml Format
        Notes: Only supported in Posh 3.0 and above
        Alias:
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
        Command: Get-BluGenieSystemInfo
        Description: General System Information
        Notes: This does not include AD, GPO, or Windows Update information

    .EXAMPLE
        Command: Get-BluGenieSystemInfo -ShowUpdates
        Description: General System Information with Windows Updates
        Notes:

    .EXAMPLE
        Command: Get-BluGenieSystemInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSystemInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSystemInfo -OutUnEscapedJSON
        Description: Get-BluGenieSystemInfo and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieSystemInfo -ReturnObject
        Description: Get-BluGenieSystemInfo and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

	.EXAMPLE
        Command: Get-BluGenieSystemInfo -ReturnObject -FormatView JSON
        Description: Get-BluGenieSystemInfo and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

	.EXAMPLE
        Command: Get-BluGenieSystemInfo -ReturnObject -FormatView Custom
        Description: Get-BluGenieSystemInfo and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1809.2301
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.03.0201
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            :
        * Link                      :
            ~
        * Dependencies              :
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               - Get-ErrorAction will round up any errors into a simple objec
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
        ~ 1809.2301:• [Michael Arroyo] Posted
        ~ 1902.0601:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
        ~ 1902.2101:• [Michael Arroyo] Updated the Disk Query.  If was not pulling disk information if there is only 1 disk.
        ~ 1904.1101:• [Michael Arroyo] Added the ReturnObject switch to return an Object instead of the default Hash Table
                    • [Michael Arroyo] Updated the WalkThrough (Dynamic Help) sub process
                    • [Michael Arroyo] Added more error control to all methods
                    • [Michael Arroyo] Cleaned up the code syntax for LoggedOnUsers.  Converted roughly 30 lines of code to 3
                    • [Michael Arroyo] Cleaned up the code syntax for Memory.  Converted roughly 100 lines of code to 8
        ~ 1905.1701:• [Michael Arroyo] Updated the Walktrough Function to version 1905.1302
                    • [Michael Arroyo] Added Parameter OutUnEscapedJSON
                    • [Michael Arroyo] Added Query for Domain Joined Information
                    • [Michael Arroyo] Added Query for PowerShell Information
                    • [Michael Arroyo] Added Query for Dot Net Information
                    • [Michael Arroyo] Update all Where-Object references to PowerShell 2
        ~ 1905.2001:• [Michael Arroyo] Added more error control around registry path checks.
        ~ 1905.2901:• [Michael Arroyo] Added Query for OS Information
                    • [Michael Arroyo] Updated the LoggedOnUser query to remove ASCII Characters that will cause issues when converting to
                                        JSON.
                    • [Michael Arroyo] Updated the Walktrough Function to version 1905.2401
        ~ 1907.1201:• [Michael Arroyo] Updated the LoggedOnUsers type to an ( Array of Objects ) to support ES readability
        ~ 1908.1301:• [Michael Arroyo] Updated the LoggedOnUsers process to pull a specific property count.  If there was a null value in
                                        any of the properties the data would move.
        ~ 2002.2401:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                    • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                    • [Michael Arroyo] Added more detailed information to the Return data
                    • [Michael Arroyo] Updated the Code to the '145' column width standard
                    • [Michael Arroyo] Fixed the (CompletedWithErrors) issue when there were no logged on users.
                    • [Michael Arroyo] Updated the Logged on User call.  It was originally only showing active sessions.  Now it queries all
                                        logged on sessions
                    • [Michael Arroyo] Added a new process to show Interactive Sessions with Process ID and Session ID information.
                    • [Michael Arroyo] Updated the (SystemStartTime) to a readable date string
                    • [Michael Arroyo] Updated the LoggedOnUsers (StartTime) to a readable date string
                    • [Michael Arroyo] Updated the InteractiveSessions (LoggedOnSince) to a readable date string
                    • [Michael Arroyo] Added a new parameter (-ShowUpdates) to gather Windows Updates
        ~ 2003.0301:• [Michael Arroyo] Updated the Get-WindowsUpdate call to pull the hash table instead of the object
        ~ 20.06.2701• [Michael Arroyo] Added a check to the (.GetRelated) method to only run on Posh 3 and up.
        ~ 21.02.1501• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                    • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                    • [Michael Arroyo] Added support for Caching
                    • [Michael Arroyo] Added support for Clearing Garbage collecting
                    • [Michael Arroyo] Added supoort for SQLite DB
                    • [Michael Arroyo] Updated Process Query and Filtering (10x faster when processing)
                    • [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                        unless you manually set the -Verbose parameter.
        ~ 21.02.2201• [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
        ~ 21.03.0201• [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
                    • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                    • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                    • [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                    • [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-SystemInfo','Get-BGSystemInfo')]
    #region Parameters
    Param
    (
        [Switch]$ShowUpdates,

		[Switch]$ClearGarbageCollecting,

		[Switch]$UseCache,

		[String]$CachePath = $('{0}\Windows\Temp\{1}.log' -f $env:SystemDrive, $(New-BluGenieUID)),

		[Switch]$RemoveCache,

		[String]$DBName = 'BluGenie',

		[String]$DBPath = $('{0}\BluGenie' -f $env:ProgramFiles),

		[Switch]$UpdateDB,

		[Switch]$ForceDBUpdate,

        [Switch]$NewDBTable,

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject,

        [Switch]$OutUnEscapedJSON,

        [Switch]$OutYaml,

		[ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')]
		[string]$FormatView = 'None'
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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['SystemInfo'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SystemInfo'].StartTime = $($StartTime).DateTime
        $HashReturn['SystemInfo'].Comments = @()
        $HashReturn['SystemInfo'].ParameterSetResults = @()
        $HashReturn['SystemInfo'].Info = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['SystemInfo'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

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

        Switch
        (
            $null
        )
        {
            {$FormatView -eq 'Yaml' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$FormatView -match 'JSON' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$OutYaml -and $IsPosh2}
            {
                $OutYaml -eq $false
                $FormatView -eq 'None'
            }

            {$FormatView -eq 'Yaml'}
            {
                $UseCache = $true
            }

            { -Not $($ClearGarbageCollecting -eq $false)}
            {
                $ClearGarbageCollecting = $true
            }

            { $ForceDBUpdate }
            {
                $UpdateDB = $true
            }

            { $NewDBTable }
            {
                $UpdateDB = $true
            }

            { $IsPosh2 }
            {
                $UpdateDB = $false
            }
        }
    #endregion Dynamic parameter update

    #region Build Data Table Hash Table
        If
        (
            $UpdateDB
        )
        {
            #region Create Hash Table
                $HSqlite = @{}
            #endregion Create Hash Table

            #region Set Database Full Path
                $HSqlite.DBPath = $DBPath
                $HSqlite.DBName = $DBName
                $HSqlite.Database = Join-Path -Path $($HSqlite.DBPath) -ChildPath $('{0}.SQLite' -f $($HSqlite.DBName))
            #endregion Set Database Full Path

            #region Table Name
                $HSqlite.TableName = 'BGSystemInfo'
            #endregion Table Name

            #region Set Column Information
                $HSqlite.TableColumns = 'ComputerInfo_Name TEXT PRIMARY KEY,
                ComputerInfo_Domain TEXT,
                ComputerInfo_Description TEXT,
                ComputerInfo_Manufacturer TEXT,
                ComputerInfo_Model TEXT,
                ComputerInfo_NumberOfProcessors TEXT,
                ComputerInfo_SystemType TEXT,
                ComputerInfo_PrimaryOwnerName TEXT,
                OSInfo_Caption TEXT,
                OSInfo_Version TEXT,
                OSInfo_InstallDate TEXT,
                OSInfo_ServicePackMajorVersion TEXT,
                OSInfo_ServicePackMinorVersion TEXT,
                OSInfo_RegisteredUser TEXT,
                DomainInfo_DCName TEXT,
                DomainInfo_MachineDomain TEXT,
                DomainInfo_DomainJoined TEXT,
                Total_Physical_Memory TEXT,
                Available_Physical_Memory TEXT,
                Virtual_Memory_Max_Size TEXT,
                Virtual_Memory_Available TEXT,
                Virtual_Memory_In_Use TEXT,
                LoggedOnUsers TEXT,
                InteractiveSessions TEXT,
                PowerShellVersion TEXT,
                RuntimeVersion TEXT,
                PSCompatibleVersion TEXT,
                DotNetVersion TEXT,
                DiskInfo TEXT,
                Comments TEXT,
                WindowsUpdates TEXT'
            #endregion Set Column Information

            #region Set Create Table SQL String
                $HSqlite.CreateTableStr = $('CREATE TABLE IF NOT EXISTS {0} ({1})' -f $HSqlite.TableName, $HSqlite.TableColumns)
            #endregion Set Create Table SQL String

            #region Drop Table SQL String
                $HSqlite.DropTableStr = $('DROP TABLE IF EXISTS {0}' -f $HSqlite.TableName)
            #endregion Drop Table SQL String

            #region Set Check Table SQL String
                $HSqlite.CheckTables = $('PRAGMA table_info({0})' -f $HSqlite.TableName)
            #endregion Set Check Table SQL String

            #region Create DB Table
                If
                (
                    -Not $(Test-Path -Path $DBPath)
                )
                {
                    $null = New-Item -Path  $DBPath -ItemType Directory -Force
                }

                #region New DB Table
                    If
                    (
                        $NewDBTable
                    )
                    {
                        Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.DropTableStr
                    }
                #endregion New DB Table

                Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.CreateTableStr
            #endregion Create DB Table
        }
    #endregion Build Data Table Hash Table

    #region Main
        #region Loading Sub Functions
			#region Get-LoggedOnUser
				Function Get-LoggedOnUser
				{
					param
					(
						$ComputerName = $Env:COMPUTERNAME
					)

					$regexa = '.+Domain="(.+)",Name="(.+)"$'
					$regexd = '.+LogonId="(\d+)"$'

					$logontype = @{
						"0"="Local System"
						"2"="Interactive" #(Local logon)
						"3"="Network" # (Remote logon)
						"4"="Batch" # (Scheduled task)
						"5"="Service" # (Service account logon)
						"7"="Unlock" #(Screen saver)
						"8"="NetworkCleartext" # (Cleartext network logon)
						"9"="NewCredentials" #(RunAs using alternate credentials)
						"10"="RemoteInteractive" #(RDP\TS\RemoteAssistance)
						"11"="CachedInteractive" #(Local w\cached credentials)
					}

					$logon_sessions = @(Get-WmiObject -Class win32_logonsession -ComputerName $computername -ErrorAction SilentlyContinue)
					$logon_users = @(Get-WmiObject -Class win32_loggedonuser -ComputerName $computername)

					$session_user = @{}

					$logon_users | ForEach-Object `
					-Process `
					{
						$_.antecedent -match $regexa > $nul
						$username = $matches[1] + "\" + $matches[2]
						$_.dependent -match $regexd > $nul
						$session = $matches[1]
						$session_user[$session] += $username
					}

					$LoggedOn = @()

					$logon_sessions | ForEach-Object `
					-Process `
					{
						$starttime = [management.managementdatetimeconverter]::todatetime($_.starttime)

						$loggedonuser = New-Object -TypeName psobject
						$loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid
						$loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid]
						$loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.tostring()]
						$loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage
						$loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $($($starttime | Out-String) -replace '\r|\n')

						$null = $LoggedOn += $loggedonuser
					}

					Return $LoggedOn
				}
			#endregion Get-LoggedOnUser

			#region Get-InteractiveSession
				function Get-InteractiveSession
				{
					param
					(

					)

					$explorerprocesses = @()
					$explorerprocesses += @(Get-WmiObject -Query "Select * FROM Win32_Process WHERE Name='explorer.exe'" -ErrorAction SilentlyContinue)
					If ($explorerprocesses.Count -eq 0)
					{
							$ExplorerItem = New-Object -TypeName psobject
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "Username" -Value 'No explorer process found / Nobody interactively logged on'
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "Domain" -Value ''
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "LoggedOnSince" -Value ''
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "ProcessId" -Value ''
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "SessionId" -Value ''

							$explorerprocesses += $ExplorerItem
					}
					Else
					{
                        $explorerprocesses | ForEach-Object `
						-Process `
                        {
							$ExplorerItem = $_
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "Username" -Value $ExplorerItem.GetOwner().User
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "Domain" -Value $ExplorerItem.GetOwner().Domain
							$ExplorerItem | Add-Member -MemberType NoteProperty -Name "LoggedOnSince" -Value $($($($ExplorerItem.ConvertToDateTime($ExplorerItem.CreationDate)) | Out-String) -replace '\r|\n')
                        }
					}

					Return $explorerprocesses | Select-Object -Property 'Username','Domain','LoggedOnSince','ProcessId','SessionId'
				}
			#endregion Get-InteractiveSession
		#endregion Loading Sub Functions

        #region Query LoggedOnUsers
			$LoggedOnUsers = Get-LoggedOnUser
			$InteractiveSessions = Get-InteractiveSession
        #endregion Query LoggedOnUsers

        #region Query OSInfo
            $OSInfo = $(Get-WmiObject -Class Win32_OperatingSystem -ErrorAction SilentlyContinue) | `
				Select-Object -Property Caption,
                                        Version,
										@{
											Name = 'InstallDate'
											Expression = {$($_.ConverttoDateTime($_.InstallDate) | Out-String).trim()}
										},
										ServicePackMajorVersion,
										ServicePackMinorVersion,
										RegisteredUser
        #endregion Query OSInfo

        #region Query SystemStartTime
            $SystemStartTime = $(Get-WmiObject win32_operatingsystem | `
				Select-Object @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} | `
				Select-Object -ExpandProperty LastBootUpTime | Out-String) -replace '\r|\n'
        #endregion Query SystemStartTime

        #region Query ComputerInfo
            $ComputerInfo = Get-WmiObject -Query 'SELECT * FROM Win32_ComputerSystem' -ErrorAction SilentlyContinue |
                Select-Object -Property Name,
                    Domain,
                    Description,
                    Manufacturer,
                    Model,
                    NumberOfProcessors,
                    SystemType,
                    PrimaryOwnerName
        #endregion Query ComputerInfo

        #region Query Memory
            $Error.Clear()
            $MemoryResults = Invoke-Expression -Command 'systeminfo' -ErrorAction SilentlyContinue | Select-String -SimpleMatch -Pattern 'memory'

            $MemoryObj = New-Object -TypeName System.Object
            $MemoryResults -replace ('\n+','') -replace ('Virtual Memory\:','Virtual Memory') -replace ('\:\s+',':') -replace ('\s','_') | `
				ForEach-Object `
                -Process `
                {
                    $CurrentMemItem = $_
                    $CurrentMemSplit = $CurrentMemItem -split ':'
                    $MemoryObj | Add-Member -MemberType NoteProperty -Name $CurrentMemSplit[0] -Value $CurrentMemSplit[1] -Force `
					-ErrorAction SilentlyContinue
                }
        #endregion Query Memory

        #region Query Disk Info
            $Error.Clear()
            $Disk = Get-WMIObject -Class Win32_Logicaldisk -Filter "DriveType = '3'" -ErrorAction SilentlyContinue

            If
            (
                $PSVersionTable.PSVersion.Major -gt 2
            )
            {
                $DiskPartition = $Disk.GetRelated('Win32_DiskPartition')
                #$DiskPartition.GetRelationships() | Select-Object -Property __RELPATH
            }

            If
            (
                $PSVersionTable.PSVersion.Major -gt 2
            )
            {
                $DiskDrive = $DiskPartition.getrelated('Win32_DiskDrive')
            }

            #$Volume = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter = 'C:'"

            $ArrDiskInfo = @()

            If
            (
                $($Disk | Measure-Object | Select-Object -ExpandProperty Count) -eq 1
            )
            {
                $PropDiskInfo = @{
                    Disk_DeviceID = $($Disk.DeviceID)
                    Disk_Caption = $($Disk.Caption)
                    Disk_Compressed = $($Disk.Compressed)
                    Disk_DriveType = $($Disk.DriveType)
                    Disk_FileSystem = $($Disk.FileSystem)
                    Disk_FreeSpace = $($Disk.FreeSpace)
                    Disk_FreeSpaceGB = $([math]::Round($($Disk.FreeSpace)/1GB,2))
                    Disk_Name = $($Disk.Name)
                    Disk_Size = $($Disk.Size)
                    Disk_SizeGB = $($($Disk.Size)/1GB -as [int])
                    Disk_VolumeDirty = $($Disk.VolumeDirty)
                    Disk_Path = $($Disk.Path).Path
                    DiskPartition_Index = $($DiskPartition.Index)
                    DiskPartition_Name = $($DiskPartition.Name)
                    DiskPartition_Caption = $($DiskPartition.Caption)
                    DiskPartition_DeviceID = $($DiskPartition.DeviceID)
                    DiskPartition_DiskIndex = $($DiskPartition.DiskIndex)
                    DiskPartition_PrimaryPartition = $($DiskPartition.PrimaryPartition)
                    DiskPartition_Type = $($DiskPartition.Type)
                    DiskPartition_Path = $($DiskPartition.Path).Path
                    DiskDrive_Status = $($DiskDrive.Status)
                    DiskDrive_DeviceID = $($DiskDrive.DeviceID)
                    DiskDrive_Partitions = $($DiskDrive.Partitions)
                    DiskDrive_Index = $($DiskDrive.Index)
                    DiskDrive_InterfaceType = $($DiskDrive.InterfaceType)
                    DiskDrive_Caption = $($DiskDrive.Caption)
                    DiskDrive_MediaLoaded = $($DiskDrive.MediaLoaded)
                    DiskDrive_MediaType = $($DiskDrive.MediaType)
                    DiskDrive_Model = $($DiskDrive.Model)
                    DiskDrive_Name = $($DiskDrive.Name)
                    DiskDrive_Path = $($DiskDrive.Path).Path
                }

                $ArrDiskInfo += New-Object -TypeName PSObject -Property $PropDiskInfo
            }
            Else
            {
                For
                (
                    $DiskCount = 0
                    $DiskCount -lt $Disk.Count
                    $DiskCount++
                )
                {
                    $PropDiskInfo = @{
                        Disk_DeviceID = $($Disk[$DiskCount].DeviceID)
                        Disk_Caption = $($Disk[$DiskCount].Caption)
                        Disk_Compressed = $($Disk[$DiskCount].Compressed)
                        Disk_DriveType = $($Disk[$DiskCount].DriveType)
                        Disk_FileSystem = $($Disk[$DiskCount].FileSystem)
                        Disk_FreeSpace = $($Disk[$DiskCount].FreeSpace)
                        Disk_FreeSpaceGB = $([math]::Round($($Disk[$DiskCount].FreeSpace)/1GB,2))
                        Disk_Name = $($Disk[$DiskCount].Name)
                        Disk_Size = $($Disk[$DiskCount].Size)
                        Disk_SizeGB = $($($Disk[$DiskCount].Size)/1GB -as [int])
                        Disk_VolumeDirty = $($Disk[$DiskCount].VolumeDirty)
                        Disk_Path = $($Disk[$DiskCount].Path).Path
                        DiskPartition_Index = $($DiskPartition[$DiskCount].Index)
                        DiskPartition_Name = $($DiskPartition[$DiskCount].Name)
                        DiskPartition_Caption = $($DiskPartition[$DiskCount].Caption)
                        DiskPartition_DeviceID = $($DiskPartition[$DiskCount].DeviceID)
                        DiskPartition_DiskIndex = $($DiskPartition[$DiskCount].DiskIndex)
                        DiskPartition_PrimaryPartition = $($DiskPartition[$DiskCount].PrimaryPartition)
                        DiskPartition_Type = $($DiskPartition[$DiskCount].Type)
                        DiskPartition_Path = $($DiskPartition[$DiskCount].Path).Path
                        DiskDrive_Status = $($DiskDrive[$DiskCount].Status)
                        DiskDrive_DeviceID = $($DiskDrive[$DiskCount].DeviceID)
                        DiskDrive_Partitions = $($DiskDrive[$DiskCount].Partitions)
                        DiskDrive_Index = $($DiskDrive[$DiskCount].Index)
                        DiskDrive_InterfaceType = $($DiskDrive[$DiskCount].InterfaceType)
                        DiskDrive_Caption = $($DiskDrive[$DiskCount].Caption)
                        DiskDrive_MediaLoaded = $($DiskDrive[$DiskCount].MediaLoaded)
                        DiskDrive_MediaType = $($DiskDrive[$DiskCount].MediaType)
                        DiskDrive_Model = $($DiskDrive[$DiskCount].Model)
                        DiskDrive_Name = $($DiskDrive[$DiskCount].Name)
                        DiskDrive_Path = $($DiskDrive[$DiskCount].Path).Path
                    }

                    $ArrDiskInfo += New-Object -TypeName PSObject -Property $PropDiskInfo
                }
            }
        #endregion Query Disk Info

        #region Query Domain Info
            $Error.Clear()
            $DomainInfo = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' `
			-ErrorAction SilentlyContinue

            $DomainInfoHash = @{
                MachineDomain = ''
                DCName = ''
                DomainJoined = $false
            }

            Switch
            (
                $null
            )
            {
                #If MachineDomain key is found
                {$DomainInfo.MachineDomain}
                {
                    $DomainInfoHash.MachineDomain = $DomainInfo.MachineDomain
                    $DomainInfoHash.DomainJoined = $true
                }
                #If DCName key is found
                {$DomainInfo.DCName}
                {
                    $DomainInfoHash.DCName = $DomainInfo.DCName
                }
            }
        #endregion Query Domain Info

        #region Query PowerShell Info
            $PS1 = $(Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine') -ErrorAction SilentlyContinue)
            $PS3 = $(Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine') -ErrorAction SilentlyContinue)

            $PSVerArr = @()

            Switch
            (
                $null
            )
            {
                {$PS1 -ne $null}
                {
                    $PSVerArr += New-Object -TypeName PSObject -Property @{
                        PowerShellVersion = $($ps1.PowerShellVersion)
                        PSCompatibleVersion = $($ps1.PSCompatibleVersion)
                        RuntimeVersion = $($ps1.RuntimeVersion)
                    }
                }

                {$PS3 -ne $null}
                {
                    $PSVerArr += New-Object -TypeName PSObject -Property @{
                        PowerShellVersion = $($ps3.PowerShellVersion)
                        PSCompatibleVersion = $($ps3.PSCompatibleVersion)
                        RuntimeVersion = $($ps3.RuntimeVersion)
                    }
                }
            }

            $DotNetVerArray = @()
            $Error.Clear()
            Try
            {
                If
                (
                    Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -ErrorAction Stop
                )
                {
                    $DotNetVersions = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -ErrorAction Stop | Select-Object -Property PSChildName | Where-Object -FilterScript { $_.PSChildName -Match '^v' } | Select-Object -ExpandProperty PSChildName
                }
            }
            Catch
            {
                $null
            }

            $DotNetVersions | ForEach-Object `
            -Process `
            {
                $CurFullVersion = $_
                If
                (
                    $CurFullVersion -match '\.'
                )
                {
                    $CurVersion = $($CurFullVersion -split ('\.'))[0] -Replace('v','')
                }
                Else
                {
                    $CurVersion = $($CurFullVersion -Replace('v',''))
                }


                If
                (
                    $CurVersion -lt 4
                )
                {
                    $CurDotNetFullVersionClient = $null
                    Try
                    {
                        If
                        (
                            Test-Path -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}' -f $CurFullVersion) -ErrorAction Stop
                        )
                        {
                            $CurDotNetFullVersionFull = Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}' -f $CurFullVersion) -ErrorAction Stop | Select-Object -ExpandProperty 'Version' -ErrorAction SilentlyContinue
                        }
                    }
                    Catch
                    {
                        $null
                    }

                }
                Else
                {
                    Try
                    {
                        If
                        (
                            Test-Path -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}\Client' -f $CurFullVersion) -ErrorAction Stop
                        )
                        {
                            $CurDotNetFullVersionClient = Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}\Client' -f $CurFullVersion) -ErrorAction Stop | Select-Object -ExpandProperty 'Version' -ErrorAction SilentlyContinue
                        }
                    }
                    Catch
                    {
                        $null
                    }
                    Try
                    {
                        If
                        (
                            Test-Path -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}\Full' -f $CurFullVersion) -ErrorAction Stop
                        )
                        {
                            $CurDotNetFullVersionFull = Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\{0}\Full' -f $CurFullVersion) -ErrorAction Stop | Select-Object -ExpandProperty 'Version' -ErrorAction SilentlyContinue
                        }
                    }
                    Catch
                    {
                        $null
                    }
                }

                $DotNetVerArray += New-Object -TypeName PSObject -Property @{
                    Installed = $CurFullVersion
                    FullVer = $CurDotNetFullVersionFull
                    ClientVer = $CurDotNetFullVersionClient
                }
            }
        #endregion Query PowerShell Info

		#region Query Windows Updates
			If
			(
				$ShowUpdates
			)
			{
                try
                {
                    $WindowsUpdates = $(Get-BluGenieWindowsUpdates -ErrorAction SilentlyContinue).WindowsUpdates.Updates
                }
                catch
                {
                    #Nothing
                }
			}
		#endregion Query Windows Updates
    #endregion Main

    #region Setup Caching
        $ResultSet = $(New-Object -TypeName PSObject -Property @{
            ComputerInfo_Name = $ComputerInfo.Name
            ComputerInfo_Domain = $ComputerInfo.Domain
            ComputerInfo_Description = $ComputerInfo.Description
            ComputerInfo_Manufacturer = $ComputerInfo.Manufacturer
            ComputerInfo_Model = $ComputerInfo.Model
            ComputerInfo_NumberOfProcessors = $ComputerInfo.NumberOfProcessors
            ComputerInfo_SystemType = $ComputerInfo.SystemType
            ComputerInfo_PrimaryOwnerName = $ComputerInfo.PrimaryOwnerName
            OSInfo_Caption = $OSInfo.Caption
            OSInfo_Version = $OSInfo.Version
            OSInfo_InstallDate = $OSInfo.InstallDate
            OSInfo_ServicePackMajorVersion = $osinfo.ServicePackMajorVersion
            OSInfo_ServicePackMinorVersion = $OSInfo.ServicePackMinorVersion
            OSInfo_RegisteredUser = $osinfo.RegisteredUser
            DomainInfo_DCName = $DomainInfoHash.DCName
            DomainInfo_MachineDomain = $DomainInfoHash.MachineDomain
            DomainInfo_DomainJoined = $DomainInfoHash.DomainJoined
            Total_Physical_Memory = $MemoryObj.Total_Physical_Memory
            Available_Physical_Memory = $MemoryObj.Available_Physical_Memory
            Virtual_Memory_Max_Size = $MemoryObj.Virtual_Memory_Max_Size
            Virtual_Memory_Available = $MemoryObj.Virtual_Memory_Available
            Virtual_Memory_In_Use = $MemoryObj.Virtual_Memory_In_Use
            LoggedOnUsers = @($LoggedOnUsers)
            InteractiveSessions = @($InteractiveSessions)
            PowerShellVersion = $PSVerArr.PowerShellVersion
            RuntimeVersion = $PSVerArr.RuntimeVersion
            PSCompatibleVersion = $PSVerArr.PSCompatibleVersion
            DotNetVersion = $DotNetVersions
            DiskInfo = @($ArrDiskInfo)
            Comments = @()
            WindowsUpdates = @($WindowsUpdates)
        })

        $Null = Remove-Variable -Name ComputerInfo -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name OSInfo -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name DomainInfoHash -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name MemoryObj -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name LoggedOnUsers -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name InteractiveSessions -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name PSVerArr -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name DotNetVersions -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name ArrDiskInfo -ErrorAction SilentlyContinue
        $Null = Remove-Variable -Name WindowsUpdates -ErrorAction SilentlyContinue

        If
        (
            $UseCache
        )
        {
            '---' | Out-File -FilePath $CachePath -Append -Force
            $ResultSet | ConvertTo-Yaml | Out-File $CachePath -Append -Force
        }
        Else
        {
            $HashReturn['SystemInfo'].Info += $ResultSet
        }

        If
        (
            $UpdateDB
        )
        {
            $ResultSet.LoggedOnUsers = $ResultSet.LoggedOnUsers | ConvertTo-Json -Compress
            $ResultSet.InteractiveSessions = $ResultSet.InteractiveSessions | ConvertTo-Json -Compress
            $ResultSet.DiskInfo = $ResultSet.DiskInfo | ConvertTo-Json -Compress
            $ResultSet.Comments = $ResultSet.Comments | ConvertTo-Json -Compress
            $ResultSet.WindowsUpdates = $ResultSet.WindowsUpdates | ConvertTo-Json -Compress

            If
            (
                $ForceDBUpdate
            )
            {
                Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($ResultSet | `
                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
            }
            Else
            {
                Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($ResultSet | `
                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
            }
        }
    #endregion Setup Caching

    #region Service Count
		If
		(
			$UseCache
		)
		{
			$HashReturn['SystemInfo'].Info += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
            If
            (
                $RemoveCache
            )
            {
                $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
            }
		}
	#endregion Service Count

    #region Cleanup
    $Null = Remove-Variable -Name ResultSet -ErrorAction SilentlyContinue

    If
    (
        $ClearGarbageCollecting
    )
    {
            $null = Clear-BlugenieMemory
    }
    #endregion Cleanup

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SystemInfo'].EndTime = $($EndTime).DateTime
        $HashReturn['SystemInfo'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
            Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Remove Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['SystemInfo'].Remove('StartTime')
            $null = $HashReturn['SystemInfo'].Remove('ParameterSetResults')
            $null = $HashReturn['SystemInfo'].Remove('CachePath')
            $null = $HashReturn['SystemInfo'].Remove('EndTime')
            $null = $HashReturn['SystemInfo'].Remove('ElapsedTime')
        }

        #region Output Type
            switch
            (
                $Null
            )
            {
                #region Beautify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                    }
                #endregion Beautify the JSON return and not Escape any Characters

                #region Yaml Output of Hash Information
                    { $OutYaml }
                    {
                        Return $($HashReturn | ConvertTo-Yaml)
                    }
                #endregion Yaml Output of Hash Information

                #region Return a PowerShell Object
                    { $ReturnObject }
                    {
                        #region Switch FormatView
                            switch
                            (
                                $FormatView
                            )
                            {
                                #region Table
                                    'Table'
                                    {
                                        Return $($ResultSet | Format-Table -AutoSize -Wrap)
                                    }
                                #endregion Table

                                #region CSV
                                    'CSV'
                                    {
                                        Return $($ResultSet | ConvertTo-Csv -NoTypeInformation)
                                    }
                                #endregion CSV

                                #region Yaml
                                    'Yaml'
                                    {
                                        $ResultSet = Get-Content -Path $CachePath
                                        If
                                        (
                                            $RemoveCache
                                        )
                                        {
                                            $Null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                                        }

                                        Return $($ResultSet)
                                    }
                                #endregion Yaml

                                #region CustomModified
                                    'CustomModified'
                                    {
                                        Return $($ResultSet | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
                                    }
                                #endregion CustomModified

                                #region Custom
                                    'Custom'
                                    {
                                        Return $($ResultSet | Format-Custom)
                                    }
                                #endregion Custom

                                #region JSON
                                    'JSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10)
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                            -Process `
                                            {
                                                [regex]::Unescape($_)
                                            }
                                        )
                                    }
                                #endregion OutUnEscapedJSON

                                #region Default
                                    Default
                                    {
                                        Return $ResultSet
                                    }
                                #endregion Default
                            }
                        #endregion Switch Statement RegEx
                    }
                #endregion Return a PowerShell Object

                #region Default
                    Default
                    {
                        Return $HashReturn
                    }
                #endregion Default
            }
        #endregion Output Type
    #endregion Output
}
#endregion Get-BluGenieSystemInfo (Function)