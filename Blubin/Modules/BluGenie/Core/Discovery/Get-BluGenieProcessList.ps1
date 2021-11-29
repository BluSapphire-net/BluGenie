#region Get-BluGenieProcessList (Function)
Function Get-BluGenieProcessList
{
<#
    .SYNOPSIS
        Get a full list of Processes

    .DESCRIPTION
        Get a full list of Processes and all linked properties including parent processes and process owner information

    .PARAMETER FilterType
        Description: Which property to filter by
        Notes:
            • Filter Option
			o	"Caption" Search the Caption Field
			o	"CommandLine" Search the CommandLine Field
			o	"Name" Search the Name Field
			o	"ProcessId" Search the ProcessID Field
			o	"Path" Search the Path Field
			o	"ProcessOwner" Search the ProcessOwner Field
			o	"Process_Hash" Search the Process_Hash Field
			o	"NoFilter" Return all items with no specific search terms processed
			o	"NullPaths" Return all items with no valid Path found
			o	"Signature_Comment" Display error message while pulling Signature Information
					[Note:  This is only available if you use the -Signature switch]
			o	"Signature_FileVersion" File Version and OS Build information in part of the OS
					[Note:  This is only available if you use the -Signature switch]
			o	"Signature_Description" The description of the files signature [Note:  This is only available if you use the -Signature switch]
			o	"Signature_Date" Date when the file was signed [Note:  This is only available if you use the -Signature switch]
			o	"Signature_Company" The company signing the file [Note:  This is only available if you use the -Signature switch]
			o	"Signature_Publisher" The Publisher signing the file [Note:  This is only available if you use the -Signature switch]
			o	"Signature_Verified" Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use the -Signature switch]
        Alias:
        ValidateSet: 'Caption','CommandLine','Name','ProcessId','Path','ProcessOwner','Process_Hash','NullPaths','Signature_Comment','Signature_FileVersion','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified'

    .PARAMETER Pattern
        Description: Search Pattern using RegEx
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Managetype
        Description: Manage the behavior of the process (Suspend, Resume, Stop)
        Notes:
        Alias:
        ValidateSet: 'Suspend','Resume','Stop'

    .PARAMETER LazyPathSearch
        Description:  Search for processes that do not have a valid path
        Notes: The Search is only under any directory in the system environment path variable.
					By default the process would be searched for under the System drive.
        Alias:
        ValidateSet:

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

    .PARAMETER Signature
        Description: Query Signature information
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER NotMatch
        Description: This switch will filter out what items you don't want to query for.
        Notes: The search string is assigned to the (Pattern) property.
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
        Description: Removed UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
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
        Command: Get-BluGenieProcessList
        Description: Return all the processes on the local machine
        Notes: The default Hash Algorithm is (MD5)

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType NoFilter -Algorithm SHA256
        Description: Return all the processes on the local machine (default option) with a differnet Hash type
        Notes: The Hash Algorithm is (SHA256)

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType NullPaths -Algorithm SHA512
        Description: Return all the processes on the local machine that do not have a valid path
        Notes: The Hash Algorithm is (SHA512)

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType Name -Pattern shell
        Description: Return all the processes on the local machine with a Name field that matches the RegEx pattern
        Notes:

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$'
        Description: This will return all the processes on the local machine with a Name field that matches the RegEx pattern with an Exact Match
        Notes:

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$' -LazyPathSearch
        Description: Return all the processes with an Exact Match and validate path with LazyPathSearch
        Notes: By default the process path will be searched for under the entire System drive.  This is a (Slow Search).

    .EXAMPLE
        Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$' -Managetype Stop
        Description: Return all the processes with an Exact Match and Terminate the process
        Notes: -Managetype can also [Suspend and Resume]

    .EXAMPLE
        Command: Get-BluGenieProcessList -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieProcessList -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieProcessList -OutUnEscapedJSON
        Description: The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters
        Notes:

    .EXAMPLE
        Command: Get-BluGenieProcessList -ReturnObject
        Description: The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        Notes:

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1809.1501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.03.0201
        * Comments                  :
        * Dependencies              :
            ~ Invoke-WalkThrough
            ~ Get-HashInfo
            ~ Manage-ProcessHash
            ~ Get-Signature
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
	~ 1809.1501:• [Michael Arroyo] Posted
    ~ 1809.2301:• [Michael Arroyo] Updated the Managetype code to support a foreach structure
    ~ 1809.2901:• [Michael Arroyo] Added a new Method to only show the Query Results in the Return data
    ~ 1812.1201:• [Michael Arroyo] Added a new filter option for searching
                • [Michael Arroyo] Added new search feature using RegEx
                • [Michael Arroyo] Removed parameters ( QueryPID, QueryProcess, QueryHash, QueryCommandLine, QueryAll ).
                                    These options are now in the FilterType parameter
                • [Michael Arroyo] Returned data in the Process List is no longer a (Key, Value) pair.  It is a list of objects
    ~ 1812.2301:• [Michael Arroyo] Added the Computer name to the returning objects
    ~ 1901.0201:• [Michael Arroyo] Updated the Hash return to support a Try / Catch so it won't display errors if a process is locked
                • [Michael Arroyo] Fixed the Output, the Process Owner wasn't being managed correctly
                • [Michael Arroyo] Updated the Help information to have real values to help make it easier to understand
    ~ 1901.2101:• [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
                • [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
                • [Michael Arroyo] Updated the Help information
                • [Michael Arroyo] Added new parameter to Manage-ProcessHash to now support the updated Hash Algorithm
    ~ 1902.0601:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
    ~ 1902.2001:• [Michael Arroyo] Added Signature switch.  This will pull the Signature information for the giving file or process.
                • [Michael Arroyo] Added the Signature Search options to the -FilterType Search string
                • [Michael Arroyo] Redesigned the Internal search filter to look more like the new functions
                • [Michael Arroyo] Updated the Hash Query to use the external function
                • [Michael Arroyo] Removed FitlerTyper (NoFilter). Updated the search process so this is not needed.  By default just
                                    running the function there will be no filters.
    ~ 1907.2001:• [Michael Arroyo] Updated the Walktrough Function to version 1905.2401
                • [Michael Arroyo] Updated ParameterSetResults with $PSBoundParameters and removed each seperate call.
                • [Michael Arroyo] Added Parameter OutUnEscapedJSON to show beautify the JSON file and clean up the formatting.
                • [Michael Arroyo] Removed the need for the -ExactMatch parameter
                • [Michael Arroyo] Added Start, End, and Time Spane values to the returning JSON
                • [Michael Arroyo] Added the ReturnObject switch.  This will return the data as an object instead of the normal Hash
                                    Table
                • [Michael Arroyo] Updated the Hash Table return data.  All values are now bound to a single object/header called
                                    ProcessList
                • [Michael Arroyo] Added the NotMatch switch to enable Not Matching pattern queries
    ~ 1907.2901:• [Michael Arroyo] Updated the Process Object to always have (Process_Hash) property.  If the item is $null a value of
                                    "not on disk" is assigned.
                • [Michael Arroyo] Updated the Help to support the -NotMatch switch.
                • [Michael Arroyo] Added Error controls around the Process ID Query.  If an item closes while Get-ProcessList is
                                    querying for information it can generate an error that the process no longer exist.
    ~ 1908.1301:• [Michael Arroyo] Updated the example help section and removed all the -ExactMatch help items
    ~ 1908.1401:• [Michael Arroyo] Added new items to the process property table
                                        o ParentProcessId
                                        o ParentProcessName
                                        o ParentProcessPath
                                        o ParentProcessHash
    ~ 1908.1402:• [Michael Arroyo] Force Type Cast of the following items
                                        o [String] Caption
                                        o [String] CommandLine
                                        o [String] Name
                                        o [String] Path
                                        o [Int]    ParentProcessId
                                        o [String] ParentProcessName
                                        o [String] ParentProcessPath
                                        o [String] ComputerName
                                        o [String] ProcessOwner
                                        o [String] Process_Hash
                                        o [String] ParentProcessHash
    ~ 1910.1801:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                • [Michael Arroyo] Added more detailed information to the Return data
    ~ 1912.0401:• [Michael Arroyo] Updated the PID value to always be set to [Int] to support Elastic Search
    ~ 1912.1201:• [Michael Arroyo] Updated the ManageType error controls
    ~ 2002.2501:• [Michael Arroyo] Updated the Code to the '145' column width standard
                • [Michael Arroyo] Updated the ManageType processes to not process if there are no system processes found
    ~ 21.02.0801• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                • [Michael Arroyo] Added support for Caching
                • [Michael Arroyo] Added support for Clearing Garbage collecting
                • [Michael Arroyo] Added supoort for SQLite DB
                • [Michael Arroyo] Updated Process Query and Filtering (10x faster when processing)
                • [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                    unless you manually set the -Verbose parameter.
    ~ 21.02.1501• [Michael Arroyo] Updated Parameter help section with information about the below new Parameters
                                    -UseCache
                                    -ClearGarbageCollecting
                                    -CachePath
                                    -RemoveCache
                                    -DBName
                                    -ForceDBUpdate
                                    -DBPath
                                    -UpdateDB
                                    -OutYaml
                                    -FormatView
    ~ 21.02.2201• [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
    ~ 21.03.0201• [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
                • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                • [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                • [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.


#>
#endregion Build Notes
    [Alias('Get-ProcessList','Get-BGProcessList')]
    #region Parameters
    Param
    (
        [Parameter(Position = 1)]
        [ValidateSet(   'Caption',
                        'CommandLine',
                        'Name',
                        'ProcessId',
                        'Path',
                        'ProcessOwner',
                        'Process_Hash',
                        'NullPaths',
                        'Signature_Comment',
                        'Signature_FileVersion',
                        'Signature_Description',
                        'Signature_Date',
                        'Signature_Company',
                        'Signature_Publisher',
                        'Signature_Verified'
		)]
        [string]$FilterType = 'Name',

        [Parameter(Position = 2)]
        [string]$Pattern = '.*',

        [Parameter(Position = 3)]
        [ValidateSet('Suspend','Resume','Stop')]
        [string]$Managetype,

        [Parameter(Position = 4)]
        [switch]$LazyPathSearch,

        [Parameter(Position=5)]
        [ValidateSet('MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512')]
        [string]$Algorithm = "MD5",

        [Parameter(Position=6)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position = 7)]
        [switch]$Signature,

        [Parameter(Position = 8)]
        [switch]$NotMatch,

		[Switch]$ClearGarbageCollecting,

		[Switch]$UseCache,

		[String]$CachePath = $('{0}\Windows\Temp\{1}.log' -f $env:SystemDrive, $(New-BluGenieUID)),

		[Switch]$RemoveCache,

		[String]$DBName = 'BluGenie',

		[String]$DBPath = $('{0}\BluGenie' -f $env:ProgramFiles),

		[Switch]$UpdateDB,

		[Switch]$ForceDBUpdate,

        [Switch]$NewDBTable,

        [Parameter(Position=9)]
        [Switch]$ReturnObject,

        [Parameter(Position = 10)]
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
        $HashReturn.ProcessList = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ProcessList'].StartTime = $($StartTime).DateTime
        $HashReturn['ProcessList'].Comment = @()
        $HashReturn['ProcessList'].ParsedCount = 0
        $HashReturn['ProcessList'].Count = 0
        $HashReturn['ProcessList'].Processes =  @()
        $HashReturn['ProcessList'].ManageProcess = @()
    #endregion  Create Return hash

    #region Parameter Set Results
        $HashReturn['ProcessList'].ParameterSetResults = $PSBoundParameters
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
				$HSqlite.TableName = 'BGProcessList'
			#endregion Table Name

			#region Set Column Information
				$HSqlite.TableColumns = 'Name TEXT PRIMARY KEY,
                        Caption TEXT,
                        CommandLine TEXT,
                        ProcessId TEXT,
                        SessionId TEXT,
                        Path TEXT,
                        ParentProcessId TEXT,
                        ParentProcessName TEXT,
                        ParentProcessPath TEXT,
                        Owner TEXT,
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
        #region Query Process List
            $Error.Clear()
            $ProcessListResults = Get-WmiObject -Class Win32_Process | Select-Object -Property `
                Name,
                Caption,
                CommandLine,
                ProcessId,
                SessionId,
                Path,
                ParentProcessId,
                ParentProcessName,
                ParentProcessPath,
                Owner,
                Hash,
                Signature_Comment,
                Signature_FileVersion,
                Signature_Description,
                Signature_Date,
                Signature_Company,
                Signature_Publisher,
                Signature_Verified
        #endregion Query Process List

        #region Check ServiceList Results
			If
			(
				$ProcessListResults
			)
			{
				$HashReturn['ProcessList'].ParsedCount = $ProcessListResults | Measure-Object -ErrorAction Stop  | `
					Select-Object -ExpandProperty 'Count' -ErrorAction Stop
			}
		#endregion Check ServiceList Results

        #region Update Process List Meta and Filter Data
			$ArrTempData = @()

			$ProcessListResults | ForEach-Object `
            -Process `
			{
				$CurProcessListItem = $_

				#region Set Extended Properties
					$CurProcessInfo = Get-WmiObject -Class Win32_Process -Filter "ProcessID = $($CurProcessListItem.ParentProcessId)"
					$CurProcessListItem.ParentProcessName = $CurProcessInfo.Name

                    If
                    (
                        $CurProcessInfo.ExecutablePath
                    )
                    {
                        $CurProcessListItem.ParentProcessPath = Split-Path -Path $CurProcessInfo.ExecutablePath -Parent
                    }

                    Try
					{
						If
						(
							$CurProcessInfo.GetOwner().Domain -or $CurProcessInfo.GetOwner().User
						)
						{
							$CurProcessListItem.Owner = $($CurProcessInfo.GetOwner() | Select-Object `
							-Property @{Name='Owner';Expression={$('{0}\{1}' -f $_.Domain,$_.User)}}).Owner
						}
					}
					Catch
					{
						#Nothing
					}

					$CurProcessListItem.Hash = Get-HashInfo -Path $CurProcessListItem.Path -Algorithm $Algorithm
				#endregion Set Extended Properties

				#region Signature Switch
					If
					(
						$Signature
					)
					{
						Try
						{
							$CurSignature = $(Get-Signature -Path $CurProcessListItem.Name -Algorithm $Algorithm -ErrorAction Stop)
							$CurProcessListItem.Signature_Comment = $($CurSignature).Comment
							$CurProcessListItem.Signature_FileVersion = $($CurSignature).'File Version'
							$CurProcessListItem.Signature_Description = $($CurSignature).Description
							$CurProcessListItem.Signature_Date = $($CurSignature).Date
							$CurProcessListItem.Signature_Company = $($CurSignature).Company
							$CurProcessListItem.Signature_Publisher = $($CurSignature).Publisher

							If
							(
								$($CurSignature).Verified
							)
							{
								$CurProcessListItem.Signature_Verified = $($CurSignature).Verified
							}
							Else
							{
								$CurProcessListItem.Signature_Verified = 'N/A'
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
						{$CurProcessListItem.Name -eq $null}
						{
							$CurProcessListItem.Name = ''
						}
                        {$CurProcessListItem.Caption -eq $null}
						{
							$CurProcessListItem.Caption = ''
						}
                        {$CurProcessListItem.CommandLine -eq $null}
						{
							$CurProcessListItem.CommandLine = ''
						}
                        {$CurProcessListItem.ProcessId -eq $null}
						{
							$CurProcessListItem.ProcessId = -1
						}
                        {$CurProcessListItem.SessionId -eq $null}
						{
							$CurProcessListItem.SessionId = -1
						}
                        {$CurProcessListItem.Path -eq $null}
						{
							$CurProcessListItem.Path = ''
						}
                        {$CurProcessListItem.ParentProcessId -eq $null}
						{
							$CurProcessListItem.ParentProcessId = -1
						}
                        {$CurProcessListItem.ParentProcessName -eq $null}
						{
							$CurProcessListItem.ParentProcessName = ''
						}
                        {$CurProcessListItem.ParentProcessPath -eq $null}
						{
							$CurProcessListItem.ParentProcessPath = ''
						}
                        {$CurProcessListItem.Owner -eq $null}
						{
							$CurProcessListItem.Owner = ''
						}
                        {$CurProcessListItem.Hash -eq $null}
						{
							$CurProcessListItem.Hash = ''
						}
                        {$CurProcessListItem.Signature_Comment -eq $null}
						{
							$CurProcessListItem.Signature_Comment = ''
						}
                        {$CurProcessListItem.Signature_FileVersion -eq $null}
						{
							$CurProcessListItem.Signature_FileVersion = ''
						}
                        {$CurProcessListItem.Signature_Description -eq $null}
						{
							$CurProcessListItem.Signature_Description = ''
						}
                        {$CurProcessListItem.Signature_Date -eq $null}
						{
							$CurProcessListItem.Signature_Date = ''
						}
                        {$CurProcessListItem.Signature_Company -eq $null}
						{
							$CurProcessListItem.Signature_Company = ''
						}
                        {$CurProcessListItem.Signature_Publisher -eq $null}
						{
							$CurProcessListItem.Signature_Publisher = ''
						}
                        {$CurProcessListItem.Signature_Verified -eq $null}
						{
							$CurProcessListItem.Signature_Verified = ''
						}
					}
				#endregion Force Type Cast for Elastic Search

				#region Setup Caching
					If
					(
						$CurProcessListItem | Where-Object -FilterScript { $CurProcessListItem.$($FilterType) -match $Pattern }
					)
					{
						If
						(
							$UseCache
						)
						{
							'---' | Out-File -FilePath $CachePath -Append -Force
							$CurProcessListItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
						}
						Else
						{
							$ArrTempData += $CurProcessListItem
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
								Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurProcessListItem | `
								Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
							}
							Else
							{
								Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurProcessListItem | `
								Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
							}
						}
					}

					$CurProcessListItem = $null
				#endregion Setup Caching
			}

			#region Cleanup
				$ProcessListResults = $null

				If
				(
					$ClearGarbageCollecting
				)
				{
						$null = Clear-BlugenieMemory
				}
			#endregion Cleanup
		#endregion Update Process List Items

        #region Service Count
            If
            (
                $ArrTempData
            )
            {
                $HashReturn['ProcessList'].Processes += $ArrTempData
            }
            ElseIf
            (
                $UseCache
            )
            {
                $HashReturn['ProcessList'].Processes += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
                If
                (
                    $RemoveCache
                )
                {
                    $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
                }
            }

            $HashReturn['ProcessList'].Count = $($HashReturn['ProcessList'].Processes | Measure-Object | Select-Object -ExpandProperty Count)
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
                        $null = $HashReturn['ProcessList'].ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Suspend `
                            -Algorithm $Algorithm
                    }
                    "Resume"
                    {
                        $null = $HashReturn['ProcessList'].ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Resume `
                            -Algorithm $Algorithm
                    }
                    "Stop"
                    {
                        $null = $HashReturn['ProcessList'].ManageProcess += Manage-ProcessHash -Hash $CurHashes -Managetype Stop `
                            -Algorithm $Algorithm
                    }
                }
            }
        #endregion Managetype
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ProcessList'].EndTime = $($EndTime).DateTime
        $HashReturn['ProcessList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
			Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		If
		(
			-Not $($VerbosePreference -eq 'Continue')
		)
		{
			#Remove Hash Properties that are not needed without Verbose enabled.
			$null = $HashReturn['ProcessList'].Remove('StartTime')
			$null = $HashReturn['ProcessList'].Remove('ParameterSetResults')
			$null = $HashReturn['ProcessList'].Remove('CachePath')
			$null = $HashReturn['ProcessList'].Remove('EndTime')
			$null = $HashReturn['ProcessList'].Remove('ElapsedTime')
		}

		#region Output Type
			$ResultSet = $(New-Object -TypeName PSObject -Property @{
				Processes = $HashReturn['ProcessList'].Processes
				ManageProcess = $HashReturn['ProcessList'].ManageProcess
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
#endregion Get-BluGenieProcessList (Function)