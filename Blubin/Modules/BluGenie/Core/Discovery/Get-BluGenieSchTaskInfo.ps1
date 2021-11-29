#region Get-BluGenieSchTaskInfo (Function)
Function Get-BluGenieSchTaskInfo
{
<#
    .SYNOPSIS
        Get a full list of Scheduled Tasks

    .DESCRIPTION
        Get a full list of Scheduled Tasks

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
        Description: Filter based on Property Type
        Notes:
				-Filter Types-
				Filter Option = "Path"                  - Task Scheduler Folder Path
                Filter Option = "Enabled"               - True or False [String] Value
                Filter Option = "Hash"                  - MD5 Hash Information
                Filter Option = "Command"               - Command line / Path to the Executable
                Filter Option = "Argument"              - Command line arguments
                Filter Option = "Description"           - Description field [string]
                Filter Option = "Author"                - Author / Creator of the Task
                Filter Option = "Name"                  - Name / Title of the Task
                Filter Option = "NoFilter"              - No Filted.  Show all Task Items
                Filter Option = "Signature_Comment"		- Display error message while pulling Signature Information [Note:  This is only
                                                            available if you use the -Signature switch]
                Filter Option = "Signature_FileVersion" - File Version and OS Build information in part of the OS [Note:  This is only available
                                                            if you use the -Signature switch]
                Filter Option = "Signature_Description" - The description of the files signature [Note:  This is only available if you use the
                                                            -Signature switch]
                Filter Option = "Signature_Date"		- Date when the file was signed [Note:  This is only available if you use the
                                                            -Signature switch]
                Filter Option = "Signature_Company"		- The company signing the file [Note:  This is only available if you use the -Signature
                                                            switch]
                Filter Option = "Signature_Publisher"	- The Publisher signing the file [Note:  This is only available if you use the
                                                            -Signature switch]
                Filter Option = "Signature_Verified"	- Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use
                                                            the -Signature switch]
        Alias:
        ValidateSet: Path,Enabled,Hash,Command,Argument,Description,Author,Name,NoFilter,Signature_Comment,Signature_FileVersion,Signature_Description,Signature_Date,Signature_Company,Signature_Publisher,Signature_Verified

    .PARAMETER Pattern
        Description: Search Pattern using RegEx
        Notes:
        Alias:
        ValidateSet:

	.PARAMETER RemoveTask
		Description: Remove any items found based on the query
		Notes:
		Alias:
		ValidateSet:

	.PARAMETER NotMatch
		Description: Query for values that do not match the -Pattern value
		Notes:
		Alias:
		ValidateSet:

	.PARAMETER Signature
		Description: Query Signature information
		Notes:
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
        Command: Get-BluGenieSchTaskInfo
        Description: Return a full list of Scheduled Tasks from the system
        Notes:

    .EXAMPLE
        Command: Get-BluGenieSchTaskInfo -Algorithm SHA256
        Description: Return a full list of Scheduled Tasks from the system with a SHA256 Hash value
        Notes:

	.EXAMPLE
		Command:  Get-BluGenieSchTaskInfo -Algorithm SHA512 -FilterType Enabled -Pattern True
		Description: Return Scheduled Tasks that have an (Enabled) value of (True)
		Notes:

	.EXAMPLE
		Command: Get-BluGenieSchTaskInfo -FilterType Command -Pattern '^C:\\Windows\\explorer\.exe$'
		Description: Return Scheduled Tasks that have a (Command) value that will equal (C:\Widnows\explorer.exe)
		Notes: The -Pattern parameter is using RegEx patterns.

	.EXAMPLE
		Command: Get-BluGenieSchTaskInfo -FilterType Path -Pattern '^\\Google\\Testing$' -RemoveTask
		Description: Return Scheduled Tasks that have a (Path) value that will equal (\Google\Testing) and remove any item(s) found
		Notes:

    .EXAMPLE
        Command: Get-BluGenieSchTaskInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSchTaskInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
					Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSchTaskInfo -OutUnEscapedJSON
        Description: Return a full list of Scheduled Tasks from the system and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieSchTaskInfo -ReturnObject
        Description: Return a full list of Scheduled Tasks from the system and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1810.2401
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.03.0201
        * Comments                  :
        * Dependencies              :
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
			~ Get-HashInfo 					- PowerShell Version 2 port of Get-FileHash
			~ Get-LiteralPath 				- Convert System Variable defined paths to a Literal Path.  %WinDir% --> C:\Windows
			~ Get-Signature					- Report on the Files Authenication Signature Information
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
        ~ 1810.2401:• [Michael Arroyo] Posted
        ~ 1901.0701:• [Michael Arroyo] Added the missing Hash FilterType option
                    • [Michael Arroyo] Updated the Search criteria to query any object using the FilterType parameter
                    • [Michael Arroyo] Updated the Remove Function to use the new Search information
        ~ 1901.2101:• [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
                    • [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
                    • [Michael Arroyo] Updated the Help information
                    • [Michael Arroyo] Added new parameter to Manage-ProcessHash to now support the updated Hash Algorithm
        ~ 1901.2601:• [Michael Arroyo] Fixed the Hash, Command, and Argument Searchs.  All of them would do a check and if nothing was
                                        found they would not update the parent task list.  Now if the items are blank the parent task
                                        list is blank as well.
                    • [Michael Arroyo] Fixed default pattern value.  It will now pull all Task Scheduled items without a pattern value
        ~ 1902.0401:• [Michael Arroyo] Updated the Command value to convert System variable defined paths to literal paths
        ~ 1902.0601:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
        ~ 1902.2001:• [Michael Arroyo] Added Signature switch.  This will pull the Signature information for the giving file or process.
                    • [Michael Arroyo] Added the Signature Search options to the -FilterType Search string
        ~ 1911.2601:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                    • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                    • [Michael Arroyo] Added more detailed information to the Return data
                    • [Michael Arroyo] Rebuilt the ( Commands ) property to be an Array
                    • [Michael Arroyo] Rebuilt the -FilterType Commands to parse the new array
                    • [Michael Arroyo] Rebuilt the -FilterType Arguments to parse the new array
                    • [Michael Arroyo] Rebuilt the -FilterType Hash to parse the new array
                    • [Michael Arroyo] Updated the Function format to follow the new New Function schema
        ~ 1912.0501:• [Michael Arroyo] Fixed the Count number to only show what number of items returned
        ~ 2002.2601:• [Michael Arroyo] Updated the "NextRunTime and LastRunTime" properties to show a valid date string.
                    • [Michael Arroyo] Updated the Code to the '145' column width standard
        ~ 2003.2601:• [Michael Arroyo] Fixed the Hash property when calling an instance with no valid file on disk.  Prior the value was
                                        the previsous files hash.
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
    [Alias('Get-SchTaskInfo','Get-BGSchTaskInfo')]
    #region Parameters
    Param
    (
        [ValidateSet(   'Path',
                        'Enabled',
                        'Hash',
                        'Command',
                        'Argument',
                        'Description',
                        'Author','Name',
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

        [ValidateSet(   "MACTripleDES",
                        "MD5",
                        "RIPEMD160",
                        "SHA1",
                        "SHA256",
                        "SHA384",
                        "SHA512"
		)]
        [string]$Algorithm = "MD5",

        [switch]$Signature,

        [Alias('Remove')]
        [switch]$RemoveTask,

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
        $HashReturn['ScheduledTasksInfo'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ScheduledTasksInfo'].StartTime = $($StartTime).DateTime
        $HashReturn['ScheduledTasksInfo'].Comment = @()
		$HashReturn['ScheduledTasksInfo']['CachePath'] = $CachePath
        $HashReturn['ScheduledTasksInfo']['Tasks'] = @()
        $HashReturn['ScheduledTasksInfo']['RemovedTasks'] = @()
        $HashReturn['ScheduledTasksInfo'].ParsedCount = 0
		$HashReturn['ScheduledTasksInfo'].Count = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['ScheduledTasksInfo'].ParameterSetResults = $PSBoundParameters
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
                $HSqlite.TableName = 'BGSchTaskInfo'
            #endregion Table Name

            #region Set Column Information
                $HSqlite.TableColumns = 'Name  TEXT PRIMARY KEY,
                Path TEXT,
                Enabled TEXT,
                NumberOfMissedRuns INTEGER,
                Commands TEXT,
                Description TEXT,
                Author TEXT,
                State TEXT,
                NextRunTime TEXT,
                LastRunTime TEXT,
                UserId TEXT,
                LastTaskResult TEXT'
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
        #region Funtions
            #region Get-AllTaskSubFolders
                function Get-AllTaskSubFolders
                {
                    [cmdletbinding()]
                    param
                    (
                        # Set to use $Schedule as default parameter so it automatically list all files
                        # For current schedule object if it exists.
                        $FolderRef = $Schedule.getfolder("\")
                    )

                    if
                    (
                        $FolderRef.Path -eq '\'
                    )
                    {
                        $FolderRef
                    }

                    if
                    (
                        -not $RootFolder
                    )
                    {
                        $ArrFolders = @()
                        if
                        (
                            ($folders = $folderRef.getfolders(1))
                        )
                        {
                            $folders | ForEach-Object `
                            -Process `
                            {
                                $ArrFolders += $_
                                if
                                (
                                    $_.getfolders(1)
                                )
                                {
                                    Get-AllTaskSubFolders -FolderRef $_
                                }
                            }
                        }
                        $ArrFolders
                    }
                }
            #endregion Get-AllTaskSubFolders

            #region Get-SubFolderTasks
                function Get-SubFolderTasks
                {
                    Param
                    (
                        [object]$QueryFolders
                    )
                    foreach
                    (
                        $Folder in $QueryFolders
                    )
                    {
                        if
                        (
                            ($Tasks = $Folder.GetTasks(1))
                        )
                        {
                            $Tasks | Foreach-Object `
                            -Process `
                            {
                                $XML = [xml]@"
$($_.xml)
"@

                                If
                                (
                                    $($XML).Task.RegistrationInfo.Author
                                )
                                {
                                    $CurAuthor = $($XML).Task.RegistrationInfo.Author
                                }
                                Else
                                {
                                    $CurAuthor = 'N/A'
                                }

                                If
                                (

                                    $($XML).Task.Principals.Principal.UserID
                                )
                                {
                                    $CurUserID = $($XML).Task.Principals.Principal.UserID
                                }
                                Else
                                {
                                    $CurUserID = 'N/A'
                                }

                                If
                                (
                                    $($XML).Task.RegistrationInfo.Description
                                )
                                {
                                    $CurDescription = $($XML).Task.RegistrationInfo.Description
                                }
                                Else
                                {
                                    $CurDescription = 'N/A'
                                }

                                <#
                                If
                                (
                                    $($XML).Task.Actions.Exec
                                )
                                {
                                    $CurCommands = $($XML.Task.Actions.Exec | Select-Object @{Name='Command';Expression={$('{0} {1}' -f `
									$_.Command,$_.Arguments)}} | Select-Object -ExpandProperty Command)
                                }
                                Else
                                {
                                    $CurCommands = 'N/A'
                                }
                                #>

                                If
                                (
                                    $($XML).Task.Actions.Exec
                                )
                                {
                                    $ArrHash = @()

                                    $XML.Task.Actions.Exec | ForEach-Object `
                                    -Process `
                                    {
                                        $CurItem = $_
                                        $CurProgram = $(Get-LiteralPath -Path $($CurItem.Command -replace ('"')))
                                        $CurArguments = $CurItem.Arguments
										$CurHash = ''
                                        $CurHash = $(Get-HashInfo -Path $CurProgram -Algorithm $Algorithm)

                                        $ObjExecProps = @{
                                            Command = $CurProgram
                                            Arguments = $CurArguments
                                            Hash = $CurHash
                                        }

                                        $ObjExec = New-Object psobject -Property $ObjExecProps

                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-Signature -Path $CurProgram -Algorithm $Algorithm)
                                            }
                                            Catch
                                            {
                                            }

                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Comment' `
												-Value $($CurSignature).Comment
                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_FileVersion' `
												-Value $($CurSignature).'File Version'
                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Description' `
												-Value $($CurSignature).Description
                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Date' `
												-Value $($CurSignature).Date
                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Company' `
												-Value $($CurSignature).Company
                                            $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Publisher' `
												-Value $($CurSignature).Publisher

                                            If
                                            (
                                                $($CurSignature).Verified
                                            )
                                            {
                                                $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' `
													-Value $($CurSignature).Verified
                                            }
                                            Else
                                            {
                                                $ObjExec | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' -Value 'N/A'
                                            }
                                        }

                                        $ArrHash += $ObjExec
                                    }

                                    $CurCommands = $ArrHash
                                }
                                Else
                                {
                                    $CurCommands = @{}
                                }

                                If
                                (
                                    $_.lastruntime
                                )
                                {
                                    $LastRunTimeString = $($_.lastruntime | Out-String).Trim()
                                }

                                If
                                (
                                    $_.nextruntime
                                )
                                {
                                    $NextRunTimeString = $($_.nextruntime | Out-String).trim()
                                }

                                New-Object -TypeName PSCustomObject -Property @{
                                    'Name' = $_.name
                                    'Path' = $_.path
                                    'State' = switch ($_.State)
                                    {
                                        0 {'Unknown'}
                                        1 {'Disabled'}
                                        2 {'Queued'}
                                        3 {'Ready'}
                                        4 {'Running'}
                                        Default {'Unknown'}
                                    }
                                    'Enabled' = $_.enabled
                                    'LastRunTime' = $LastRunTimeString
                                    'LastTaskResult' = $_.lasttaskresult
                                    'NumberOfMissedRuns' = $_.numberofmissedruns
                                    'NextRunTime' = $NextRunTimeString
                                    'Author' =  $CurAuthor
                                    'UserId' = $CurUserID
                                    'Description' = $CurDescription
                                    'Commands' = $CurCommands
                                }
                            }
                        }
                    }
                }
            #endregion Get-SubFolderTasks
        #endregion Funtions

		#region Pull Scheduled Tasks
            $Error.Clear()

            try
            {
                $schedule = New-Object -ComObject ("Schedule.Service")
            }
            catch
            {
                Write-Warning "Schedule.Service COM Object not found, this script requires this object"
                return
            }

            $Schedule.connect($env:COMPUTERNAME)
            $AllFolders = Get-AllTaskSubFolders
            $SchTaskList = Get-SubFolderTasks -QueryFolders $AllFolders
        #endregion Pull Scheduled Tasks

        #region Set Parsed Count
            If
            (
                $SchTaskList
            )
            {
                $HashReturn['ScheduledTasksInfo'].ParsedCount = $SchTaskList | Measure-Object | Select-Object -ExpandProperty Count
            }
        #endregion Set Parsed Count

        #region Query Scheduled Tasks
            $ArrTempData = @()

            $SchTaskList | ForEach-Object `
            -Process `
            {
                $CurTaskItem = $_

                #region Filter
                    $CurFilterFound = $false

                    Switch
                    (
                        $FilterType
                    )
                    {
                        #Hash Filter
                        'Hash'
                        {
                            If
                            (
                                $CurTaskItem.Commands.Hash -match $Pattern
                            )
                            {
                                $CurFilterFound = $true
                            }

                        }
                        #Command Filter
                        'Command'
                        {
                            If
                            (
                                $CurTaskItem.Commands.Command -match $Pattern
                            )
                            {
                                $CurFilterFound = $true
                            }
                        }
                        #Argument Filter
                        'Argument'
                        {
                            If
                            (
                                $CurTaskItem.Commands.Command -match $Pattern
                            )
                            {
                                $CurFilterFound = $true
                            }
                        }
                        #Default Filter
                        Default
                        {
                            If
                            (
                                $CurTaskItem | Where-Object -FilterScript { $CurTaskItem.$($FilterType) -match $Pattern }
                            )
                            {
                                $CurFilterFound = $true
                            }
                        }
                    }
                #endregion Filter

                #region Append Data
                    If
                    (
                        $CurFilterFound
                    )
                    {
                        #region Setup Caching
                            If
                            (
                                $UseCache
                            )
                            {
                                '---' | Out-File -FilePath $CachePath -Append -Force
                                $CurTaskItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                            }
                            Else
                            {
                                $ArrTempData += $CurTaskItem
                            }

                            If
                            (
                                $UpdateDB
                            )
                            {
                                $CurTaskItem.Commands = $CurTaskItem.Commands | ConvertTo-Json -Compress

                                If
                                (
                                    $ForceDBUpdate
                                )
                                {
                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurTaskItem | `
                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                }
                                Else
                                {
                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurTaskItem | `
                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                }
                            }

                            $CurTaskItem = $null
                        #endregion Setup Caching
                    }
                #endregion Append Data
            }
        #endregion Query Scheduled Tasks

        #region Cleanup
            $SchTaskList = $null

            If
            (
                $ClearGarbageCollecting
            )
            {
                    $null = Clear-BlugenieMemory
            }
        #endregion Cleanup

        #region Task Count
            If
            (
                $ArrTempData
            )
            {
                $HashReturn['ScheduledTasksInfo'].Tasks += $ArrTempData
            }
            ElseIf
            (
                $UseCache
            )
            {
                $Error.Clear()
                Try
                {
                    $HashReturn['ScheduledTasksInfo'].Tasks += Get-Content -Path $CachePath -ErrorAction Stop | ConvertFrom-Yaml -AllDocuments
                }
                Catch
                {
                    If
                    (
                        $Error.Count -gt 0
                    )
                    {
                        $HashReturn['ScheduledTasksInfo'].Comment += Get-BGErrorAction
                    }
                }

                If
                (
                    $RemoveCache
                )
                {
                    $Null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                }
            }

            $HashReturn['ScheduledTasksInfo'].Count = $HashReturn['ScheduledTasksInfo'].Tasks | Measure-Object | `
                Select-Object -ExpandProperty Count
        #endregion Task Count

        #region Remove Tasks Items based on Query
            If
            (
                $RemoveTask
            )
            {
                $ArrObjRemoveTasks = @()

                $HashReturn['ScheduledTasksInfo'].Tasks | ForEach-Object `
                -Process `
                {
                    $CurTask = $_
                    $Error.Clear()

                    Try
                    {
                        $TaskFolder = $Schedule.GetFolder((Split-Path -Path $CurTask.Path))
                        $TaskFolder.DeleteTask((Split-Path -Path $CurTask.Path -Leaf),0)

                        $ObjRemoveTasks = New-Object -TypeName psobject
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Name' -Value $($CurTask.Name)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Path' -Value $($CurTask.Path)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Status' -Value $($true)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Comment' -Value 'Null'
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'TimeStamp' `
							-Value $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
                        $ArrObjRemoveTasks += $ObjRemoveTasks
                    }
                    Catch
                    {
                        $ObjRemoveTasks = New-Object -TypeName psobject
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Name' -Value $($CurTask.Name)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Path' -Value $($CurTask.Path)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Status' -Value $($false)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'Comment' -Value $($Error.exception.message)
                        $ObjRemoveTasks | Add-Member -MemberType NoteProperty -Name 'TimeStamp' `
							-Value $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
                        $ArrObjRemoveTasks += $ObjRemoveTasks
                    }
                }

                $HashReturn['ScheduledTasksInfo']['RemovedTasks'] += $($ArrObjRemoveTasks)
            }
        #endregion Remove Tasks Items based on Query
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ScheduledTasksInfo'].EndTime = $($EndTime).DateTime
        $HashReturn['ScheduledTasksInfo'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
            Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Remove Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['ScheduledTasksInfo'].Remove('StartTime')
            $null = $HashReturn['ScheduledTasksInfo'].Remove('ParameterSetResults')
            $null = $HashReturn['ScheduledTasksInfo'].Remove('CachePath')
            $null = $HashReturn['ScheduledTasksInfo'].Remove('EndTime')
            $null = $HashReturn['ScheduledTasksInfo'].Remove('ElapsedTime')
        }

		#region Output Type
            $ResultSet = $(New-Object -TypeName PSObject -Property @{
                Tasks = $HashReturn['ScheduledTasksInfo'].Tasks
                RemovedTasks = $HashReturn['ScheduledTasksInfo'].RemovedTasks
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
#endregion Get-BluGenieSchTaskInfo (Function)