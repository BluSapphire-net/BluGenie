#region Get-BluGenieServiceList (Function)
function Get-BluGenieServiceList
{
<#
    .SYNOPSIS
        Get a full list of Services, with Process Handle information

    .DESCRIPTION
        Get a full list of Services, with Process Handle information

    .PARAMETER Algorithm
        Description:  Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
        Notes:  The acceptable values for this parameter are:

                    - SHA1
                    - SHA256
                    - SHA384
                    - SHA512
                    - MACTripleDES
                    - MD5 = (Default)
                    - RIPEMD160
        Alias:
        ValidateSet: 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'

	.PARAMETER FilterType
		Description:  Which property to filter by
        Notes:
            Filter Option
			•	"Name"
						Service Name (Default Value)
            •	"DesktopInteract"
						Does the service interact with the Desktop [ True / False ]
            •	"PathName"
						Service Path
            •	"ServiceType"
						Service Type ( Share Process / Own Process )
            •	"StartMode"
						Start Mode ( Manual / Started / Auto )
            •	"Caption"
						Service Caption
            •	"Description"
						Service Description
            •	"DisplayName"
						Service Display Name
            •	"InstallDate"
						Service Installed Date
            •	"ProcessId"
						The current Process ID associated with the Service
            •	"Started"
						Is the Service currently Started ( True / False )
            •	"StartName"
						What Account is the Service associated with
            •	"State"
						Running state of the currect service ( Running / Stopped )
            •	"ProcessName"
						The Process name associated with the Service
            •	"ProcessPath"
						The path of the Process associated with the Service
            •	"ProcessCommandLine"
						The command line used with the Service
            •	"ProcessSessionId"
						The Process ID (PID) associated with the Service
            •	"ProcessOwner"
						The Owner of the Process
            •	"ServiceExecPath"
						Path to the Service
            •	"Hash"
						The Hash value of the Process ( MACTripleDES / MD5 / RIPEMD160 / SHA1 / SHA256 / SHA384 / SHA512 )
            •	"Signature_Comment"
						Display error message while pulling Signature Information [Note: This is only available if you use the -Signature switch]
            •	"Signature_FileVersion"
						File Version and OS Build information in part of the OS [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Description"
						The description of the files signature [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Date"
						Date when the file was signed [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Company"
						The company signing the file [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Publisher"
						The Publisher signing the file [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Verified"
						Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use the -Signature switch]
		Alias:
		ValidateSet: 'Name','DesktopInteract','PathName','ServiceType','StartMode','Caption','Description','DisplayName','InstallDate','ProcessId','Started','StartName','State','ProcessName','ProcessPath','ProcessCommandLine','ProcessSessionId','ProcessOwner','ServiceExecPath','Hash','Signature_Comment','Signature_FileVersion','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified'

    .PARAMETER Pattern
        Description: Search Pattern using RegEx
        Notes: Default Value = '.*'
        Alias:
        ValidateSet:

	.PARAMETER Managetype
		Description: Manage the behavior of the process (Suspend, Resume, Stop)
		Notes:
		Alias:
		ValidateSet: Suspend,Resume,Stop

	.PARAMETER ManageServicetype
		Description: Manage the behavior of the Service (Suspend, Resume, Remove)
		Notes:
		Alias:
		ValidateSet: Suspend,Resume,Remove

	.PARAMETER Signature
		Description: Query Signature information
		Notes:
		Alias:
		ValidateSet:

	.PARAMETER TrackChanges
		Description: Backup and Track the changes to the Service you are modifying
		Notes: Values stored in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\ServiceList'
		Alias:
		ValidateSet:

	.PARAMETER OverrideTracked
		Description: Force a Backup and Track the changes to the Service you are modifying
		Notes: Values stored in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\ServiceList'
		Alias:
		ValidateSet:

	.PARAMETER RevertTracked
		Description: Restore the Tracked changes to the Service you originally modified
		Notes:
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
		Command: Get-BluGenieServiceList
        Description: Return information for all running Services and associated Processes
        Notes:
				- Sample Output -
                    "Name":  "WpnUserService_9faea",
                    "DesktopInteract":  false,
                    "PathName":  "C:\\WINDOWS\\system32\\svchost.exe -k UnistackSvcGroup",
                    "ServiceType":  "Unknown",
                    "StartMode":  "Auto",
                    "Caption":  "Windows Push Notifications User Service_9faea",
                    "Description":  "This service hosts Windows notification platform which provides support for local and push notifications. ",
                    "DisplayName":  "Windows Push Notifications User Service_9faea",
                    "InstallDate":  null,
                    "ProcessId":  1388,
                    "Started":  true,
                    "StartName":  null,
                    "State":  "Running",
                    "ProcessName":  "svchost.exe",
                    "ProcessPath":  "c:\\windows\\system32\\svchost.exe",
                    "ProcessCommandLine":  "c:\\windows\\system32\\svchost.exe -k unistacksvcgroup -s WpnUserService",
                    "ProcessSessionId":  1,
                    "ProcessOwner":  "TESTLAB\\Administrator",
                    "ServiceExecPath":  "C:\\WINDOWS\\system32\\svchost.exe",
                    "Hash":  "32569e403279b3fd2edb7ebd036273fa"

    .EXAMPLE
		Command: Get-BluGenieServiceList -Algorithm SHA256
        Description: Change the Algorithm to SHA256
        Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -FilterType Name -Pattern Maps
		Description: Filter running Services and associated Processes that match the search value
		Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -FilterType Name -Pattern 'XboxNetApiSvc' -ManageServicetype Stop
		Description: Stop the Service ( XboxNetApiSvc )
		Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -FilterType Hash -Pattern 'bfbecf7e48cbdbf1fb2c51164ef9e5f5' -Managetype Stop
		Description: Terminate the Process associated with the Service
		Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -Pattern 'XboxNetApiSvc' -ManageServicetype Stop -TrackChanges
		Description: Track changes to the Service.  All information will be added to the registr under HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\ServiceList
		Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -Pattern 'XboxNetApiSvc' -ManageServicetype Stop -TrackChanges -OverrideTracked
		Description: Override or Force the Tracked informatrion to be tracked again
		Notes:

	.EXAMPLE
		Command: Get-BluGenieServiceList -Pattern 'XboxNetApiSvc' -OutUnEscapedJSON -RevertTracked
		Description:
		Notes:

    .EXAMPLE
		Command: Get-BluGenieServiceList -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
		Command: Get-BluGenieServiceList -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
		Command: Get-BluGenieServiceList -OutUnEscapedJSON
        Description: Get-BluGenieServiceList and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
		Command: Get-BluGenieServiceList -ReturnObject
        Description: Get-BluGenieServiceList and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

	.EXAMPLE
        Command: Get-BluGenieServiceList -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1807.2801
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.03.0201
        * Comments                  :
        * Dependencies              :
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o  New-BluGenieUID or New-UID - Create a New UID
            o  ConvertTo-Yaml - ConvertTo Yaml
            o  Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o  ConvertFrom-Yaml - Convert From Yaml
            o  Invoke-SQLiteBulkCopy - Inject Bulk data into a SQL Lite Database

#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
	~ 1807.2801:• [Michael Arroyo] Posted
	~ 1901.0501:• [Michael Arroyo] Added a new switch parameter (QueryResultsOnly) to all only the Query Results to be returned and not
										the entire service list
	~ 1901.2001:• [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
				• [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
				• [Michael Arroyo] Updated the Help information
				• [Michael Arroyo] Added new parameter to Manage-ProcessHash to now support the updated Hash Algorithm
	~ 1902.0601:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
	~ 1902.1101:• [Michael Arroyo] Fixed the Validation Set for ManageType and ManageServicetype
	~ 1902.1201:• [Michael Arroyo] Converted the entire function to use the new search process
	~ 1902.1202:• [Michael Arroyo] Removed the $PSItem variable and replaced with with $_.  $PSItem was causing issues.
	~ 1902.2501:• [Michael Arroyo] Added Signature switch.  This will pull the Signature information for the giving file or process.
				• [Michael Arroyo] Added the Signature Search options to the -FilterType Search string
	~ 1902.2601:• [Michael Arroyo] Update the Hash path to point to the ServiceExecPath Object.  This was done due to system PID coming
									back as (Zero) and no process path found.
	~ 1902.2602:• [Michael Arroyo] Updated the Return for -Pattern check.  It was not returning the entire hash table correctly.
	~ 1912.0401:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
				• [Michael Arroyo] Updated the Hash Information to follow the new function standards
				• [Michael Arroyo] Added more detailed information to the Return data
				• [Michael Arroyo] Forced Type Cast "Name" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "DesktopInteract" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "PathName" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ServiceType" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "StartMode" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "Caption" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "Description" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "DisplayName" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "Started" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "StartName" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "State" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ProcessName" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ProcessPath" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ProcessCommandLine" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ProcessOwner" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "ServiceExecPath" to [Text] to support Elastic Search
				• [Michael Arroyo] Forced Type Cast "Hash" to [Text] to support Elastic Search
	~ 1912.1201:• [Michael Arroyo] Updated the ManageService error controls
				• [Michael Arroyo] Updated the ManageType error controls
				• [Michael Arroyo] Added a sub process to track service changes
				• [Michael Arroyo] Added a sub process to revert tracked service changes
	~ 2002.2601:• [Michael Arroyo] Updated the Code to the '145' column width standard
				• [Michael Arroyo] Fixed the false positive error when removing a service.  Prior a valid removal would trigger an
									error that the service could not be found.
	~ 2003.0201:• [Michael Arroyo] Added a new check to determine if the service exits.  Prior, Get-Service with Service name would
										generate an error even if you selected -ErrorAction to SilentlyContinue if the service did not
										exist.
				• [Michael Arroyo] Updated the ManageServiceTyper sub function to not run unless a service is found.  This way there
									no generated errors if a service is not found even if the service list is (Zero)
	~ 20.05.2101• [Michael Arroyo] Updated to support Posh 2.0
	~ 21.02.0801• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				• [Michael Arroyo] Moved Build Notes out of General Posh Help section
				• [Michael Arroyo] Added support for Caching
				• [Michael Arroyo] Added support for Clearing Garbage collecting
				• [Michael Arroyo] Added supoort for SQLite DB
				• [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
				• [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
									unless you manually set the -Verbose parameter.
	~ 21.02.2201• [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
	~ 21.03.0201• [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				• [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				• [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
				• [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
#>
#endregion Build Notes
	[cmdletbinding()]
    [Alias('Get-ServiceList','Get-BGServiceList')]
	#region Parameters
    Param
    (
        [Parameter(Position = 1)]
        [ValidateSet(	'Name',
						'DesktopInteract',
						'PathName',
						'ServiceType',
						'StartMode',
						'Caption',
						'Description',
						'DisplayName',
						'InstallDate',
						'ProcessId',
						'Started',
						'StartName',
						'State',
						'ProcessName',
						'ProcessPath',
						'ProcessCommandLine',
						'ProcessSessionId',
						'ProcessOwner',
						'ServiceExecPath',
						'Hash',
						'Signature_Comment',
						'Signature_FileVersion',
						'Signature_Description',
						'Signature_Date',
						'Signature_Company',
						'Signature_Publisher',
						'Signature_Verified'
		)]
        [string]$FilterType = 'Name',

        [string]$Pattern = '.*',

        [ValidateSet('Suspend', 'Resume', 'Stop')]
        [string]$Managetype,

        [ValidateSet('Remove', 'Resume', 'Stop')]
        [string]$ManageServicetype,

        [ValidateSet("MACTripleDES", "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]$Algorithm = "MD5",

        [switch]$Signature,

		[switch]$TrackChanges,

		[switch]$OverrideTracked,

		[switch]$RevertTracked,

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

    #region Create Return Hash
        $HashReturn = @{}
        $HashReturn.ServiceList = @{}
		$StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ServiceList'].StartTime = $($StartTime).DateTime
		$HashReturn['ServiceList'].Comment = @()
		$HashReturn['ServiceList']['CachePath'] = $CachePath
		$HashReturn['ServiceList']['Services'] = @()
		$HashReturn['ServiceList'].ParsedCount = 0
		$HashReturn['ServiceList'].Count = 0
		$HashReturn['ServiceList'].ManageProcess = @()
    #endregion Create Return Hash

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
				$HSqlite.TableName = 'BGServiceList'
			#endregion Table Name

			#region Set Column Information
				$HSqlite.TableColumns = 'Name TEXT PRIMARY KEY,
				DesktopInteract TEXT,
				PathName TEXT,
				ServiceType TEXT,
				StartMode TEXT,
				Caption TEXT,
				Description TEXT,
				DisplayName TEXT,
				InstallDate TEXT,
				ProcessId TEXT,
				Started TEXT,
				StartName TEXT,
				State TEXT,
				ProcessName TEXT,
				ProcessPath TEXT,
				ProcessCommandLine TEXT,
				ProcessSessionId TEXT,
				ProcessOwner TEXT,
				ServiceExecPath TEXT,
				Hash TEXT,
				Signature_Comment TEXT,
				Signature_FileVersion TEXT,
				Signature_Description TEXT,
				Signature_Date TEXT,
				Signature_Company TEXT,
				Signature_Publisher TEXT,
				Signature_Verified TEXT'
			#endregion Set Column Information

			#region Set Create Table SQL String
				$HSqlite.CreateTableStr = $('CREATE TABLE IF NOT EXISTS {0} ({1})' -f $HSqlite.TableName, $HSqlite.TableColumns)
			#endregion Set Create Table SQL String

			#region Drop Table SQL String
				$HSqlite.DropTableStr = $('DROP TABLE IF EXISTS {0} ({1})' -f $HSqlite.TableName)
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

    #region (Main) Query Service and Process Items
        $Error.Clear()

        #region WMI Process Query
            $ServiceListResults = Get-WmiObject -Class Win32_Service | Select-Object -Property `
                Name,
                @{
					Name = 'DesktopInteract'
					Expression = {$($_.DesktopInteract | Out-String).Trim()}
				},
                PathName,
                ServiceType,
                StartMode,
                Caption,
                Description,
                DisplayName,
                InstallDate,
                ProcessId,
                @{
					Name = 'Started'
					Expression = {$($_.Started | Out-String).Trim()}
				},
                StartName,
                State,
                ProcessName,
				ProcessPath,
				ProcessCommandLine,
				ProcessSessionId,
				ProcessOwner,
				ServiceExecPath,
				Hash,
				Signature_Comment,
				Signature_FileVersion,
				Signature_Description,
				Signature_Date,
				Signature_Company,
				Signature_Publisher,
				Signature_Verified
        #endregion WMI Process Query

		#region Check ServiceList Results
			If
			(
				$ServiceListResults
			)
			{
				$HashReturn.ServiceList.ParsedCount = $ServiceListResults | Measure-Object -ErrorAction Stop  | `
					Select-Object -ExpandProperty 'Count' -ErrorAction Stop
			}
		#endregion Check ServiceList Results

		#region Update Service List Meta and Filter Data
			$ArrTempData = @()

			$ServiceListResults | ForEach-Object `
            -Process `
			{
				$CurServiceListItem = $_

				#region Set Extended Properties
					$CurServiceProcessInfo = Get-WmiObject -Class Win32_Process -Filter "ProcessID = $($CurServiceListItem.ProcessID)"
					$CurServiceListItem.ProcessName = $CurServiceProcessInfo.ProcessName
					$CurServiceListItem.ProcessPath = $CurServiceProcessInfo.ExecutablePath
					$CurServiceListItem.ProcessCommandLine = $CurServiceProcessInfo.CommandLine
					$CurServiceListItem.ProcessSessionId = $CurServiceProcessInfo.SessionId

					Try
					{
						If
						(
							$CurServiceProcessInfo.GetOwner().Domain -or $CurServiceProcessInfo.GetOwner().User
						)
						{
							$CurServiceListItem.ProcessOwner = $($CurServiceProcessInfo.GetOwner() | Select-Object `
							-Property @{Name='Owner';Expression={$('{0}\{1}' -f $_.Domain,$_.User)}}).Owner
						}
					}
					Catch
					{
						#Nothing
					}

					$CurServiceListItem.ServiceExecPath = '{0}.exe' -f $($($_.PathName).Replace('"','') -split '\.exe')[0]
					$CurServiceListItem.Hash = Get-HashInfo -Path $('{0}.exe' -f $($($_.PathName).Replace('"','') -split '\.exe')[0]) `
						-Algorithm $Algorithm
				#endregion Set Extended Properties

				#region Signature Switch
					If
					(
						$Signature
					)
					{
						Try
						{
							$CurSignature = $(Get-Signature -Path $CurServiceListItem.ServiceExecPath -Algorithm $Algorithm -ErrorAction Stop)
							$CurServiceListItem.Signature_Comment = $($CurSignature).Comment
							$CurServiceListItem.Signature_FileVersion = $($CurSignature).'File Version'
							$CurServiceListItem.Signature_Description = $($CurSignature).Description
							$CurServiceListItem.Signature_Date = $($CurSignature).Date
							$CurServiceListItem.Signature_Company = $($CurSignature).Company
							$CurServiceListItem.Signature_Publisher = $($CurSignature).Publisher

							If
							(
								$($CurSignature).Verified
							)
							{
								$CurServiceListItem.Signature_Verified = $($CurSignature).Verified
							}
							Else
							{
								$CurServiceListItem.Signature_Verified = 'N/A'
							}
						}
						Catch
						{
							$CurSignature = $null
						}
					}
				#endregion Signature Switch

				#region Force Type Cast for Elastic Search
					switch
					(
						$Null
					)
					{
						{$CurServiceListItem.Name -eq $null}
						{
							$CurServiceListItem.Name = ''
						}
						{$CurServiceListItem.DesktopInteract -eq $null}
						{
							$CurServiceListItem.DesktopInteract = ''
						}
						{$CurServiceListItem.PathName -eq $null}
						{
							$CurServiceListItem.PathName = ''
						}
						{$CurServiceListItem.ServiceType -eq $null}
						{
							$CurServiceListItem.ServiceType = ''
						}
						{$CurServiceListItem.StartMode -eq $null}
						{
							$CurServiceListItem.StartMode = ''
						}
						{$CurServiceListItem.Caption -eq $null}
						{
							$CurServiceListItem.Caption = ''
						}
						{$CurServiceListItem.Description -eq $null}
						{
							$CurServiceListItem.Description = ''
						}
						{$CurServiceListItem.DisplayName -eq $null}
						{
							$CurServiceListItem.DisplayName = ''
						}
						{$CurServiceListItem.Started -eq $null}
						{
							$CurServiceListItem.Started = ''
						}
						{$CurServiceListItem.StartName -eq $null}
						{
							$CurServiceListItem.StartName = ''
						}
						{$CurServiceListItem.State -eq $null}
						{
							$CurServiceListItem.State = ''
						}
						{$CurServiceListItem.ProcessName -eq $null}
						{
							$CurServiceListItem.ProcessName = ''
						}
						{$CurServiceListItem.ProcessPath -eq $null}
						{
							$CurServiceListItem.ProcessPath = ''
						}
						{$CurServiceListItem.ProcessCommandLine -eq $null}
						{
							$CurServiceListItem.ProcessCommandLine = ''
						}
						{$CurServiceListItem.ProcessOwner -eq $null}
						{
							$CurServiceListItem.ProcessOwner = ''
						}
						{$CurServiceListItem.ServiceExecPath -eq $null}
						{
							$CurServiceListItem.ServiceExecPath = ''
						}
						{$CurServiceListItem.Signature_Comment -eq $null}
						{
							$CurServiceListItem.Signature_Comment = ''
						}
						{$CurServiceListItem.Signature_FileVersion -eq $null}
						{
							$CurServiceListItem.Signature_FileVersion = ''
						}
						{$CurServiceListItem.Signature_Description -eq $null}
						{
							$CurServiceListItem.Signature_Description = ''
						}
						{$CurServiceListItem.Signature_Date -eq $null}
						{
							$CurServiceListItem.Signature_Date = ''
						}
						{$CurServiceListItem.Signature_Company -eq $null}
						{
							$CurServiceListItem.Signature_Company = ''
						}
						{$CurServiceListItem.Signature_Publisher -eq $null}
						{
							$CurServiceListItem.Signature_Publisher = ''
						}
						{$CurServiceListItem.Signature_Verified -eq $null}
						{
							$CurServiceListItem.Signature_Verified = ''
						}
					}
				#endregion Force Type Cast for Elastic Search

				#region Setup Caching
					If
					(
						$CurServiceListItem | Where-Object -FilterScript { $CurServiceListItem.$($FilterType) -match $Pattern }
					)
					{
						If
						(
							$UseCache
						)
						{
							'---' | Out-File -FilePath $CachePath -Append -Force
							$CurServiceListItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
						}
						Else
						{
							$ArrTempData += $CurServiceListItem
						}

						If
						(
							$UpdateDB
						)
						{
							If
							(
								$ForceDBUpdate
							)
							{
								Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurServiceListItem | `
								Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
							}
							Else
							{
								Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurServiceListItem | `
								Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
							}
						}
					}

					$CurServiceListItem = $null
				#endregion Setup Caching
			}

			#region Cleanup
				$ServiceListResults = $null

				If
				(
					$ClearGarbageCollecting
				)
				{
						$null = Clear-BlugenieMemory
				}
			#endregion Cleanup
		#endregion Update Service List Items
    #endregion (Main) Query Service and Process Items

    #region Service Count
		If
		(
			$ArrTempData
		)
		{
			$HashReturn['ServiceList'].Services += $ArrTempData
		}
		ElseIf
		(
			$UseCache
		)
		{
			$HashReturn['ServiceList'].Services += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
			If
			(
				$RemoveCache
			)
			{
				$null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
			}
		}

		$HashReturn['ServiceList'].Count = $($HashReturn['ServiceList'].Services | Measure-Object | Select-Object -ExpandProperty Count)
	#endregion Service Count

    #region Managetype
        If
        (
            $Managetype -and $ArrTempData
        )
        {
            $CurHashes = $ArrTempData | Where-Object -FilterScript { $_.Hash -ne `
				'The process cannot access the file because it is being used by another process'  } | Select-Object -ExpandProperty Hash -Unique

            switch
            (
                $Managetype
            )
            {
                "Suspend"
                {
                    $null = $HashReturn.ServiceList.ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Suspend `
						-Algorithm $Algorithm
                }
                "Resume"
                {
                    $null = $HashReturn.ServiceList.ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Resume `
						-Algorithm $Algorithm
                }
                "Stop"
                {
                    $null = $HashReturn.ServiceList.ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Stop `
						-Algorithm $Algorithm
                }
            }
        }
    #endregion Managetype

    #region ManageServicetype
        If
        (
            $ManageServicetype -or $RevertTracked -or $TrackChanges
        )
        {
			If
			(
				$HashReturn.ServiceList.Services
			)
			{
				$HashReturn['ServiceList'].ManageService = @{}

				#region Setup TrackChanges
					If
					(
						$TrackChanges
					)
					{
						$HashReturn['ServiceList']['ManageService'].Tracking = @{}

						#region Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\ServiceList)
							If
							(
								Test-Path -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList'
							)
							{
								$HashReturn['ServiceList']['ManageService'].Tracking.ParentKeyAlreadyExisted = 'True'
								$HashReturn['ServiceList']['ManageService'].Tracking.ServiceListKeyCreated = 'Exists'
								$HashReturn['ServiceList']['ManageService'].Tracking.Comments = ''
							}
							Else
							{
								$HashReturn['ServiceList']['ManageService'].Tracking.ParentKeyAlreadyExisted = 'False'
								$HashReturn['ServiceList']['ManageService'].Tracking.Comments = ''

								Try
								{
									$Error.Clear()
									$null = New-Item -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList' -Force -ErrorAction Stop
									$HashReturn['ServiceList']['ManageService'].Tracking.ServiceListKeyCreated = 'True'
								}
								Catch
								{
									$HashReturn['ServiceList']['ManageService'].Tracking.ServiceListKeyCreated = 'False'
									$HashReturn['ServiceList']['ManageService'].Tracking.Comments = $($Error[0].exception.message | Out-String)
								}
							}
						#endregion Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\ServiceList)
					}
				#endregion Setup TrackChanges

				$CurObjects = $HashReturn.ServiceList.Services

				$CurObjects | ForEach-Object `
				-Process `
				{
					$CurServiceObj = $_
					$CurObject = $CurServiceObj.Name
					$HashReturn['ServiceList']['ManageService'].$($CurObject) = @{
						Comment = @()
						Tracked = 'False'
					}

					#region Track Changes
						If
						(
							$TrackChanges
						)
						{
							Try
							{
								$Error.clear()
								$CurTrackedService = Get-Service -Name $CurObject -ErrorAction Stop | Select-Object -Property Status,StartType | `
									ConvertTo-Csv -NoTypeInformation
							}
							Catch
							{
								$null = $HashReturn.ServiceList.ManageService.$($CurObject).Comment += $($error[0].exception | Out-String)
							}

							If
							(
								-Not $(Test-Path -Path $('HKLM:\SOFTWARE\BluGenie\ServiceList\{0}' -f $CurObject))
							)
							{
								$Error.Clear()
								Try
								{
									$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList' -Name $CurObject -Value $CurTrackedService `
										-Type MultiString -Force -ErrorAction Stop
									$HashReturn.ServiceList.ManageService.$($CurObject).Tracked = 'True'
								}
								Catch
								{
									$null = $HashReturn.ServiceList.ManageService.$($CurObject).Comment += $($error[0].exception | Out-String)
								}
							}
							Else
							{
								If
								(
									$OverrideTracked
								)
								{
									$Error.Clear()
									Try
									{
										$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList' -Name $CurObject `
											-Value $CurTrackedService -Type MultiString -Force -ErrorAction Stop
										$HashReturn.ServiceList.ManageService.$($CurObject).Tracked = 'True'
									}
									Catch
									{
										$null = $HashReturn.ServiceList.ManageService.$($CurObject).Comment += $($error[0].exception | Out-String)
									}
								}
							}
						}
					#endregion Track Changes

					#region Revert Settings back to the original
						If
						(
							$RevertTracked
						)
						{
							$HashReturn['ServiceList']['ManageService'].$($CurObject).Tracked = 'Revert'

							If
							(
								-not $ManageServicetype -eq 'Remove'
							)
							{
								$Error.Clear()
								Try
								{
									$ObjOrgStatus = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList' -Name  $CurObject `
										-ErrorAction Stop | Select-Object -ExpandProperty $CurObject | ConvertFrom-Csv
								}
								Catch
								{
									$null = $HashReturn.ServiceList.ManageService.$($CurObject).Comment += $($error[0].exception | Out-String)
								}

								If
								(
									$ObjOrgStatus
								)
								{
									Try
									{
										$Error.Clear()
										Get-Service -Name $CurObject -ErrorAction Stop | Set-Service -StartupType $($ObjOrgStatus.StartType) `
											-ErrorAction Stop

										switch
										(
											$ObjOrgStatus.Status
										)
										{
											'Running'
											{
												Start-Service -Name $CurObject
											}
											'Stopped'
											{
												Stop-Service $CurObject -Force
											}
										}

										$null = Remove-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\ServiceList' -Name  $CurObject -ErrorAction Stop
									}
									Catch
									{
										$null = $HashReturn.ServiceList.ManageService.$($CurObject).Comment += $($error[0].exception | Out-String)
									}
								}
							}
							Else
							{
								$RevertTracked = $false
							}
						}
					#endregion Revert Settings back to the original

					#region ManageServicetype
						If
						(
							$ManageServicetype -and $($RevertTracked -eq $false)
						)
						{
							switch
							(
								$ManageServicetype
							)
							{
								"Remove"
								{
									Try
									{
										$error.Clear()
										Stop-Service -Name $($CurObject) -Force -ErrorAction Stop
										$HashReturn.ServiceList.ManageService.$($CurObject).Stop = $true

										$RemoveService = $(Get-WmiObject -Class Win32_Service -Filter "Name = '$($CurObject)'")
										$null = $RemoveService.Delete()

										If
										(
											Get-Service | Where-Object -Property Name -EQ $CurObject
										)
										{
											$HashReturn.ServiceList.ManageService.$($CurObject).Remove = $false
										}
										Else
										{
											$HashReturn.ServiceList.ManageService.$($CurObject).Remove = $true
										}
									}
									Catch
									{
										$HashReturn.ServiceList.ManageService.$($CurObject).Stop = $false
										$HashReturn.ServiceList.ManageService.$($CurObject).Comment = $error[0].ToString()
									}
								}
								"Resume"
								{
									Try
									{
										$error.Clear()
										Start-Service -Name $($CurObject) -ErrorAction Stop
										$HashReturn.ServiceList.ManageService.$($CurObject).Start = $true
									}
			`						Catch
									{
										$HashReturn.ServiceList.ManageService.$($CurObject).Start = $false
										$HashReturn.ServiceList.ManageService.$($CurObject).Comment = $error[0].ToString()
									}
								}
								"Stop"
								{
									Try
									{
										$error.Clear()
										Stop-Service -Name $($CurObject) -Force -ErrorAction Stop
										$HashReturn.ServiceList.ManageService.$($CurObject).Stop = $true
									}
									Catch
									{
										$HashReturn.ServiceList.ManageService.$($CurObject).Stop = $false
										$HashReturn.ServiceList.ManageService.$($CurObject).Comment = $error[0].ToString()
									}
								}
							}
						}
					#endregion ManageServicetype

					#region Update Service Info
						Start-Sleep -Seconds 2
						$OjbUpdateCurService = Get-Service | Where-Object -Property Name -eq $CurObject | Select-Object -Property *
						If
						(
							$OjbUpdateCurService
						)
						{
							If
							(
								$OjbUpdateCurService.Status -eq 'Running'
							)
							{
								$CurServiceObj.Started = 'True'
							}
							Else
							{
								$CurServiceObj.Started = 'False'
							}

							$CurServiceObj.State = $($OjbUpdateCurService.Status | Out-String).trim()
							$CurServiceObj.StartMode = $($OjbUpdateCurService.StartType | Out-String).trim()

						}
						<#
						Else
						{
							$ErrorReturn = [pscustomobject]@{
								'Action' 		= '..'
								'StackTrace' 	= 'Manually Generated'
								'Line'			= '..'
								'Error' 		= $('Cannot find any service with service name {0}' -f $CurObject)
							}

							$null = $HashReturn['ServiceList'].Comment += $ErrorReturn
						}#>
					#endregion Update Service Info
				}
			}
        }
    #endregion $ManageServicetype

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ServiceList'].EndTime = $($EndTime).DateTime
        $HashReturn['ServiceList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
			Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		If
		(
			-Not $($VerbosePreference -eq 'Continue')
		)
		{
			#Remove Hash Properties that are not needed without Verbose enabled.
			$null = $HashReturn['ServiceList'].Remove('StartTime')
			$null = $HashReturn['ServiceList'].Remove('ParameterSetResults')
			$null = $HashReturn['ServiceList'].Remove('CachePath')
			$null = $HashReturn['ServiceList'].Remove('EndTime')
			$null = $HashReturn['ServiceList'].Remove('ElapsedTime')
		}

		#region Output Type
			$ResultSet = $(New-Object -TypeName PSObject -Property @{
				Services = $($HashReturn['ServiceList']['Services'])
				ManageProcess = $($HashReturn['ServiceList']['ManageProcess'])
				ManageService = $($HashReturn['ServiceList']['ManageService'])
			})

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
										Return $($ResultSet | ConvertTo-Yaml)
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
#endregion Get-BluGenieServiceList (Function)