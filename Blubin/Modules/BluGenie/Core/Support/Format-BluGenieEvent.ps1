#region Format-BluGenieEvent (Function)
function Format-BluGenieEvent
{
<#
    .SYNOPSIS
        Format a Windows System Event Log with new properties from the Message field

    .DESCRIPTION
        Format a Windows System Event Log with new properties from the Message field

        An Event has a Message that is one big string.
        This function will parse that information and convert any valid line item into a new Object Property and
        bind it back to the original PsObject.

        You can parse any property table name via PowerShell, EQL, and SQL Queries

    .PARAMETER LogName
        Description: The Event Log Name
        Notes: Same to command (Get-WinEvent)
        Alias: Event
        ValidateSet:

    .PARAMETER ID
        Description: Query for a specific Event ID
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER AppendEventHash
        Description: Query based on more Event Filter Hash Table information
        Notes: The Default is LogName, and ID
                Example: -AppendEventHash 'ProviderName="Application Error"; Data="iexplore.exe"'
        Alias:
        ValidateSet:

    .PARAMETER Schema
        Description: Use a Schema file to change or remap any property name in any Windows Event your trying to Query
        Notes: Schema is in ( YAML ) Format
                Sample:
                    Property_Name: New_Property_Name
        Alias:
        ValidateSet:

    .PARAMETER ExcludeFilter
        Description: Use an ExcludeFilter Yaml file to remove items that you do not want to include in the Event Search.
        Notes: ExcludeFilter  is in ( YAML ) Format
                Sample:
                    - Name: Image
                      Value: notepad\+\+\.exe
                    - Name: Image
                      Value: NppLauncher\.exe
                    - Name: Image
                      Value: eqllib\.exe
                    - Name: CommandLine
                      Value: json
        Alias:
        Alias:
        ValidateSet:

    .PARAMETER NoMsgPrefix
        Description: By Default the Event Message content is parsed and all properties have a Prefix called (Msg).  This option will force the
normal propery names without (Msg).
        Notes:  By forcing the default name you could possibly overwrite normal event properties with content from the message information
        Alias:
        ValidateSet:

    .PARAMETER RemoveCache
        Description: Remove Cache data on completion
        Notes: Cache information is removed right before the data is returned to the calling process
            Items Removed:
                - JSON Output for EQL Query
                - SQLite DB if you do not use the -DBPath = ':MEMORY:' parameter.  Note: The DB in memory is the default option for SQL
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

    .PARAMETER OutJSON
        Description: Return detailed information in JSON Format
        Notes: Only supported in Posh 3.0 and above
        Alias:
        ValidateSet:

    .PARAMETER Export
        Description: Enable the Export of Filtered data for later use
        Notes:  This is automatically set to true if -EQLQuery is used.
        Alias: Sv
        ValidateSet:

    .PARAMETER ExportPath
        Description: The Path to Export / Save parsed event data to the local disk
        Notes: Default is $env:systemdrive\Windows\Temp\BGFE_<GUID>.json.  If this is changed (Make Sure) the Ext is (.json).  There is no code
validation on the path and filename.
        Alias:
        ValidateSet:

    .PARAMETER EQLQuery
        Description: Use EQL Queries to parse the data
        Notes: To use a file instead of a Query String Type "file:<Full_File_Path>" Example: "file:C:\Windows\Temp\Query_4689_.eql"
                file: tells the Query to grab the content from a file.  The file extention can be anything.  The file is always treated as TEXT.
        Alias:
        ValidateSet:

    .PARAMETER SQLQuery
        Description: Use SQL Queries to parse the data
        Notes: To use a file instead of a Query String Type "file:<Full_File_Path>" Example: "file:C:\Windows\Temp\Query_4689_.eql"
                file: tells the Query to grab the content from a file.  The file extention can be anything.  The file is always treated as TEXT.
        Alias:
        ValidateSet:

    .PARAMETER DBName
        Description: Database name used when parsing using SQL and Setting the DBPath to a local disk path
        Notes: The default name is "BluGenie"
        Alias:
        ValidateSet:

    .PARAMETER DBTableName
        Description: Database table name when parsing using SQL.
        Notes:  The default name is 'FormatBGEvent'
        Alias:
        ValidateSet:

    .PARAMETER DBPath
        Description: Database Path when parsing using SQL
        Notes: The default path is located in memory (:MEMORY:)
        Alias:
        ValidateSet:

    .PARAMETER PropsOnly
        Description: Used to only parse and display the Properties of an Event Message field.  No other event data will be captured.
        Notes: All Event messages properties begin with a title name followed by (:).
                Example (ProcessName: PowerShell_ISE.exe)
                (ProcessName) would be the name of the Property
                (PowerShell_ISE.exe) would be the assigned value
        Alias:
        ValidateSet:

    .PARAMETER ForceEQLGenericQuery
        Description: Force an EQL Generic Query even if EQL has a known Schema type
        Notes: By default BG will automatically determine if EQL has a known Schema. This should be used if you are looking for SysMon Events
that don't have tracked ID's by EQL.  Currently only ID 1, 3, 5, 7, 11, 12, 13, 14 and 15 are known SysMon EQL managed events.
        Alias: FEGQ
        ValidateSet:

    .PARAMETER UseInputFile
        Description: Force Query from a previously saved file and not the Windows Event Log
        Notes:  You can use JSON, EVT or EVTX files.  If you type in "Last:", this will search for the last saved
BGFE_<GUID>.json file from the default save location $env:systemdrive\Windows\Temp

                o JSON files cannot be filtered with the FilterHashTable.  They can only be filtered by EQL and SQL Queries.
                o EVT & EVTX backup log files can be filtered using the FilterHashTable Query String
        Alias: FIL
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
        Command: Get-WinEvent -filterhashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=10} -MaxEvents 1 | Select-Object -Property * | Convertto-Yaml
        Description: This command will show what a normal event will look like using the Get-WinEvent command
        Notes: We are pulling the SysMon Operational Event Data.  This will only work if you have SysMon Events being logged

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1 -ID 10 -OutYaml
        Description:  This command will return an Event with new properties named with a prefix (Msg) based on what is parsed from the (Message) field of the event
        Notes: The Properties property is also updated with the Names and Values of the Message field

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1 -ID 10 -Schema 'C:\Source\SysMon.Schema' -OutYaml
        Description: This command will return an Event with properties remapped based on the Schema file selected
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1 -ID 10 -NoMsgPrefix -OutYaml
        Description: This command will return an Event with the Message Properties appended to the Original Events Property Table without a (Msg) Prefix
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -MaxEvents 10 -ID 10 -PropsOnly -ReturnObject -FormatView JSON
        Description: This command will return an Events Message Properties and Values only.  All the Normal PowerShell Property Tables are removed
        Notes: The return is formated as JSON which looks identical to the output needed for EQL to work.

    .EXAMPLE
        Command: Format-BluGenieEvent -Event 'Microsoft-Windows-Windows Defender/Operational' -MaxEvents 10 -ID 1013 -ReturnObject -OutJSON -PropsOnly
        Description: This command will return Event Properties for Windows Defender ID 1013
        Notes: This shows that not all properties from the Event Message are valuable, which is why you would pull all properties for this Event ID.

    .EXAMPLE
        Command: Format-BluGenieEvent -Event 'Microsoft-Windows-Windows Defender/Operational' -ID 1000 -MaxEvents 1 -ReturnObject -NoMsgPrefix
        Description: This command will return all Event Properties for Windows Defender ID 1000 including the Message Properties
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 10 -MaxEvents 2 -PropsOnly -ExportPath C:\Source\SysMon_PoshPull.json -OutYaml
        Description: This command will export the Event Properties to a JSON file
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 1 -UseInputFile C:\Windows\Temp\BGSysMonEventBackup.evtx -ReturnObject -PropsOnly
        Description: This command will query a Windows Evnet Log backp file instead of the Widnows Event Log
        Notes: Currently this only supports 1 Input file at a time.  You can use an backup Windows Event in EVT, EVTX, and JSON format.

    .EXAMPLE
        Command: Format-BluGenieEvent -UseInputFile 'Last:' -PropsOnly -OutYaml -EQLQuery "process where process_name in ('wsl.exe')"
        Description: This command will query a Windows Event Log backup file using the last saved JSON file Format-BGEvent created.
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 1 -MaxEvents 1000 -PropsOnly -EQLQuery "process where process_name in ('powershell_ise.exe')" -OutYaml
        Description: This command will filter 1000 SysMon Event 1 ID's and parse the return using EQL and an EQLQuery as a string
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 1 -MaxEvents 1000 -PropsOnly -EQLQuery "file:C:\Source\EQLQuery_Parse_Process_Name_for_PowerShell_ise.exe.eql" -OutYaml
        Description: This command will filter 1000 SysMon Event 1 ID's and parse the return using EQL and an EQLQuery from a file
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 1 -MaxEvents 1000 -PropsOnly -EQLQuery "process where process_name in ('notepad++.exe')" -OutYaml -RemoveCache
        Description: This command will filter 1000 SysMon Event 1 ID's and parse the return using EQL.  The search is for Notepad++.exe and all Cached .JSON files for EQL will be removed.
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" ID 3 -MaxEvents 1000 -PropsOnly -EQLQuery "network where process_name == '*code.exe'"
        Description: This command will filter 1000 SysMon Event 3 ID's and parse the return using EQL.  The search is for VSCode.exe and uses EQL's built in schema names
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 3 -MaxEvents 1000 -PropsOnly -EQLQuery "generic where Image == '*code.exe'" -ForceEQLGenericQuery
        Description: This command will filter 1000 SysMon Event 3 ID's and parse the return using EQL.  This Query will use the EQL Generic process names
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Microsoft-Windows-Sysmon/Operational" -ID 3 -MaxEvents 1000 -PropsOnly -OutYaml -EQLQuery "generic where process_name == '*code.exe'" -ForceEQLGenericQuery -Schema .\Blubin\Modules\BluGenie\Configs\Schema\SysMon_ID3.Schema
        Description: This command will filter 1000 SysMon Event 3 ID's and parse the return using EQL.  This Query will use the EQL schema process names but uses the -Schema switch to remap the Properties names
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -OutYaml -DBPath C:\Source -SQLQuery "SELECT * FROM FormatBGEvent WHERE MsgNewProcessName LIKE '%GoogleUpdate.exe'"
        Description: This command will filter 1000 Security Event 4688 ID's and parse the return using SQL.  The search is for a New Process Name being created called GoogleUpdate.exe.  The SQL Query is (String Text Based) and the DB is Cached to Disk
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -OutYaml -DBPath C:\Source -SQLQuery 'file:C:\Source\WHERE_MsgNewProcessName_LIKE_GoogleUpdate.exe.sql'
        Description: This command will Run a SQL Query using a File
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -OutYaml -SQLQuery "SELECT * FROM FormatBGEvent WHERE MsgNewProcessName LIKE '%GoogleUpdate.exe'"
        Description: This command will Run a SQL Query and process the DB in Memory
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -OutYaml -PropsOnly -SQLQuery "SELECT * FROM FormatBGEvent WHERE NewProcessName LIKE '%GoogleUpdate.exe'"
        Description: This command will filter (Message Properties Only) and parse the data using a SQL Query
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -ReturnObject -PropsOnly -SQLQuery "SELECT * FROM FormatBGEvent WHERE NewProcessName LIKE '%GoogleUpdate.exe'"
        Description: This command will returned data as an Object(s) while parsing data using a SQL Query
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Event "Security" -ID 4688 -MaxEvents 1000 -OutYaml -DBPath C:\Source -SQLQuery "SELECT * FROM FormatBGEvent WHERE MsgNewProcessName LIKE '%GoogleUpdate.exe'"
        Description: This command will remove the Cached DB from the local disk after the Query
        Notes:

    .EXAMPLE
        Command: Format-BluGenieEvent -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Format-BluGenieEvent -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  19.03.2601 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o  Michael Arroyo
        • [Latest Build Version]
            o  21.07.2201
        • [Comments]
            o
        • [PowerShell Compatibility]
            o  2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
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
        o 19.03.2601: [Michael Arroyo] Posted
        o 21.05.2401: [Michael Arroyo] Updated Function Template
                    : [Michael Arroyo] Added EQL Query event parsing (The Python Engine is needed for this to work)
                    : [Michael Arroyo] Added SQL Query event parsing
                    : [Michael Arroyo] Schema / Property remapping to help build common Queries from company to company
        o 21.06.2901: [Michael Arroyo] Added ForceEQLGenericQuery switch to Force an EQL Generic Query even if EQL has a known Schema type
                    : [Michael Arroyo] Rebuilt Event Object using (ConvertTo-JSON | ConvertFrom-JSON)
                    : [Michael Arroyo] Updated the Schema mapping change to also work on -PropsOnly
                    : [Michael Arroyo] Updated the EQL json output to have a list view even if the Object has a single item.
                        By default a single item in the json Array would not stay a list.  But EQL needs a list format no matter what.
                    : [Michael Arroyo] Fixed the Parsed Count item.  It was coming back as null
                    : [Michael Arroyo] Added new Examples for the new EQL Query types
        o 21.07.2201: [Michael Arroyo] Added new Parameter UseInputFile - Force Query from a previously saved file and not the Windows Event Log
                                        The supported file formats are EVT, EVTX, and JSON
                    : [Michael Arroyo] Updated the ExportPath parameter to have the default path $env:systemdrive\Windows\Temp\BGFE_<GUID>.json
                    : [Michael Arroyo] Added new Parameter Export - Enable the Export of Filtered data for later use
                    : [Michael Arroyo] Updated the PropsOnly parameter to work with imported data as well as the Event Viewer Log Data
                    : [Michael Arroyo] Added new Parameter ExcludeFilter - Use an ExcludeFilter Yaml file to remove items that you do not want to
                                        include in the Event Search.
        o 21.08.0201: [Michael Arroyo] Renamed Parameter FilterHashTable to LogName
                    : [Michael Arroyo] Added a new Parameter called (ID) to handle the Event ID's instead of adding them to the LogName string
                    : [Michael Arroyo] Updated the Help information to the new Event, MaxEvent, and LogID parameter values
                    : [Michael Arroyo] Converted FilterHashTable for Get-WinEvent to use a Switch Statement
                    : [Michael Arroyo] Created a new Parameter called (AppendEventHash) - Query based on more Event Filter Hash Table information
                    : [Michael Arroyo] Parse each message field and auto correct Type information to rebuild [Int] types if captured as [String]
                    : [Michael Arroyo] Set the default location for an EQLQuery file.  The default lookup location is
                                        $BluGenieModulePath\BluGenie\Configs\EQLQueries\
                    : [Michael Arroyo] Set the default location for an SQLQuery file.  The default lookup location is
                                        $BluGenieModulePath\BluGenie\Configs\SQLQueries\
                    : [Michael Arroyo] Set the default location for an Exclude file.  The default lookup location is
                                        $BluGenieModulePath\BluGenie\Configs\Schema\

    #>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Format-BGEvent','BGEvent','Format-Event')]
    #region Parameters
        Param
        (
            [Alias('Event')]
            [string]$Logname,

            [string]$Schema,

            [switch]$NoMsgPrefix,

            [Switch]$ClearGarbageCollecting,

            [Switch]$Export,

            [String]$ExportPath = $('{0}\Windows\Temp\BGFE_{1}.json' -f $env:SystemDrive, $(New-BluGenieUID)),

            [String]$ExcludeFilter,

            [Switch]$RemoveCache,

            [String]$DBName = 'BluGenie',

            [String]$DBTableName = 'FormatBGEvent',

            [String]$DBPath = ':MEMORY:',

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [Switch]$OutYaml,

            [Switch]$OutJSON,

            [Switch]$PropsOnly,

            [String]$EQLQuery,

            [String]$SQLQuery,

            [Alias('FEGQ')]
            [Switch]$ForceEQLGenericQuery,

            [Alias('SV')]
            [Switch]$Save,

            [Alias('SP')]
            [String]$SavePath = $('BGFE_{0}\Windows\Temp\{1}.json' -f $env:SystemDrive, $(New-BluGenieUID)),

            [Alias('FIL')]
            [String]$UseInputFile,

            [Int]$MaxEvents,

            [Int]$ID,

            [String]$AppendEventHash,

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
        $HashReturn['FormatBGEvent'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['FormatBGEvent'].StartTime = $($StartTime).DateTime
        $HashReturn['FormatBGEvent'].ParameterSetResults = ''
        $HashReturn['FormatBGEvent']['Items'] = @()
        $HashReturn['FormatBGEvent']['CachePath'] = $CachePath
        $HashReturn['FormatBGEvent']['ExportPath'] = $ExportPath
        $HashReturn['FormatBGEvent']['EventsParsed'] = 0
        $HashReturn['FormatBGEvent']['EventsFound'] = 0
        $HashReturn['FormatBGEvent']['EQLSourceSchema'] = ''
        $HashReturn['FormatBGEvent']['SourceInput'] = "WindowsEventLog"
        $HashReturn['FormatBGEvent']['QueryString'] = ""
    #endregion Create Return hash

    #region Event Check
        $EQLSourceSchema = 'Microsoft Sysmon'
        $HashReturn['FormatBGEvent']['EQLSourceSchema'] =  $EQLSourceSchema
        If
        (
            $Logname -eq $null -and $(-Not $UseInputFile)
        )
        {
            Write-Error -Message $('-Logname, did not have a set value.  Logname uses the same Values from Get-WinEvent')
        }
        Else
        {
            #region Set EQLSchema
                If
                (
                    $EQLQuery -Match '^generic'
                )
                {
                    $EQLSourceSchema = 'Generic'
                }
                Else
                {
                    $EQLSourceSchema = 'Microsoft Sysmon'
                }

                $HashReturn['FormatBGEvent']['EQLSourceSchema'] =  $EQLSourceSchema
            #endregion Set EQLSchema

            #region Using Existing EventLog Data
                if
                (
                    $UseInputFile
                )
                {
                    If
                    (
                        $UseInputFile -eq "Last:"
                    )
                    {
                        $UseInputfile = Get-ChildItem -path $('{0}\Windows\Temp' -f $env:SystemDrive) -Filter BGFE_*.json | `
                            Sort-Object -Property LastWriteTime | Select-Object -First 1 -ExpandProperty Fullname
                        $RemoveCache = $true
                    }

                    If
                    (
                        Test-Path -Path $UseInputFile
                    )
                    {
                        Switch
                        (
                            $null
                        )
                        {
                            {$UseInputFile -match '\.evt$|\.evtx$'}
                            {
                                $HashReturn['FormatBGEvent']['SourceInput'] = "Windows Event Viewer Log File"

                                break
                            }

                            {$UseInputFile -match '\.json'}
                            {
                                $HashReturn['FormatBGEvent']['SourceInput'] = "JSON"
                                $RemoveCache = $true

                                break
                            }
                        }
                    }
                }
            #endregion Using Existing EventLog Data
        }
    #endregion Event Check

    #region Parameter Set Results
        $HashReturn['FormatBGEvent'].ParameterSetResults = $PSBoundParameters
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

            { $IsPosh2 }
            {
                $UpdateDB = $false
            }
        }
    #endregion Dynamic parameter update

    #region Main
        #region Filter Input
            If
            (
                $HashReturn['FormatBGEvent']['SourceInput'] -ne "JSON"
            )
            {
                #region Process Get-WinEvent Query
                    $Filterhashtable = '@{'

                    Switch
                    (
                        $null
                    )
                    {
                        {$UseInputFile}
                        {
                            $Filterhashtable += $('Path="{0}";LogName="{1}"' -f $UseInputFile, $Logname)
                        }

                        {$UseInputFile.Length -eq 0}
                        {
                            $Filterhashtable += $('LogName="{0}"' -f $Logname)
                        }

                        {$AppendEventHash}
                        {
                            $Filterhashtable += $(';{0}' -f $AppendEventHash)
                        }

                        {$ID}
                        {
                            $Filterhashtable += $(';ID={0}' -f $ID)
                        }
                    }

                    $Filterhashtable += '}'

                    If
                    (
                        $MaxEvents
                    )
                    {
                        $EventString = $('Get-WinEvent -Filterhashtable {0} -MaxEvents {1}' -f $FilterHashTable, $MaxEvents)
                    }
                    else
                    {
                        $EventString = $('Get-WinEvent -Filterhashtable {0}' -f $FilterHashTable)
                    }

                    $Events = Invoke-Expression -Command $($EventString)
                #endregion Process Get-WinEvent Query

                #region Setup for Query
                    $ArrEvents = @()
                    $HashReturn['FormatBGEvent']['EventsParsed'] = $Events.Count
                #endregion Setup for Query

                #region Parse Event
                    $Events | ForEach-Object `
                        -Process `
                        {
                            #region Parse Message Properties
                                $CurEvent = $_
                                $CurEventXml = [xml]$CurEvent.ToXML()
                                $CurEventKeys = $CurEventXml.Event.EventData.Data
                                $CurEventProps = New-Object psobject

                                $CurEventKeys | ForEach-Object `
                                    -Process `
                                    {
                                        $CurEventKey = $_
                                        $CurEventName = $($CurEventKey.Name -replace '\s')
                                        Try
                                        {
                                            [Int]$CurEventValue = $($CurEventKey.'#text')
                                        }
                                        Catch
                                        {
                                            $CurEventValue = $($CurEventKey.'#text')
                                        }

                                        $CurEventProps | Add-Member -MemberType NoteProperty -Name $CurEventName -Value $CurEventValue -Force -ErrorAction SilentlyContinue
                                        If
                                        (
                                            $NoMsgPrefix
                                        )
                                        {
                                            $CurEvent | Add-Member -MemberType NoteProperty -Name $CurEventName -Value $CurEventValue -Force -ErrorAction SilentlyContinue
                                        }
                                        Else
                                        {
                                            $CurEvent | Add-Member -MemberType NoteProperty -Name $('Msg{0}' -f $CurEventName) -Value $CurEventValue -Force -ErrorAction SilentlyContinue
                                        }
                                    }

                                $CurEventProps | Add-Member -MemberType NoteProperty -Name 'EventId' -Value $($CurEvent.Id) -Force -ErrorAction SilentlyContinue
                            #endregion Parse Message Properties

                            #region Update Event.Properties
                                $CurEvent = $CurEvent | Select-Object -Property * | ConvertTo-JSON | ConvertFrom-JSON
                                $CurEvent | Add-Member -MemberType NoteProperty -Name 'Properties' -Value $CurEventProps -Force
                            #endregion Update Event.Properties

                            #region Update/Remap Event Property Name Values
                                If
                                (
                                    $Schema -and $(Test-Path -Path $Schema)
                                )
                                {
                                    $CurSchema = Get-Content -Path $Schema -ErrorAction SilentlyContinue | ConvertFrom-Yaml -ErrorAction SilentlyContinue

                                    $CurSchema.Keys | ForEach-Object `
                                    -Process `
                                    {
                                        $CurSchemaProp = $_
                                        If
                                        (
                                            $($CurEvent.Psobject.Properties | Select-Object -ExpandProperty Name) -contains $CurSchemaProp
                                        )
                                        {
                                            If
                                            (
                                                $PropsOnly
                                            )
                                            {
                                                $CurEvent.Properties | Add-Member -MemberType NoteProperty -Name $CurSchema.$CurSchemaProp -Value $CurEvent.$($CurSchemaProp) -Force
                                                $CurEvent.Properties.Psobject.Properties.Remove("$CurSchemaProp")
                                            }
                                            Else
                                            {
                                                $CurEvent | Add-Member -MemberType NoteProperty -Name $CurSchema.$CurSchemaProp -Value $CurEvent.$($CurSchemaProp) -Force
                                                $CurEvent.Psobject.Properties.Remove("$CurSchemaProp")
                                            }
                                        }
                                    }
                                }
                            #endregion Update/Remap Event Property Name Values

                            #region Save Event Data
                                If
                                (
                                    $PropsOnly
                                )
                                {
                                    $ArrEvents += $CurEvent.Properties
                                }
                                Else
                                {
                                    $ArrEvents += $CurEvent | Select-Object -Property *
                                }
                            #endregion Save Event Data
                        }
                #endregion Parse Event

                #region CleanUp
                    $Events = $null
                    If
                    (
                        $ClearGarbageCollecting
                    )
                    {
                            $null = Clear-BlugenieMemory
                    }
                #endregion EndCleanUp
            }
            Else
            {
                If
                (
                    $PropsOnly
                )
                {
                    $ArrEventsJSON = $(Get-Content -Path $UseInputFile) | ConvertFrom-Json
                    $ArrEvents = $ArrEventsJSON.Properties
                }
                else
                {
                    $ArrEvents = Get-Content -Path $UseInputFile | ConvertFrom-Json
                }

                $HashReturn['FormatBGEvent']['EventsParsed'] = $ArrEvents.Count
            }
        #endregion Filter Input

        #region Process Filter WhiteList
            If
            (
                $ExcludeFilter
            )
            {
                $ExcludeFilterCheck = $False
                $ExcludeFilterPath = ''
                If
                (
                    Test-Path -Path $('{0}\BluGenie\Configs\Schema\{1}' -f $BluGenieModulePath, $ExcludeFilter)
                )
                {
                    $ExcludeFilterCheck = $true
                    $ExcludeFilterPath = $('{0}\BluGenie\Configs\Schema\{1}' -f $BluGenieModulePath, $ExcludeFilter)
                }
                elseIf
                (
                    Test-Path -Path $ExcludeFilter
                )
                {
                    $ExcludeFilterCheck = $true
                    $ExcludeFilterPath = $ExcludeFilter
                }

                If
                (
                    $ExcludeFilterCheck
                )
                {
                    $NewEvent = @()
                    $WhiteList = Get-Content -Path $ExcludeFilterPath | ConvertFrom-Yaml
                    $ArrEvents | ForEach-Object `
                        -Process `
                        {
                            $CurEventObj = $_
                            $CurFlag = 0
                            $WhiteList | ForEach-Object `
                                -Process `
                                {
                                    $CurFilterVal = $_.Value
                                    $CurFilterNam = $_.Name
                                    If
                                    (
                                        $CurEventObj.$CurFilterNam -match $CurFilterVal
                                    )
                                    {
                                        $CurFlag = 1
                                    }
                                }

                            If
                            (
                                $CurFlag -eq 0
                            )
                            {
                                $NewEvent += $CurEventObj
                            }
                        }
                }

                If
                (
                    $NewEvent
                )
                {
                    $ArrEvents = $NewEvent
                }
            }
        #endregion Process Filter WhiteList

        #region Bind Array Events to HashTable
            $HashReturn['FormatBGEvent']['Items'] += $ArrEvents
            $ArrEvents = $null
        #endregion Bind Array Events to HashTable

        #region Parse with EQL or SQL
            If
            (
                $EQLQuery -or $SQLQuery
            )
            {
                Switch
                (
                    $null
                )
                {
                    {$EQLQuery}
                    {
                        #region Set Python and EQL Paths
                            $EQLSourceFile = $ExportPath

                            If
                            (
                                $HashReturn['FormatBGEvent']['Items'].Count -eq 1
                            )
                            {
                                @"
[
$($HashReturn['FormatBGEvent']['Items'] | ConvertTo-Json)
]
"@ | Out-File -FilePath $EQLSourceFile -Encoding ascii -Force -ErrorAction SilentlyContinue
                            }
                            Else
                            {
                                $($HashReturn['FormatBGEvent']['Items'] | ConvertTo-Json) | Out-File -FilePath $EQLSourceFile -Encoding ascii -Force -ErrorAction SilentlyContinue
                            }

                            $BGPythonPath = Join-Path -Path $(Resolve-Path -Path $ToolsDirectory | Select-Object -ExpandProperty Path) -ChildPath 'BGPython'
                            $EQLPath = Join-Path -Path $BGPythonPath -ChildPath 'scripts'
                            $EQLCmdPath = Join-Path -Path $EQLPath -ChildPath 'eql.exe'
                            $EQLLIBCmdPath = Join-Path -Path $EQLPath -ChildPath 'eqllib.exe'
                        #endregion Set Python and EQL Paths

                        #region Env Path Check for Python
                            If
                            (
                                -Not $($env:Path | Select-String -SimpleMatch $BGPythonPath)
                            )
                            {
                                $PythonPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | Select-String -Pattern home) -replace '^home = '
                                $env:Path = $('{0};{1}' -f $PythonPath, $env:Path)
                            }
                        #endregion Env Path Check for Python

                        #region Determine EQL Query String
                            If
                            (
                                $EQLQuery -match '^file:'
                            )
                            {
                                $EQLQueryfile = $EQLQuery -replace '^file:'

                                If
                                (
                                    Test-Path -Path $('{0}\BluGenie\Configs\EQLQueries\{1}' -f $BluGenieModulePath, $EQLQueryfile)
                                )
                                {
                                    $EQLQuery = Get-Content -Path $('{0}\BluGenie\Configs\EQLQueries\{1}' -f $BluGenieModulePath, $EQLQueryfile)
                                }
                                Elseif
                                (
                                    Test-Path -Path $EQLQueryfile
                                )
                                {
                                    $EQLQuery = Get-Content -Path $EQLQueryfile
                                }
                            }
                        #endregion Determine EQL Query String

                        #region Process Query
                            If
                            (
                                $($EQLSourceSchema -eq 'Microsoft Sysmon') -and $(-Not $ForceEQLGenericQuery)
                            )
                            {
                                $HashReturn['FormatBGEvent']['Items'] = @()
                                $EQLReturn = & "$EQLLIBCmdPath" query -f "$EQLSourceFile" --source "$EQLSourceSchema" "$EQLQuery"
                                $HashReturn['FormatBGEvent']['Items'] += $EQLReturn | ConvertFrom-Json
                            }
                            Else
                            {
                                $HashReturn['FormatBGEvent']['Items'] = @()
                                $EQLReturn = & "$EQLCmdPath" query -f "$EQLSourceFile" "$EQLQuery"
                                $HashReturn['FormatBGEvent']['Items'] += $EQLReturn | ConvertFrom-Json
                            }
                        #endregion Process Query

                        #region Remove EQL Event Source Data
                            If
                            (
                                $(Test-Path -Path $EQLSourceFile) -and $RemoveCache
                            )
                            {
                                Remove-Item -Path $EQLSourceFile -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Remove EQL Event Source Data

                        break
                    }
                    {$SQLQuery}
                    {
                        #region Create Hash Table
                            $HSqlite = @{}
                        #endregion Create Hash Table

                        #region Set Database Full Path
                            $HSqlite.DBPath = $DBPath
                            $HSqlite.DBName = $DBName
                            If
                            (
                                $DBPath -eq ':MEMORY:'
                            )
                            {
                                $HSqlite.Database = ':MEMORY:'
                            }
                            Else
                            {
                                $HSqlite.Database = Join-Path -Path $($HSqlite.DBPath) -ChildPath $('{0}.SQLite' -f $($HSqlite.DBName))
                            }
                        #endregion Set Database Full Path

                        #region Table Name
                            $HSqlite.TableName = $DBTableName
                        #endregion Table Name

                        #region Set Column Information
                            #***Sample Column Names (Please Change)***
                            [String]$HSqlite.TableColumns = ''
                            $CurDBProps = $($HashReturn.FormatBGEvent.Items[0].psobject.Properties | `
                                Where-Object -FilterScript { $_.MemberType -match 'property' } | `
                                Select-Object -ExpandProperty Name) -replace '$',' TEXT,'
                            $CurDBPropsLast =  $($CurDBProps | Select-Object -Last 1) -replace 'TEXT,$','TEXT'
                            $CurDBProps = $CurDBProps -replace "$($CurDBProps | Select-Object -Last 1)","$CurDBPropsLast"
                            $CurDBProps | ForEach-Object `
                                -Process `
                                {
                                    $CurDBProp = $_
                                    $HSqlite.TableColumns += $("{0}`n" -f $CurDBProp)
                                }
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
                                -Not $(Test-Path -Path $DBPath) -and $($DBPath -ne ':MEMORY:')
                            )
                            {
                                $null = New-Item -Path  $DBPath -ItemType Directory -Force
                            }

                            #region New DB Table
                                If
                                (
                                    $DBPath -eq ':MEMORY:'
                                )
                                {
                                    $Connection = New-SQLiteConnection -DataSource :MEMORY:
                                    Invoke-SqliteQuery -SQLiteConnection $Connection -Query $HSqlite.DropTableStr
                                    Invoke-SqliteQuery -SQLiteConnection $Connection -Query $HSqlite.CreateTableStr
                                }
                                Else
                                {
                                    Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.DropTableStr
                                    Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.CreateTableStr
                                }
                            #endregion New DB Table
                        #endregion Create DB Table

                        #region Import Data into DB
                            If
                            (
                                $DBPath -eq ':MEMORY:'
                            )
                            {
                                Invoke-SQLiteBulkCopy -SQLiteConnection $Connection -DataTable $($($HashReturn['FormatBGEvent']['Items']) | `
                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                            }
                            Else
                            {
                                Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($($HashReturn['FormatBGEvent']['Items']) | `
                                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                            }
                        #endregion Import Data into DB

                        #region Parse SQL Data using the SQL Query
                            If
                            (
                                $SQLQuery -match '^file:'
                            )
                            {
                                $SQLQueryfile = $SQLQuery -replace '^file:'

                                If
                                (
                                    Test-Path -Path $('{0}\BluGenie\Configs\SQLQueries\{1}' -f $BluGenieModulePath, $SQLQueryfile)
                                )
                                {
                                    $SQLQuery = Get-Content -Path $('{0}\BluGenie\Configs\SQLQueries\{1}' -f $BluGenieModulePath, $SQLQueryfile)
                                }
                                ElseIf
                                (
                                    Test-Path -Path $SQLQueryfile
                                )
                                {
                                    $SQLQuery = Get-Content -Path $SQLQueryfile
                                }
                            }

                            $HashReturn['FormatBGEvent']['Items'] = @()
                            If
                            (
                                $DBPath -eq ':MEMORY:'
                            )
                            {
                                $SQLQueryReturn = Invoke-SqliteQuery -SQLiteConnection $Connection -Query "$SQLQuery"
                            }
                            Else
                            {
                                $SQLQueryReturn = Invoke-SqliteQuery -DataSource $HSqlite.Database -Query "$SQLQuery"
                            }
                            $HashReturn['FormatBGEvent']['Items'] = $SQLQueryReturn
                        #endregion Parse SQL Data using the SQL Query

                        #region Clean Up DB
                            If
                            (
                                $RemoveCache -and $($DBPath -ne ':MEMORY:') -and $(Test-Path -Path $HSqlite.Database)
                            )
                            {
                                Remove-Item -Path $HSqlite.Database -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Clean Up DB

                        break
                    }
                }
            }
        #endregion Parse with EQL or SQL

        #region Export Parsed Data to JSON
            If
            (
                $ExportPath -and $Export -and $(Test-Path -Path $(Split-Path -Path $ExportPath -Parent)) -and $(-Not $EQLQuery)
            )
            {
                $($HashReturn['FormatBGEvent']['Items'] | ConvertTo-Json) | Out-File -FilePath $ExportPath -Encoding ascii -Force -ErrorAction SilentlyContinue
            }
        #endregion Export Parsed Data to JSON
    #endregion Main

    #region Output
        $HashReturn['FormatBGEvent']['EventsFound'] = $HashReturn['FormatBGEvent']['Items'].Count
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['FormatBGEvent'].EndTime = $($EndTime).DateTime
        $HashReturn['FormatBGEvent'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['FormatBGEvent'].Remove('StartTime')
            $null = $HashReturn['FormatBGEvent'].Remove('ParameterSetResults')
            $null = $HashReturn['FormatBGEvent'].Remove('CachePath')
            $null = $HashReturn['FormatBGEvent'].Remove('EndTime')
            $null = $HashReturn['FormatBGEvent'].Remove('ElapsedTime')
            $null = $HashReturn['FormatBGEvent'].Remove('ExportPath')
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = $($HashReturn['FormatBGEvent']['Items'])

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

                #region Yaml Output of Hash Information
                    { $OutJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 5)
                    }
                #endregion JSON Output of Hash Information

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
#endregion Format-BluGenieEvent (Function)