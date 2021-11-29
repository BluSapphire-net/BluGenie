#region Get-BluGenieChildItemList (Function)
Function Get-BluGenieChildItemList
{
    <#
    .SYNOPSIS
        Query for a list of files and folders that match a specific pattern

    .DESCRIPTION
        Query for a list of files and folders that match a specific pattern

        Fastest search is based on the filter type set to "Name" this is default
        Slower search is based on all other filter type properties (Reference the Parameter FilterType to review)

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
                Filter Option = "Path"					-   Path Query with general file information
                Filter Option = "PathIncludeAll"        -   Path Query with extended file metadata
                Filter Option = "Name"                 	-   Name Query with general file information
                Filter Option = "NameIncludeAll"        -   Name Query with extended file metadata
                Filter Option = "Type"             		-   File Type Query with general file information
                Filter Option = "TypeIncludeAll"        -   File Type Query with extended file metadata
                Filter Option = "Hash"                  -   Hash Value Query with general file information
                Filter Option = "HashIncludeAll"		-	Hash Value Query with extended file metadata
                Filter Option = "ADS"					-	Alternate Data Stream Query (True Only) with general file information
                Filter Option = "ADSIncludeAll"		    -	Alternate Data Stream Query (True Only) with extended file metadata

                Default is a "Name" Query
        Alias:
        ValidateSet: 'Path','PathIncludeAll','Name','NameIncludeAll','Type','TypeIncludeAll','Hash','HashIncludeAll','ADS','ADSIncludeAll'

    .PARAMETER Pattern
        Description: Search Pattern using RegEx
        Notes: Using -SearchHidden will convert the Pattern to RegEx Automatically but without the comma or
    the -SearchHidden the -Pattern is viewed as as a Command Console Search pattern.  You can use (*) wildcards.
        Alias:
        ValidateSet:

    .PARAMETER Remove
        Description: Remove the File(s) and Directory(s) found
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER SearchPath
        Description: The path to start your search from
        Notes:
                If you specify "Temp" in the SearchPath field all the %SystemDrive%\Users\* Temp directories and the
                %SystemRoot%\Temp will be searched only.

                If you specify "AllUsers" in the SearchPath path all User Profiles from %SystemDrive%\Users will be
                prefixed to the rest of the path.
                    Example:  -SearchPath 'AllUsers\AppData\Roaming'

                    Output:     C:\Users\Administrator\AppData\Roaming
                                C:\Users\User1\AppData\Roaming
                                C:\Users\User2\AppData\Roaming
                                C:\Users\User3\AppData\Roaming
                                C:\Users\User4\AppData\Roaming
        Alias:
        ValidateSet:

    .PARAMETER Recurse
        Description: Recurse through subdirectories
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER StopWatchCounter
        Description: Determine how many times the recheck for removing a file or directory happenes.  By default (12) times with a 5 second sleep
        Notes:  Determine how many times the recheck for removing a file or directory happenes.  By default (12) times with a 5 second sleep
                inbetween which is (60 seconds total)
        Alias:
        ValidateSet:

    .PARAMETER SleepTimerSec
        Description: Determine the Sleep time in seconds before the next recheck.  By default this is a 5 second sleep with 12 rechecks
        Notes:  Determine the Sleep time in seconds before the next recheck.  By default this is a 5 second sleep with 12 rechecks which is
                (60 seconds total)
        Alias:
        ValidateSet:

    .PARAMETER Signature
        Description: Query Signature information
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Permissions
        Description: Query Access Control List (ACL) information
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ShowStreamValue
        Description: If an Alternate Data Stream is found display the Stream data based on each streams name and stream content.
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ShowProgress
        Description: Display file count information to the Host to show query progress
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
        Command: Get-BluGenieChildItemList -SearchPath C:\Temp -Recurse -Pattern '^notepad\.\w{3}$'
        Description: Search C:\Temp and all sub directories for any file or directory named Notepad.*
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath C:\Temp,C:\Trash,C:\Users -Recurse -Pattern '^notepad\.\w{3}$'
        Description: Search multiple directories and all sub directories for any file or directory named Notepad.*.
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath C:\Temp,C:\Trash,C:\Users -Recurse -Pattern '0e61079d3283687d2e279272966ae99d' -FilterType
    Hash
        Description: Search multiple directories and the sub directories for a Hash value determined by the default Algorithm type of MD5
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath C:\Windows -Pattern '^notepad\.\w{3}$' -Permissions -ShowStreamValue -Signature
        Description: Query the C:\Windows dir for a file or directory named Notepad.* and return all associated Permissions, Alternate Data
    Streams, and Signature information
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse
        Description: Search for all file(s) under (All Temp Locations for each user and the system) and sub directories
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache
        Description: Cache found objects to disk to not over tax Memory resources
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -RemoveCache
        Description: Remove Cache data
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -CachePath $Env:Temp
        Description: Change the Cache path to the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-ChildItem -path $env:temp -File | Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -ClearGarbageCollecting
        Description: Scan large directories and limit the memory used to track data
        Notes:

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath 'Temp' -Recurse -FilterType NameIncludeAll -UpdateDB
        Description: Search every user and system Temp directory for all normal file information including hash and save the return to a DB
        Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie

    .EXAMPLE
        Command: Get-BluGenieChildItemList -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
    Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieChildItemList -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
    Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
    This parameter is also used with the ForMat

    .EXAMPLE
        Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml', 'XML')
    Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES
        ~ Original Author           :
            *    Michael Arroyo
        ~ Original Build Version    :
            *    19.01.0501 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        ~ Latest Author             :
            *    Michael Arroyo
        ~ Latest Build Version      :
            *    21.03.0201
        ~ Comments                  :
            *
        ~ PowerShell Compatibility  :
            *    2,3,4,5.x
        ~ Forked Project            :
            *
        ~ Links                     :
            *
        ~ Dependencies              :
            *    New-TimeStamp - Return a Time Stamp specifically for log files
            *    New-UID - Create a New UID
            *    Invoke-WalkThrough -  is an interactive help menu system
            *    Get-ErrorAction - will round up any errors into a simple object
            *    Get-LiteralPath - Get-LiteralPath will convert System Variable defined paths to a Literal Path
    #>

    #region Build Notes
    <#
    ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
        * 19.01.0501:   ~ [Michael Arroyo] Posted
        * 19.01.0601:   ~ [Michael Arroyo] Added the missing Hash FilterType option
        * 19.01.0602:   ~ [Michael Arroyo] Updated the SearchPath field to support multiple paths
                        ~ [Michael Arroyo] Updated the SearchPath field query all Temp directories using the (Temp) value in the SearchPath
                                            If you specify "Temp" in the SearchPath field all the %SystemDrive%\Users\* Temp directories and
                                            the %SystemRoot%\Temp will be searched only
        * 19.01.2101:   ~ [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
                        ~ [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
                        ~ [Michael Arroyo] Updated the Help information
        * 19.01.2102:   ~ [Michael Arroyo] Added a process to rebuild the Search path for all users if a value of %UserProfiles% was used in
                                            the SearchPath
        * 19.02.0401:   ~ [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help
                                            information
        * 19.02.1201:   ~ [Michael Arroyo] Updated the %UserProfiles% variable flag to 'AllUsers'
                        ~ [Michael Arroyo] Updated the SearchPath value to process the (Get-LiteralPath) function to validate the path
        * 19.02.1801:   ~ [Michael Arroyo] Added Signature switch.  This will pull the Signature information for the giving file or process.
                        ~ [Michael Arroyo] Added the Signature Search options to the -FilterType Search string
        * 19.02.2801:   ~ [Michael Arroyo] Added MaxReturnCount into the Automated Help section
                        ~ [Michael Arroyo] Updated the Search Process for Temp folders to located hidden folders
                        ~ [Michael Arroyo] Updated the Search Process for AllUsers folders to located hidden folders
                        ~ [Michael Arroyo] Updated the File / Directory check with Test-Path instead of Get-item
                        ~ [Michael Arroyo] Updated the File Check counter.  The counter was still set for the original testing.
        * 19.04.0101:   ~ [Michael Arroyo] Updated the -FilterType parameter to have a default value of (Any)
                        ~ [Michael Arroyo] Removed the Security Search Properties.  These values are still logged but not searchable.
                                            Note: Alternate Data Streams, and Permissions are also not searchable but are logged.
                        ~ [Michael Arroyo] Updated the -Pattern parameter to have a default value of '^(?s:.)*' which equals (Starting \
                                            Position at the beginning of the string, matching any single char including line breaks)
                        ~ [Michael Arroyo] Added the ReturnObject switch.  This will return the data as an object instead of the normal
                                            HashTable
                        ~ [Michael Arroyo] Added the Permissions switch to Query the Access Control List of each found item
                        ~ [Michael Arroyo] Added the Parameter Set Results to display and log what flags were set on function startup.  This
                                            is to help manage any errors.
                        ~ [Michael Arroyo] Added the NotMatch switch to enable Not Matching pattern queries
                        ~ [Michael Arroyo] Added an ADS [True\False] property for tracking
                        ~ [Michael Arroyo] Added the ShowStreamValue switch to display each stream name and stream content if an Alternate
                                            Data Stream is found
                        ~ [Michael Arroyo] Redesigned the search function to make it more dynamic.  With all the added functions/updates above
                                            this function is roughly 1000 lines smaller than before!!!
        * 19.04.0401:   ~ [Michael Arroyo] Removed the Signature properties from the Help validation set.  This is no longer used and was
                                            causing issues in the dynamic help menu.
        * 19.05.3001:   ~ [Michael Arroyo] Updated the Walktrough Function to version 1905.2401
                        ~ [Michael Arroyo] Updated ParameterSetResults with $PSBoundParameters and removed each seperate call.
                        ~ [Michael Arroyo] Updated the Search for FilterType name to be Faster
                        ~ [Michael Arroyo] Cleaned up the entire search function
                        ~ [Michael Arroyo] Added Parameter OutUnEscapedJSON to show beautify the JSON file and clean up the formatting.
                        ~ [Michael Arroyo] Removed the need for the -ExactMatch parameter
                        ~ [Michael Arroyo] Added Parameter SearchHidden, this will search system and hidden files as well.  This will slow
                                            down the results a bit.  Default this is not set.
        * 19.06.0201    ~ [Michael Arroyo] Updated the Path search to accommodate for double \\ in the path.
        * 19.06.0701    ~ [Michael Arroyo] Updated the Pattern to ( * ).  If -SearchHidden switch is used and the pattern equals ( * ), the
                                            RegEx equivalent will be used.
                        ~ [Michael Arroyo] Removed the -ExactMatch example as it is longer longer used
                        ~ [Michael Arroyo] Updated the search results query
        * 19.06.1001    ~ [Michael Arroyo] Updated the entire search function to process the data quicker
                        ~ [Michael Arroyo] All searches look for hidden and system files without a parameter
                        ~ [Michael Arroyo] Added a parameter called Quick.  This will process the search in (CMD.EXE) which is faster than any
                                            .NET command
                        ~ [Michael Arroyo] Added Start, End, and Time Spane values to the returning JSON
                        ~ [Michael Arroyo] Updated all the Examples
        * 19.06.1701    ~ [Michael Arroyo] Added Error redirection for -Quick so long file path errors do not flood the main error log.
                        ~ [Michael Arroyo] Updated the Query to filter out nested Application Data information.  This happens because Windows
                                            supports Juntions Paths and AppData is also 'Application Data' and it continues to loop the
                                            Juntion path
        * 19.07.0501    ~ [Michael Arroyo] Updated the Temp directory Query to validate all paths before processing any searches.  This will
                                            speed up the query and help the quick search process.
        * 19.07.1001    ~ [Michael Arroyo] Updated / Added back the (AllUsers) path process to automatically build a path to each user in the
                                            $env:SystemDrive\Users directory.  If there is an extended path it will be appended.
                        ~ [Michael Arroyo] Updated the (AllUsers) directory Query to validate all paths before processing any searches.  This
                                            will speed up the query and help the quick search process.
        * 19.10.3001    ~ [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                        ~ [Michael Arroyo] Updated the Hash Information to follow the new function standards
                        ~ [Michael Arroyo] Added more detailed information to the Return data
        * 19.11.0501    ~ [Michael Arroyo] Added a directory check before processing the search command.  If a directory didn't exist the
                                            default PowerShell cmdlet would search the C:\Users directory on it's own.
        * 19.11.0501    ~ [Michael Arroyo] Added a variable check before processing the search command for (Quick) Searches.  If no
                                            directories were found the search pattern was set to a default.  It should end if the paths do not
                                            exist.
        * 19.11.2401:   ~ [Michael Arroyo] Added a Sub Task to Report on Locked files if the file cannot be removed.
                        ~ [Michael Arroyo] Fixed the Error message return when items could not be deleted.
        * 19.12.0401:   ~ [Michael Arroyo] Updated the Propety Items > Hash Value to (Text) to support Elastic Search
                        ~ [Michael Arroyo] Updated the Propety Items > ADS Value to (Text) support Elastic Search
                        ~ [Michael Arroyo] Updated the Propety Items > Streams Value to to an (Object) to support Elastic Search
        * 20.01.0501:   ~ [Michael Arroyo] Where-Object -FilterScript missing for FilterType other than the 'Name'
                                            property
        * 20.02.2401:   ~ [Michael Arroyo] Updated the directory search process to capture directories that have
                                            have different attribute value then just Directoyr Example: 'ReadOnly,Directory',etc
                        ~ [Michael Arroyo] Updated the Code to the '145' column width standard
        * 20.03.2401:   ~ [Michael Arroyo] Fixed the Quick Directory Query
                        ~ [Michael Arroyo] Updated the error management around $RedirectErrOutput
                        ~ [Michael Arroyo] Updated the RegEx filter for SearchType [File / Directory / and Any]
                        ~ [Michael Arroyo] Fixed the Attribute analyzer from Get-Item to [System.IO.FileInfo].  Get-Item code uses the
                                            GetFileAttributes function to determine whether a file exists. Because it's returning -1 for
                                            in use system files, the FileSystemProvider is behaving as though the file doesn't exist.
                        ~ [Michael Arroyo] Updated hash information header with comment section for errors
                        ~ [Michael Arroyo] Updated the error capture event to save all errors to the new Hash information header
        * 20.04.0401:   ~ [Michael Arroyo] Updated the Get-ErrorAction return to make sure there is an $error value before running
        * 20.05.2001:   ~ [Michael Arroyo] Added [CmdletBinding()]
                        ~ [Michael Arroyo] Fixed the Get-LiterPath in the SearchPath variable
        * 20.05.2101:   ~ [Michael Arroyo] Updated to support Posh 2.0
        * 20.11.0901:   ~ [Michael Arroyo] Updated the search function for older systems from /a-o-l to /a-l based on older systems not having
                                            the parameter /a-o
        * 20.11.0901:   ~ [Michael Arroyo] Added a Recursive method to detect Junction points.  This stops endless loops when detecting
                                        Junctions Point.
                        ~ [Michael Arroyo] Updated function to the newest Function Template (20.05.2201)
        * 20.11.1101:   ~ [Michael Arroyo] Consolidation of over 500 lines of code.
                        ~ [Michael Arroyo] Update to the Permissions method.  Permissions were not grabbing the array of permission, which is
                                            now being captured.
        * 20.11.1201:   ~ [Michael Arroyo] Updated the FilterType list to 'Path','PathIncludeAll','Name','NameIncludeAll','Type',
                                            'TypeIncludeAll','Hash','HashIncludeAll','ADS','ADSIncludeAll'
                        ~ [Michael Arroyo] Added a new search Algorithm to each FilterTyper
                        ~ [Michael Arroyo] Updated the Permissions method to remove extra spaces at the end of the strings.  This was causing
                                            the return to be on multiple lines.
                        ~ [Michael Arroyo] Updated the ShowStreamContent method to remove extra spaces at the end of the strings.  This was
                                            causing the return to be on multiple lines.
                        ~ [Michael Arroyo] Set the $SearchPath default value to the scripts current running location.
        * 20.11.1601:   ~ [Michael Arroyo] Added FullName property value back for Elastic Search specific searches
                        ~ [Michael Arroyo] Renamed the { Found } key value back to FoundItems for Elastic Search specific searches
        * 20.11.2301:   ~ [Michael Arroyo] Fixed ParameterSetResults, which now shows a valid output instead of a PowerShell Object reference
                        ~ [Michael Arroyo] Updated internal Function Recuse to a Verb-Noun Function called Start-Recurse
                        ~ [Michael Arroyo] Fixed the FoundItems value to better manage the returning item count
        * 20.11.2302:   ~ [Michael Arroyo] Fixed ParameterSetResults, which now shows a valid output instead of a PowerShell Object reference
                        ~ [Michael Arroyo] Added new parameters (UseCache, RemoveCache, CachePath, ClearGarbageCollecting, OutYaml, and
                                            FormatView)
                        ~ [Michael Arroyo] Updated Help and Example Information to details the new parameters
                        ~ [Michael Arroyo] Added support for (Clean-BluGenieMemory).  This will clean up any garbage collecting done by
                                            PowerShell
                        ~ [Michael Arroyo] Added support to save found artifacts to disk instead of memory using the -UseCache parameter
                        ~ [Michael Arroyo] Added support to change the Cache Path.  The default path is %WinDir%\Temp.
                        ~ [Michael Arroyo] Added support to remove cached data using the -RemoveCache parameter.  By default this is disabled.
                        ~ [Michael Arroyo] Added support to Output the detailed return data to Yaml
                        ~ [Michael Arroyo] Added support to FormatView to change the Objects returned while using -Returnobject to a Yaml
                                            format
                        ~ [Michael Arroyo] Added CachePath information to the Detailed report
                        ~ [Michael Arroyo] Added a Dynamic parameter update process to change set parameters if a version of Posh 2 is
                                            installed Currently Caching is not supported in Posh2.
                        ~ [Michael Arroyo] Updated the Sub function (Recurse) to a valid (Verb-Noun) functioin name called Start-Recurse
                        ~ [Michael Arroyo] Added a Remove property to the Return data Object / Information
                        ~ [Michael Arroyo] Moved the Sub Process (Permission Info) to an External function called Get-BluGenieFilePermissions
                        ~ [Michael Arroyo] Moved the Sub Process (ADS Info) to an External function called Get-BluGenieFileADS
                        ~ [Michael Arroyo] Moved the Sub Process (Stream Info) to an External function called Get-BluGenieFileStreams
                        ~ [Michael Arroyo] Moved the Sub Process (Remove File) to an External function called Remove-BluGenieFile
                        ~ [Michael Arroyo] Moved the Sub Process (Permission) to an External function called Get-BluGenieFilePermissions
                        ~ [Michael Arroyo] Moved the Sub Process (Permission) to an External function called Get-BluGenieFilePermissions
        * 21.01.0401:   ~ [Michael Arroyo] Added Sqlite Functionality
                        ~ [Michael Arroyo] Added new parameters (DBName, DBPath, UpdateDB, and ForceDBUpdate).
                                            Please read the parameter help section for more information
                        ~ [Michael Arroyo] Fixed the Help information region. Moved the ( Build Version Details ) from main help.
                                            There is a Char limit and PSHelp could not read all the information correctly which also created
                                            issues using the ( WalkThrough ) parameter as well.
                        ~ [Michael Arroyo] Updated this function / script based on the new Linter ( PSScriptAnalyzerSettings )
                        ~ [Michael Arroyo] Added Alias 'Get-BGChildItemList' directly to the Function
        * 21.02.1201:   ~ [Michael Arroyo] Updated mispelling of Variable ( TalbeColumns -> TableColumns )
                        ~ [Michael Arroyo] Updated mispelling of DB Column ( INTERGER -> INTEGER )
        * 21.02.2201:   ~ [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
        * 21.03.0201:   ~ [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
                        ~ [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                        ~ [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                        ~ [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                        ~ [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
    #>
    #endregion Build Notes

    [cmdletbinding()]
    [Alias('Get-ChildItemList','Get-BGChildItemList')]
    #region Parameters
        Param
        (
            [Alias('Path')]
            $SearchPath = $(Get-Location).Path,

            [switch]$Recurse,

            [ValidateSet('Path',
                            'PathIncludeAll',
                            'Name',
                            'NameIncludeAll',
                            'Type',
                            'TypeIncludeAll',
                            'Hash',
                            'HashIncludeAll',
                            'ADS',
                            'ADSIncludeAll'
            )]
            [Alias('Filter')]
            [string]$FilterType = 'Name',

            $Pattern = '.*',

            [switch]$Remove,

            [int]$StopWatchCounter = 12,

            [int]$SleepTimerSec = 5,

            [ValidateSet('MACTripleDES', 'MD5', 'RIPEMD160', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
            [string]$Algorithm = 'MD5',

            [switch]$Signature,

            [switch]$Permissions,

            #[switch]$NotMatch,

            [switch]$ShowStreamValue,

            [Switch]$ShowProgress,

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

            [ValidateSet('Table', 'Custom', 'CustomModified', 'None', 'JSON', 'OutUnEscapedJSON', 'CSV', 'Yaml')]
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
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough
            )
            {
                If
                (
                    $Function -eq 'Invoke-BluGenieWalkThrough'
                )
                {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
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
        $HashReturn.ItemList = @{}
        $HashReturn.ItemList.Items = @()
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ItemList']['StartTime'] = $($StartTime).DateTime
        $HashReturn['ItemList'].ParameterSetResults = @()
		$HashReturn['ItemList']['Comments'] = @()
        $HashReturn['ItemList']['ParsedFiles'] = 0
        $HashReturn['ItemList']['ParsedDirectories'] = 0
        $HashReturn['ItemList']['FoundItems'] = 0
        $HashReturn['ItemList']['CachePath'] = $CachePath
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['ItemList'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

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
                $HSqlite.TableName = 'BGChildItemList'
            #endregion Table Name

            #region Set Column Information
                $HSqlite.TableColumns = 'FullName TEXT PRIMARY KEY,
                Name TEXT,
                Hash TEXT,
                ShortName TEXT,
                ShortPath TEXT,
                Path TEXT,
                Owner TEXT,
                PSIsContainer TEXT,
                SizeInBytes INTEGER,
                Attributes TEXT,
                Target TEXT,
                Extension TEXT,
                Type TEXT,
                LinkType TEXT,
                CreationTime TEXT,
                CreationTimeUtc TEXT,
                LastWriteTime TEXT,
                LastWriteTimeUtc TEXT,
                LastAccessTimeUtc TEXT,
                LastAccessTime TEXT,
                Signature_Date TEXT,
                StreamContent TEXT,
                Signature_Company TEXT,
                Signature_Comment TEXT,
                Signature_Description TEXT,
                Signature_Verified TEXT,
                Signature_FileVersion TEXT,
                Signature_Publisher TEXT,
                Removed TEXT,
                Permissions TEXT,
                Streams TEXT,
                ADS TEXT'
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

    #region Load Internal Functions
        #region Function Start-Recurse
            $Script:ArrFilesandFolders = @()
            $Script:IntFiles = 0
            $Script:IntFolders = 0

            function Start-Recurse
            {
                param
                (
                    [String]$Path,

                    [Switch]$Recurse
                )
                    #region Current File Object Properties
                        $CurObjFileProp = @{
                            FullName              = ''
                            Path                  = ''
                            Name                  = ''
                            ShortPath             = ''
                            ShortName             = ''
                            SizeInBytes           = 0
                            Type                  = ''
                            PSIsContainer         = 'False'
                            Target                = @()
                            LinkType              = ''
                            Extension             = ''
                            CreationTime          = ''
                            CreationTimeUtc       = ''
                            LastAccessTime        = ''
                            LastAccessTimeUtc     = ''
                            LastWriteTime         = ''
                            LastWriteTimeUtc      = ''
                            Attributes            = ''
                            Hash                  = ''
                            ADS                   = 'False'
                            Streams               = @()
                            Signature_Comment     = ''
                            Signature_FileVersion = ''
                            Signature_Description = ''
                            Signature_Date        = ''
                            Signature_Company     = ''
                            Signature_Publisher   = ''
                            Signature_Verified    = ''
                            Permissions           = @()
                            Owner                 = ''
                            StreamContent         = @()
                            Removed               = @()
                        }
                    #endregion Current File Object Properties

                    #region Create File System Object
                        $fc = new-object -ComObject scripting.filesystemobject
                        $folder = $fc.getfolder($Path)
                        $CurObjFile = $null
                    #endregion Create File System Object

                    #region Process FilterTyper Query
                    Switch
                    (
                        $FilterType
                    )
                    {
                        #region Path Query
                            'Path'
                            {
                                #Path Filter
                                $folder.Files | Where-Object -FilterScript { $_.Path -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null

                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Path Query

                        #region Path Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)
                            'PathIncludeAll'
                            {
                                $folder.Files | Where-Object -FilterScript { $_.Path -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurGetItem = Get-Item -Path $_.Path -Force | Select-Object *
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.Hash = $(Get-BluGenieHashInfo -Path $CurObjFile.Path -Algorithm $Algorithm `
                                        -ErrorAction SilentlyContinue)
                                    $CurObjFile.Target = $CurGetItem.Target
                                    $CurObjFile.LinkType = $CurGetItem.LinkType
                                    $CurObjFile.Extension = $CurGetItem.Extension
                                    $CurObjFile.CreationTimeUtc = $($CurGetItem.CreationTimeUtc | Out-String).trim()
                                    $CurObjFile.LastAccessTimeUtc =  $($CurGetItem.LastAccessTimeUtc | Out-String).trim()
                                    $CurObjFile.LastWriteTimeUtc =  $($CurGetItem.LastWriteTimeUtc | Out-String).trim()
                                    $CurObjFile.Attributes = $CurGetItem.Attributes

                                    #region ADS Streams
                                        $CurADSData = Get-BluGenieFileADS -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue

                                        If
                                        (
                                            $($CurADSData.HasADS)
                                        )
                                        {
                                            $CurObjFile.ADS = $CurADSData.HasADS
                                            $CurObjFile.Streams += $CurADSData.ADSName
                                        }
                                    #endregion ADS Streams

                                    #region Process ShowStreamValue Information
                                        If
                                        (
                                            $CurObjFile.ADS
                                        )
                                        {
                                            $CurStreamData = $(Get-BluGenieFileStreams -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurStreamData.Streams
                                            )
                                            {
                                                $CurObjFile.StreamContent += $CurStreamData.Streams
                                            }
                                        }
                                    #endregion Process ShowStreamValue Information

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null
                                    $CurADSData = $null
                                    $CurGetItem = $null
                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Path Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)

                        #region Name Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)
                            'NameIncludeAll'
                            {
                                $folder.Files | Where-Object -FilterScript { $_.Name -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurGetItem = Get-Item -Path $_.Path -Force | Select-Object *
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.Hash = $(Get-BluGenieHashInfo -Path $CurObjFile.Path -Algorithm $Algorithm `
                                        -ErrorAction SilentlyContinue)
                                    $CurObjFile.Target = $CurGetItem.Target
                                    $CurObjFile.LinkType = $CurGetItem.LinkType
                                    $CurObjFile.Extension = $CurGetItem.Extension
                                    $CurObjFile.CreationTimeUtc = $($CurGetItem.CreationTimeUtc | Out-String).trim()
                                    $CurObjFile.LastAccessTimeUtc =  $($CurGetItem.LastAccessTimeUtc | Out-String).trim()
                                    $CurObjFile.LastWriteTimeUtc =  $($CurGetItem.LastWriteTimeUtc | Out-String).trim()
                                    $CurObjFile.Attributes = $CurGetItem.Attributes

                                    #region ADS Streams
                                        $CurADSData = Get-BluGenieFileADS -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue

                                        If
                                        (
                                            $($CurADSData.HasADS)
                                        )
                                        {
                                            $CurObjFile.ADS = $CurADSData.HasADS
                                            $CurObjFile.Streams += $CurADSData.ADSName
                                        }
                                    #endregion ADS Streams

                                    #region Process ShowStreamValue Information
                                        If
                                        (
                                            $CurObjFile.ADS
                                        )
                                        {
                                            $CurStreamData = $(Get-BluGenieFileStreams -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurStreamData.Streams
                                            )
                                            {
                                                $CurObjFile.StreamContent += $CurStreamData.Streams
                                            }
                                        }
                                    #endregion Process ShowStreamValue Information

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null
                                    $CurADSData = $null
                                    $CurGetItem = $null
                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Name Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)

                        #region Type Query
                            'Type'
                            {
                                #Type Filter
                                $folder.Files | Where-Object -FilterScript { $_.Type -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.PSIsContainer = 'False'
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null

                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Type Query

                        #region Type Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)
                            'TypeIncludeAll'
                            {
                                $folder.Files | Where-Object -FilterScript { $_.Type -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurGetItem = Get-Item -Path $_.Path -Force | Select-Object *
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.PSIsContainer = 'False'
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.Hash = $(Get-BluGenieHashInfo -Path $CurObjFile.Path -Algorithm $Algorithm `
                                        -ErrorAction SilentlyContinue)
                                    $CurObjFile.Target = $CurGetItem.Target
                                    $CurObjFile.LinkType = $CurGetItem.LinkType
                                    $CurObjFile.Extension = $CurGetItem.Extension
                                    $CurObjFile.CreationTimeUtc = $($CurGetItem.CreationTimeUtc | Out-String).trim()
                                    $CurObjFile.LastAccessTimeUtc =  $($CurGetItem.LastAccessTimeUtc | Out-String).trim()
                                    $CurObjFile.LastWriteTimeUtc =  $($CurGetItem.LastWriteTimeUtc | Out-String).trim()
                                    $CurObjFile.Attributes = $CurGetItem.Attributes

                                    #region ADS Streams
                                        $CurADSData = Get-BluGenieFileADS -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue

                                        If
                                        (
                                            $($CurADSData.HasADS)
                                        )
                                        {
                                            $CurObjFile.ADS = $CurADSData.HasADS
                                            $CurObjFile.Streams += $CurADSData.ADSName
                                        }
                                    #endregion ADS Streams

                                    #region Process ShowStreamValue Information
                                        If
                                        (
                                            $CurObjFile.ADS
                                        )
                                        {
                                            $CurStreamData = $(Get-BluGenieFileStreams -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurStreamData.Streams
                                            )
                                            {
                                                $CurObjFile.StreamContent += $CurStreamData.Streams
                                            }
                                        }
                                    #endregion Process ShowStreamValue Information

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null
                                    $CurADSData = $null
                                    $CurGetItem = $null
                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Type Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)

                        #region Hash Query
                            'Hash'
                            {
                                Get-BluGenieHashInfo -Path $($folder.Files).path -FormatView None -Algorithm $Algorithm | `
                                    Where-Object -FilterScript { $_.HashValue -match $pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurHashInfo = $_
                                    $CurFileInfo = $folder.Files | Where-Object -FilterScript { $_.Path -eq $CurHashInfo.Path }
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $CurFileInfo.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $CurFileInfo.Name
                                    $CurObjFile.ShortPath = $CurFileInfo.ShortPath
                                    $CurObjFile.ShortName = $CurFileInfo.ShortName
                                    $CurObjFile.SizeInBytes = $CurFileInfo.Size
                                    $CurObjFile.Type = $($CurFileInfo.Type | Out-String).Trim()
                                    $CurObjFile.PSIsContainer = 'False'
                                    $CurObjFile.CreationTime = $($CurFileInfo.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($CurFileInfo.DateLastAccessed | `
                                        Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($CurFileInfo.DateLastModified | `
                                        Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.Hash = $CurHashInfo.HashValue

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null

                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break
                            }
                        #endregion Hash Query

                        #region Hash Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)
                            'HashIncludeAll'
                            {
                                Get-BluGenieHashInfo -Path $($folder.Files).path -FormatView None -Algorithm $Algorithm | `
                                    Where-Object -FilterScript { $_.HashValue -match $pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurHashInfo = $_
                                    $CurFileInfo = $folder.Files | Where-Object -FilterScript { $_.Path -eq $CurHashInfo.Path }
                                    $CurGetItem = Get-Item -Path $CurHashInfo.Path -Force | Select-Object *
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $CurFileInfo.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $CurFileInfo.Name
                                    $CurObjFile.ShortPath = $CurFileInfo.ShortPath
                                    $CurObjFile.ShortName = $CurFileInfo.ShortName
                                    $CurObjFile.SizeInBytes = $CurFileInfo.Size
                                    $CurObjFile.Type = $($CurFileInfo.Type | Out-String).Trim()
                                    $CurObjFile.PSIsContainer = 'False'
                                    $CurObjFile.CreationTime = $($CurFileInfo.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($CurFileInfo.DateLastAccessed | `
                                        Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($CurFileInfo.DateLastModified | `
                                        Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.Hash = $CurHashInfo.HashValue
                                    $CurObjFile.Target = $CurGetItem.Target
                                    $CurObjFile.LinkType = $CurGetItem.LinkType
                                    $CurObjFile.Extension = $CurGetItem.Extension
                                    $CurObjFile.CreationTimeUtc = $($CurGetItem.CreationTimeUtc | Out-String).trim()
                                    $CurObjFile.LastAccessTimeUtc =  $($CurGetItem.LastAccessTimeUtc | Out-String).trim()
                                    $CurObjFile.LastWriteTimeUtc =  $($CurGetItem.LastWriteTimeUtc | Out-String).trim()
                                    $CurObjFile.Attributes = $CurGetItem.Attributes

                                    #region ADS Streams
                                        $CurADSData = Get-BluGenieFileADS -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue

                                        If
                                        (
                                            $($CurADSData.HasADS)
                                        )
                                        {
                                            $CurObjFile.ADS = $CurADSData.HasADS
                                            $CurObjFile.Streams += $CurADSData.ADSName
                                        }
                                    #endregion ADS Streams

                                    #region Process ShowStreamValue Information
                                        If
                                        (
                                            $CurObjFile.ADS
                                        )
                                        {
                                            $CurStreamData = $(Get-BluGenieFileStreams -Path $_.Path -ReturnObject -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurStreamData.Streams
                                            )
                                            {
                                                $CurObjFile.StreamContent += $CurStreamData.Streams
                                            }
                                        }
                                    #endregion Process ShowStreamValue Information

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null
                                    $CurADSData = $null
                                    $CurGetItem = $null
                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }
                                }

                                break

                            }
                        #endregion Hash Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)

                        #region ADS Query
                            'ADS'
                            {
                                $folder.Files | ForEach-Object `
                                -Process `
                                {
                                    #region ADS Streams
                                        Try
                                        {
                                            $CurADSData = Get-Item -Path $_.Path -force -Stream * -ErrorAction Stop | `
                                                Where-Object -FilterScript { $_.'Stream' -NotLike ':$DATA' } | `
                                                Select-Object -ExpandProperty Stream
                                        }
                                        Catch
                                        {
                                            $null = Get-BluGenieErrorAction -Clear
                                        }

                                        If
                                        (
                                            $CurADSData
                                        )
                                        {
                                            $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                            $CurObjFile.Path = $_.Path
                                            $CurObjFile.FullName = $_.Path
                                            $CurObjFile.Name = $_.Name
                                            $CurObjFile.ShortPath = $_.ShortPath
                                            $CurObjFile.ShortName = $_.ShortName
                                            $CurObjFile.SizeInBytes = $_.Size
                                            $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                            $CurObjFile.PSIsContainer = 'False'
                                            $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.ADS = 'True'

                                            $CurADSData | ForEach-Object `
                                            -Process `
                                            {
                                                $null = $CurObjFile.Streams += $_
                                            }

                                            #region Process Permission Information
                                                If
                                                (
                                                    $Permissions
                                                )
                                                {
                                                    $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                        -ErrorAction SilentlyContinue)

                                                    If
                                                    (
                                                        $CurPermData
                                                    )
                                                    {
                                                        $CurObjFile.Permissions = $CurPermData.Permissions
                                                        $CurObjFile.Owner = $CurPermData.Owner
                                                    }
                                                }
                                            #endregion Process Permission Information

                                            #region Process Signature Information
                                                If
                                                (
                                                    $Signature
                                                )
                                                {
                                                    Try
                                                    {
                                                        $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                        $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                        $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                        $CurObjFile.Signature_Description = $($CurSignature).Description
                                                        $CurObjFile.Signature_Date = $($CurSignature).Date
                                                        $CurObjFile.Signature_Company = $($CurSignature).Company
                                                        $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                        $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                                    }
                                                    Catch
                                                    {
                                                        #Nothing
                                                    }
                                                }
                                            #endregion Process Signature Information

                                            #region Managetype
                                                If
                                                (
                                                    $Remove
                                                )
                                                {
                                                    $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                        -ErrorAction SilentlyContinue)
                                                }
                                            #endregion Managetype

                                            If
                                            (
                                                $UseCache
                                            )
                                            {
                                                $CurObjFile | ForEach-Object `
                                                -Process `
                                                {
                                                    $CurItem = $_
                                                    '---' | Out-File -FilePath $CachePath -Append -Force
                                                    $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                                }
                                            }
                                            Else
                                            {
                                                $Script:ArrFilesandFolders += $CurObjFile
                                            }

                                            If
                                            (
                                                $UpdateDB
                                            )
                                            {
                                                $CurObjFile | ForEach-Object -Process `
                                                {
                                                    $curitem = $_
                                                    $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                                    $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                                    $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                                    $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                                    $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                                    $curitem = $null
                                                }

                                                If
                                                (
                                                    $ForceDBUpdate
                                                )
                                                {
                                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                                }
                                                Else
                                                {
                                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                                }
                                            }

                                            $CurObjFile = $null
                                            $CurADSData = $null
                                            If
                                            (
                                                $ClearGarbageCollecting
                                            )
                                            {
                                                $null = Clear-BlugenieMemory
                                            }

                                        }
                                    #endregion ADS Streams
                                }

                                break
                            }
                        #endregion ADS Query

                        #region ADS Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)
                            'ADSIncludeAll'
                            {
                                $folder.Files | ForEach-Object `
                                -Process `
                                {
                                    #region ADS Streams
                                        Try
                                        {
                                            $CurADSData = Get-Item -Path $_.Path -force -Stream * -ErrorAction Stop | `
                                            Where-Object -FilterScript { $_.'Stream' -NotLike ':$DATA' } | `
                                            Select-Object -ExpandProperty Stream
                                        }
                                        Catch
                                        {
                                            $null = Get-BluGenieErrorAction -Clear
                                        }

                                        If
                                        (
                                            $CurADSData
                                        )
                                        {
                                            $CurGetItem = Get-Item -Path $_.Path -Force | Select-Object *
                                            $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                            $CurObjFile.Path = $_.Path
                                            $CurObjFile.FullName = $_.Path
                                            $CurObjFile.Name = $_.Name
                                            $CurObjFile.ShortPath = $_.ShortPath
                                            $CurObjFile.ShortName = $_.ShortName
                                            $CurObjFile.SizeInBytes = $_.Size
                                            $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                            $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()
                                            $CurObjFile.Hash = $(Get-BluGenieHashInfo -Path $CurObjFile.Path -Algorithm $Algorithm `
                                                -ErrorAction SilentlyContinue)
                                            $CurObjFile.Target = $CurGetItem.Target
                                            $CurObjFile.LinkType = $CurGetItem.LinkType
                                            $CurObjFile.Extension = $CurGetItem.Extension
                                            $CurObjFile.CreationTimeUtc = $($CurGetItem.CreationTimeUtc | Out-String).trim()
                                            $CurObjFile.LastAccessTimeUtc =  $($CurGetItem.LastAccessTimeUtc | Out-String).trim()
                                            $CurObjFile.LastWriteTimeUtc =  $($CurGetItem.LastWriteTimeUtc | Out-String).trim()
                                            $CurObjFile.Attributes = $CurGetItem.Attributes
                                            $CurObjFile.ADS = 'True'

                                            $CurADSData | ForEach-Object `
                                            -Process `
                                            {
                                                $null = $CurObjFile.Streams += $_
                                            }

                                            #region Process ShowStreamValue Information
                                                If
                                                (
                                                    $CurObjFile.ADS
                                                )
                                                {
                                                    $CurStreamData = $(Get-BluGenieFileStreams -Path $_.Path -ReturnObject `
                                                        -ErrorAction SilentlyContinue)

                                                    If
                                                    (
                                                        $CurStreamData.Streams
                                                    )
                                                    {
                                                        $CurObjFile.StreamContent += $CurStreamData.Streams
                                                    }
                                                }
                                            #endregion Process ShowStreamValue Information

                                            #region Process Permission Information
                                                If
                                                (
                                                    $Permissions
                                                )
                                                {
                                                    $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                        -ErrorAction SilentlyContinue)

                                                    If
                                                    (
                                                        $CurPermData
                                                    )
                                                    {
                                                        $CurObjFile.Permissions = $CurPermData.Permissions
                                                        $CurObjFile.Owner = $CurPermData.Owner
                                                    }
                                                }
                                            #endregion Process Permission Information

                                            #region Process Signature Information
                                                If
                                                (
                                                    $Signature
                                                )
                                                {
                                                    Try
                                                    {
                                                        $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                        $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                        $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                        $CurObjFile.Signature_Description = $($CurSignature).Description
                                                        $CurObjFile.Signature_Date = $($CurSignature).Date
                                                        $CurObjFile.Signature_Company = $($CurSignature).Company
                                                        $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                        $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                                    }
                                                    Catch
                                                    {
                                                        #Nothing
                                                    }
                                                }
                                            #endregion Process Signature Information

                                            #region Managetype
                                                If
                                                (
                                                    $Remove
                                                )
                                                {
                                                    $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                        -ErrorAction SilentlyContinue)
                                                }
                                            #endregion Managetype

                                            If
                                            (
                                                $UseCache
                                            )
                                            {
                                                $CurObjFile | ForEach-Object `
                                                -Process `
                                                {
                                                    $CurItem = $_
                                                    '---' | Out-File -FilePath $CachePath -Append -Force
                                                    $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                                }
                                            }
                                            Else
                                            {
                                                $Script:ArrFilesandFolders += $CurObjFile
                                            }

                                            If
                                            (
                                                $UpdateDB
                                            )
                                            {
                                                $CurObjFile | ForEach-Object -Process `
                                                {
                                                    $curitem = $_
                                                    $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                                    $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                                    $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                                    $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                                    $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                                    $curitem = $null
                                                }

                                                If
                                                (
                                                    $ForceDBUpdate
                                                )
                                                {
                                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                                }
                                                Else
                                                {
                                                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                                }
                                            }

                                            $CurObjFile = $null
                                            $CurADSData = $null
                                            $CurGetItem = $null
                                            If
                                            (
                                                $ClearGarbageCollecting
                                            )
                                            {
                                                $null = Clear-BlugenieMemory
                                            }

                                        }
                                    #endregion ADS Streams
                                }

                                break
                            }
                        #endregion ADS Query (Include all Meta ADS, Streams, DateUTC, Attributes, Hash)

                        #region Name Query
                            Default
                            {
                                $folder.Files | Where-Object -FilterScript { $_.Name -match $Pattern } | ForEach-Object `
                                -Process `
                                {
                                    $CurObjFile = New-Object -TypeName psobject -Property $CurObjFileProp
                                    $CurObjFile.Path = $_.Path
                                    $CurObjFile.FullName = $_.Path
                                    $CurObjFile.Name = $_.Name
                                    $CurObjFile.ShortPath = $_.ShortPath
                                    $CurObjFile.ShortName = $_.ShortName
                                    $CurObjFile.SizeInBytes = $_.Size
                                    $CurObjFile.Type = $($_.Type | Out-String).Trim()
                                    $CurObjFile.PSIsContainer = 'False'
                                    $CurObjFile.CreationTime = $($_.DateCreated | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastAccessTime = $($_.DateLastAccessed | Out-String -ErrorAction SilentlyContinue).Trim()
                                    $CurObjFile.LastWriteTime = $($_.DateLastModified | Out-String -ErrorAction SilentlyContinue).Trim()

                                    #region Process Permission Information
                                        If
                                        (
                                            $Permissions
                                        )
                                        {
                                            $CurPermData = $(Get-BluGenieFilePermissions -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)

                                            If
                                            (
                                                $CurPermData
                                            )
                                            {
                                                $CurObjFile.Permissions = $CurPermData.Permissions
                                                $CurObjFile.Owner = $CurPermData.Owner
                                            }
                                        }
                                    #endregion Process Permission Information

                                    #region Process Signature Information
                                        If
                                        (
                                            $Signature
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BluGenieSignature -Path $_.Path -Algorithm $Algorithm)
                                                $CurObjFile.Signature_Comment = $($CurSignature).Comment
                                                $CurObjFile.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurObjFile.Signature_Description = $($CurSignature).Description
                                                $CurObjFile.Signature_Date = $($CurSignature).Date
                                                $CurObjFile.Signature_Company = $($CurSignature).Company
                                                $CurObjFile.Signature_Publisher = $($CurSignature).Publisher
                                                $CurObjFile.Signature_Verified = $($CurSignature).Verified
                                            }
                                            Catch
                                            {
                                                #Nothing
                                            }
                                        }
                                    #endregion Process Signature Information

                                    #region Managetype
                                        If
                                        (
                                            $Remove
                                        )
                                        {
                                            $CurObjFile.Removed += $(Remove-BluGenieFile -Path $_.Path -ReturnObject `
                                                -ErrorAction SilentlyContinue)
                                        }
                                    #endregion Managetype

                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        $CurObjFile | ForEach-Object `
                                        -Process `
                                        {
                                            $CurItem = $_
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                    }
                                    Else
                                    {
                                        $Script:ArrFilesandFolders += $CurObjFile
                                    }

                                    If
                                    (
                                        $UpdateDB
                                    )
                                    {
                                        $CurObjFile | ForEach-Object -Process `
                                        {
                                            $curitem = $_
                                            $curitem.Permissions = $($curitem.Permissions | ConvertTo-Json -compress)
                                            $curitem.Streams = $($curitem.Streams | ConvertTo-Json -compress)
                                            $curitem.Target = $($curitem.Target | ConvertTo-Json -compress)
                                            $curitem.StreamContent = $($curitem.StreamContent | ConvertTo-Json -compress)
                                            $curitem.Removed = $($curitem.Removed | ConvertTo-Json -compress)
                                            $curitem = $null
                                        }

                                        If
                                        (
                                            $ForceDBUpdate
                                        )
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurObjFile | `
                                            Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }

                                    $CurObjFile = $null

                                    If
                                    (
                                        $ClearGarbageCollecting
                                    )
                                    {
                                        $null = Clear-BlugenieMemory
                                    }

                                }
                            }
                        #endregion Name Query
                    }
                    #endregion Process FilterTyper Query

                    #region File Count
                        If
                        (
                            $folder.Files.Count -gt 1
                        )
                        {
                            $Script:IntFiles += $folder.Files.Count

                            If
                            (
                                $ShowProgress
                            )
                            {
                                $('{0} ' -f $($folder.Files.Count + $Script:IntFiles)) | Out-Host
                            }
                        }
                    #endregion File Count

                    #region Recurse
                        If
                        (
                            $Recurse
                        )
                        {
                            $folder.SubFolders | ForEach-Object `
                            -Process `
                            {
                                $Script:IntFolders += 1

                                If
                                (
                                    (Get-Item -path $_.Path -Force).Attributes.ToString().Contains('ReparsePoint') -eq $false
                                )
                                {
                                    Start-Recurse -Path $_.Path -Pattern $Pattern -Recurse
                                }
                            }
                        }
                    #endregion Recurse
                }
        #endregion Function Start-Recurse
    #endregion Load Internal Functions

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

    #region Main

    #region Build Directory Search
        $Error.Clear()
        $NewSearchPath = @()

        Switch
        (
            $SearchPath
        )
        {
            #region Temp Search Path Flag
                'Temp'
                {
                    $ProcessSearchPaths = @()
                    $ProcessSearchPaths += "$env:windir\Temp"
                    Get-ChildItem -Path "$env:SystemDrive\Users" -Force | Where-Object -FilterScript { $_.'Attributes' -eq 'Directory' } | `
					Select-Object -ExpandProperty Basename | ForEach-Object -Process { $ProcessSearchPaths += `
					$('{0}\Users\{1}\AppData\Local\Temp' -f $env:SystemDrive,$_) }

                    foreach
                    (
                        $CurSearchPath in $ProcessSearchPaths
                    )
                    {
                        If
                        (
                            $(Test-Path -Path $CurSearchPath -ErrorAction SilentlyContinue)
                        )
                        {
                            $NewSearchPath += $CurSearchPath
                        }
                    }
                }
            #endregion Temp Search Path Flag

            #region AllUsers Search Path Flag
                {$_ -match '^AllUsers'}
                {
                    $ProcessSearchPaths = Get-ChildItem -Path "$env:SystemDrive\Users" -Force | `
					Where-Object -FilterScript { $_.'Attributes'.ToString() -match 'Directory' } | Select-Object -Property @{
                        Name       = 'FullName'
                        Expression = {$('{0}{1}' -f $_.FullName, $($SearchPath -replace ('AllUsers','')))}
                    } | Select-Object -ExpandProperty FullName

                    foreach
                    (
                        $CurSearchPath in $ProcessSearchPaths
                    )
                    {
                        If
                        (
                            $(Test-Path -Path $CurSearchPath -ErrorAction SilentlyContinue)
                        )
                        {
                            $NewSearchPath += $CurSearchPath
                        }
                    }
                }
            #endregion AllUsers Search Path Flag

            #region Lazy Search Path Flag
                'Lazy'
                {
                    $NewSearchPath += $(Get-Item -Path Env:\Path).Value -split (';')
                }
            #endregion Lazy Search Path Flag

            #region No Change from the orginal requested path
                Default
                {
                    $NewSearchPath = $SearchPath
                }
            #endregion No Change from the orginal requested path
        }
    #endregion Build Directory Search

    #region Build and Process Query Request
        #region Build Command and Query
            If
            (
                $NewSearchPath
            )
            {
                $NewSearchPath | ForEach-Object `
                -Process `
                {
                    If
                    (
                        $Recurse
                    )
                    {
                        Start-Recurse -Path $_ -Recurse
                    }
                    Else
                    {
                        Start-Recurse -Path $_
                    }
                }
            }
        #endregion Build Command and Query
    #endregion Build and Process Query Request

    #region Update Hash Table Information
        If
        (
            $UseCache
        )
        {
            $HashReturn.ItemList.Items += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
            If
            (
                $RemoveCache
            )
            {
                $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
            }
        }
        Else
        {
            $HashReturn['ItemList']['Items'] += $Script:ArrFilesandFolders
        }

        $HashReturn['ItemList']['ParsedFiles'] += $Script:IntFiles
        $HashReturn['ItemList']['ParsedDirectories'] += $Script:IntFolders


        If
        (
            $HashReturn.ItemList.Items
        )
        {
            $HashReturn['ItemList']['FoundItems'] = $HashReturn.ItemList.items.count
        }

        #$Script:ArrFilesandFolders = $null
        #$Script:IntFiles = $null
        #$Script:IntFolders = $null
    #endregion Update Report Information

    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ItemList'].EndTime = $($EndTime).DateTime
        $HashReturn['ItemList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Clean Up
            If
            (
                $UseCache
            )
            {
                If
                (
                    $RemoveCache
                )
                {
                    If
                    (
                        -Not $($FormatView -eq 'Yaml')
                    )
                    {
                        $null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        #endregion Clean Up

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = $HashReturn.ItemList.Items

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
#endregion Get-BluGenieChildItemList (Function)