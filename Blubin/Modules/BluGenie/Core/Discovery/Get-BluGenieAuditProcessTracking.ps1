#region Get-BluGenieAuditProcessTracking (Function)
    function Get-BluGenieAuditProcessTracking
    {
        <#
        .SYNOPSIS
            Format a System Event Log with new properties from the Message field

        .DESCRIPTION
            Format a System Event Log with new properties from the Message field

            An Event has a Message that is one big string.
            The function will parse that information and convert any valid line item into a new Object Property and
            bind it back to the original Object.

        .PARAMETER Algorithm
            Description: Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
            Notes: The acceptable values for this parameter are:
                    - SHA1
                    - SHA256
                    - SHA384
                    - SHA512
                    - MACTripleDES
                    - MD5 = (Default)
                    - RIPEMD160

                    If no value is specified, or if the parameter is omitted, the default value is (MD5).
            Alias:
            ValidateSet:'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'

        .PARAMETER QueryType
            Description: Specifies the type of Events to Query for
            Notes: The acceptable values for this parameter are:
                    - OnCreated          : Query On Created Events Only
                    - OnExited           : Query On Exited Events Only
                    - OnAll = (Default)  : Query On All Event types (Created and Exited)

                    If no value is specified, or if the parameter is omitted, the default value is (OnAll).
            Alias:
            ValidateSet:'OnCreated','OnExited','OnAll'

        .PARAMETER OnDisk
            Description: Verify if the flagged process is still on disk
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Signature
            Description: Validate Signature information of the process if the item is still on disk.
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
            Command: Get-BluGenieAuditProcessTracking
            Description: This will return a Hash Table with a specific list of captured event Properties
            Notes:

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -ShowAllValues
            Description: This will return a Hash Table with all captured event Properties
            Notes:

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -ReturnObject
            Description: This will return a Object with a specific list of captured event Properties
            Notes:

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -QueryType OnCreated -Signature
            Description: This will return a Hash Table with a specific list of captured event Properties including the Authentication Information
            Notes:

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -UseCache
            Description: Cache found objects to disk to not over tax Memory resources
            Notes: By default the Cache location is %SystemDrive%\Windows\Temp

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -UseCache -RemoveCache
            Description: Remove Cache data
            Notes: By default the Cache information is removed right before the data is returned to the caller

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -UseCache -CachePath $Env:Temp
            Description: Change the Cache path to the current users Temp directory
            Notes: By default the Cache location is %SystemDrive%\Windows\Temp

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -UseCache -ClearGarbageCollecting
            Description: Scan large directories and limit the memory used to track data
            Notes:

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -WalkThrough
            Description: Call Help Information [2]
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -OutUnEscapedJSON
            Description: Return a detailed function report in an UnEscaped JSON format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -OutYaml
            Description: Return a detailed function report in YAML format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -ReturnObject
            Description: Return Output as a Object
            Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                    This parameter is also used with the FormatView

        .EXAMPLE
            Command: Get-BluGenieAuditProcessTracking -ReturnObject -FormatView Yaml
            Description: Output PSObject information in Yaml format
            Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                    Default is set to (None) and normal PSObject.

        .OUTPUTS
            TypeName: System.Collections.Hashtable

        .NOTES

            • [Original Author]
                o  Michael Arroyo
            • [Original Build Version]
                o  19.03.2701 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
            • [Latest Author]
                o Michael Arroyo
            • [Latest Build Version]
                o  21.02.2501
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
            o 19.03.2701• [Michael Arroyo] Posted
            o 21.02.2501• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                        • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                        • [Michael Arroyo] Updated the function to the new function template
                        • [Michael Arroyo] Added more detailed information to the Return data
                        • [Michael Arroyo] Updated the Code to the '145' column width standard
                        • [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                        • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                        • [Michael Arroyo] Added support for Caching
                        • [Michael Arroyo] Added support for Clearing Garbage collecting
                        • [Michael Arroyo] Added support for SQLite DB
                        • [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
                        • [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                            unless you manually set the -Verbose parameter.
                        • [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
            ~ 21.03.0201• [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                        • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                        • [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
        #>
        #endregion Build Notes
        [cmdletbinding()]
        [Alias('Get-AuditProcessTracking','Get-BGAuditProcessTracking')]
        #region Parameters
        Param
        (
            [ValidateSet('OnCreated','OnExited','OnAll')]
            [String]$QueryType = 'OnAll',

            [ValidateSet('MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512')]
            [string]$Algorithm = 'MD5',

            [Switch]$Signature,

            [Switch]$OnDisk,

            [Switch]$ShowAllValues,

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
            $HashReturn['AuditProcessTracking'] = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['AuditProcessTracking'].StartTime = $($StartTime).DateTime
            $HashReturn['AuditProcessTracking'].ParameterSetResults = @()
            $HashReturn['AuditProcessTracking']['Items'] = @()
            $HashReturn['AuditProcessTracking']['CachePath'] = $CachePath
            $HashReturn['AuditProcessTracking'].AuditPolicyInfo = @()
            $HashReturn['AuditProcessTracking'].Count = 0
        #endregion Create Return hash

        #region Parameter Set Results
            $HashReturn['AuditProcessTracking'].ParameterSetResults += $PSBoundParameters
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
                    $OutYaml = $false
                    $FormatView = 'None'
                }

                {$FormatView -eq 'Yaml'}
                {
                    $UseCache = $true
                }

                { -Not $($ClearGarbageCollecting -eq $false)}
                {
                    $ClearGarbageCollecting = $true
                }

                { $Signature }
                {
                    $OnDisk = $true
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
                    $HSqlite.TableName = 'BGAuditProcessTracking'
                #endregion Table Name

                #region Set Column Information
                    #***Sample Column Names (Please Change)***
                    $HSqlite.TableColumns = 'MsgProcessName TEXT,
                        MsgProcessID TEXT,
                        TaskDisplayName TEXT,
                        TimeCreated TEXT,
                        Ondisk TEXT,
                        MsgAccountName TEXT,
                        MsgAccountDomain TEXT,
                        Message TEXT,
                        MsgSecurityID TEXT,
                        MsgLogonID TEXT,
                        MsgNewProcessName TEXT,
                        MsgExitStatus TEXT,
                        Id INTEGER,
                        LogName TEXT,
                        ProcessId INTEGER,
                        ThreadId INTEGER,
                        MachineName TEXT,
                        UserId TEXT,
                        ContainerLog TEXT,
                        LevelDisplayName TEXT,
                        KeywordsDisplayNames TEXT,
                        LastModified TEXT,
                        CreatedOn TEXT,
                        FileSize TEXT,
                        FileVersion TEXT,
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
            #region Query Auditpol information
                $HashReturn.AuditProcessTracking.AuditPolicyInfo += $($(Invoke-Expression `
                    -Command $('{0}\System32\Auditpol.exe /get /category:"Detailed Tracking"' -f $env:windir) | `
                    Select-String -Pattern '^.*Process\s.\w*') -replace '\W\W*.\W',',') | ConvertFrom-Csv -Delimiter ',' -Header 'AuditType','Setting'
            #endregion Query Auditpol information

            #region Query Event Log for associated IDs to (A new process has been created) and (A process has exited)
                $Error.Clear()
                Switch
                (
                    $QueryType
                )
                {
                    'OnCreated' #ID [4688]
                    {
                        $EventData = Get-WinEvent -FilterHashtable @{
                            logname='Security'
                            id=4688
                        } -ErrorAction SilentlyContinue
                    }
                    'OnExited' #ID [4689]
                    {
                        $EventData = Get-WinEvent -FilterHashtable @{
                            logname='Security'
                            id=4689
                        } -ErrorAction SilentlyContinue
                    }
                    'OnAll' #ID [4688,4689]
                    {
                        $EventData = Get-WinEvent -FilterHashtable @{
                            logname='Security'
                            id=4688,4689
                        } -ErrorAction SilentlyContinue
                    }
                }
            #endregion Query Event Log for associated IDs to (A new process has been created) and (A process has exited)

            #region EventDataResults Results
                If
                (
                    $EventData
                )
                {
                    $HashReturn['AuditProcessTracking'].Count = $EventData.Count
                }
            #endregion EventDataResults Results

            #region Format current data
                $ArrTempData = @()

                $EventData | ForEach-Object `
                -Process `
                {
                    #region Define Properties for Current Event
                        $CurEventItem = $_
                        $CurEventItem = Format-BGEvent -Event $CurEventItem | Select-Object -Property Message,
                            MsgSecurityID,
                            MsgAccountName,
                            MsgAccountDomain,
                            MsgLogonID,
                            MsgProcessID,
                            MsgProcessName,
                            MsgNewProcessName,
                            MsgExitStatus,
                            Id,
                            LogName,
                            ProcessId,
                            ThreadId,
                            MachineName,
                            UserId,
                            TimeCreated,
                            ContainerLog,
                            LevelDisplayName,
                            TaskDisplayName,
                            KeywordsDisplayNames,
                            @{
                                Name = 'Ondisk'
                                Expression = {$($false | out-string).trim()}
                            },
                            @{
                                Name = 'LastModified'
                                Expression = {''}
                            },
                            @{
                                Name = 'CreatedOn'
                                Expression = {''}
                            },
                            @{
                                Name = 'FileSize'
                                Expression = {''}
                            },
                            @{
                                Name = 'FileVersion'
                                Expression = {''}
                            },
                            @{
                                Name = 'Hash'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Comment'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_FileVersion'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Description'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Date'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Company'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Publisher'
                                Expression = {''}
                            },
                            @{
                                Name = 'Signature_Verified'
                                Expression = {$($false | out-string).trim()}
                            }
                    #endregion Define Properties for Current Event

                    #region Format Time to String
                        $CurEventItem.TimeCreated = $($CurEventItem.TimeCreated.ToString() | Out-String)
                    #endregion Format Time to String

                    #region Format Message as String
                        $CurEventItem.Message = $($CurEventItem.Message.ToString() -replace '\t','' -replace '\s\s',' ')
                    #endregion Format Message as String

                    #region Format Array Entries for DB
                        If
                        (
                            $($IsPosh2 -eq $false) -and $UpdateDB
                        )
                        {
                            $CurEventItem.KeywordsDisplayNames = $($CurEventItem.KeywordsDisplayNames | ConvertTo-Json -Compress)
                            $CurEventItem.Signature_Comment = $($CurEventItem.Signature_Comment | ConvertTo-Json -Compress)
                        }
                    #endregion Format Array Entries for DB

                    #region Set MsgProcessName value based on All Events.
                        #Note:  This value does exist with a New Created Process
                        If
                        (
                            $CurEventItem.MsgNewProcessName
                        )
                        {
                            $CurEventItem.MsgProcessName = $CurEventItem.MsgNewProcessName
                        }
                    #endregion Set MsgProcessName value based on All Events.

                    #region Check OnDisk and Signature Information
                        If
                        (
                            $OnDisk
                        )
                        {
                            $FileOnDisk = Get-Item -Path $($CurEventItem.MsgProcessName) -Force -ErrorAction SilentlyContinue
                            #region File Check
                                If
                                (
                                    $FileOnDisk
                                )
                                {
                                    $CurEventItem.OnDisk  = $($true | out-string).trim()
                                    $CurEventItem.LastModified = $($FileOnDisk.LastWriteTime.ToString() | Out-String).Trim()
                                    $CurEventItem.CreatedOn = $($FileOnDisk.CreationTime.ToString() | Out-String).Trim()
                                    $CurEventItem.FileSize = $FileOnDisk.Length
                                    $CurEventItem.FileVersion = $FileOnDisk.VersionInfo.FileVersion
                                    $CurEventItem.Hash = $(Get-BGHashInfo -Path $($FileOnDisk.FullName) -Algorithm $Algorithm `
                                        -ErrorAction SilentlyContinue)
                                }
                            #endregion File Check

                            #region Signature Check
                                If
                                (
                                    $Signature
                                )
                                {
                                    If
                                    (
                                        $CurEventItem.OnDisk
                                    )
                                    {
                                        Try
                                        {
                                            $CurSignature = $(Get-BGSignature -Path $CurEventItem.MsgProcessName -Algorithm $Algorithm `
                                                -ErrorAction Stop)
                                        }
                                        Catch
                                        {
                                                #Nothing
                                        }

                                        $CurEventItem.Signature_Comment = $($CurSignature).Comment
                                        $CurEventItem.Signature_FileVersion = $($CurSignature).'File Version'
                                        $CurEventItem.Signature_Description = $($CurSignature).Description
                                        $CurEventItem.Signature_Date = $($CurSignature).Date
                                        $CurEventItem.Signature_Company = $($CurSignature).Company
                                        $CurEventItem.Signature_Publisher = $($CurSignature).Publisher

                                        If
                                        (
                                            $($CurSignature).Verified
                                        )
                                        {
                                            $CurEventItem.Signature_Verified = $($CurSignature).Verified
                                        }
                                    }
                                }
                            #endregion Signature Check
                        }
                    #endregion Check OnDisk and Signature Information

                    #region Cache or Save to Memory
                        If
                        (
                            $UseCache
                        )
                        {
                            '---' | Out-File -FilePath $CachePath -Append -Force
                            $CurEventItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                        }
                        Else
                        {
                            $ArrTempData += $CurEventItem
                        }
                    #endregion Cache or Save to Memory
                }
            #endregion Format current data

            #region Remove Garbage Collection
                $EventData = $Null
                $CurEventItem = $Null

                If
                (
                    $ClearGarbageCollecting
                )
                {
                        $null = Clear-BlugenieMemory
                }
            #endregion Remove Garbage Collection

            #region Item Information
                If
                (
                    $ArrTempData
                )
                {
                    $HashReturn['AuditProcessTracking']['Items'] += $ArrTempData
                    $ArrTempData = $null
                }
                ElseIf
                (
                    $UseCache
                )
                {
                    $HashReturn['AuditProcessTracking']['Items'] += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
                    If
                    (
                        $RemoveCache
                    )
                    {
                        $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
                    }
                }
            #endregion Item Information

            #region Update DB
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
                        Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($HashReturn['AuditProcessTracking']['Items'] | `
                        Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Replace
                    }
                    Else
                    {
                        Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($HashReturn['AuditProcessTracking']['Items'] | `
                        Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                    }
                }
            #endregion Update DB
        #endregion Main

        #region Output
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['AuditProcessTracking'].EndTime = $($EndTime).DateTime
            $HashReturn['AuditProcessTracking'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
                Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

            If
            (
                -Not $($VerbosePreference -eq 'Continue')
            )
            {
                #Remove Hash Properties that are not needed without Verbose enabled.
                $null = $HashReturn['AuditProcessTracking'].Remove('StartTime')
                $null = $HashReturn['AuditProcessTracking'].Remove('ParameterSetResults')
                $null = $HashReturn['AuditProcessTracking'].Remove('CachePath')
                $null = $HashReturn['AuditProcessTracking'].Remove('EndTime')
                $null = $HashReturn['AuditProcessTracking'].Remove('ElapsedTime')
                $null = $HashReturn['AuditProcessTracking'].Remove('AuditPolicyInfo')
            }

            #region Output Type
                $ResultSet = $HashReturn['AuditProcessTracking']['Items']

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
#endregion Get-BluGenieAuditProcessTracking (Function)