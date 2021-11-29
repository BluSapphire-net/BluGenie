#region Get-BluGenieRegistryProcessTracking (Function)
    function Get-BluGenieRegistryProcessTracking
    {
    <#
        .SYNOPSIS
            Query User Registry Hives for Process Tracking Information

        .DESCRIPTION
            Query User Registry Hives for Process Tracking Information

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
            Get-BluGenieRegistryProcessTracking

            This will report on any executed processes that is ran and tracked in the registry for all loaded user registry hives
            The returned data will be a Hash Table

            The default file Hash value is MD5

        .EXAMPLE
            Get-BluGenieRegistryProcessTracking -Algorithm SHA512

            This will report on any executed processes that is ran and tracked in the registry for all loaded user registry hives
            The returned data will be a Hash Table

            The file Hash value is SHA512

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -UseCache
            Description: Cache found objects to disk to not over tax Memory resources
            Notes: By default the Cache location is %SystemDrive%\Windows\Temp

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -UseCache -RemoveCache
            Description: Remove Cache data
            Notes: By default the Cache information is removed right before the data is returned to the caller

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -UseCache -CachePath $Env:Temp
            Description: Change the Cache path to the current users Temp directory
            Notes: By default the Cache location is %SystemDrive%\Windows\Temp

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -UseCache -ClearGarbageCollecting
            Description: Scan large directories and limit the memory used to track data
            Notes:

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -WalkThrough
            Description: Call Help Information [2]
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                    Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -OutUnEscapedJSON
            Description: Return a detailed function report in an UnEscaped JSON format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -OutYaml
            Description: Return a detailed function report in YAML format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -ReturnObject
            Description: Return Output as a Object
            Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                    This parameter is also used with the FormatView

        .EXAMPLE
            Command: Get-BluGenieRegistryProcessTracking -ReturnObject -FormatView Yaml
            Description: Output PSObject information in Yaml format
            Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                    Default is set to (None) and normal PSObject.

        .OUTPUTS
            TypeName: System.Collections.Hashtable

        .NOTES

            • [Original Author]
                o  Michael Arroyo
            • [Original Build Version]
                o  1903.1401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
            • [Latest Author]
                o Michael Arroyo
            • [Latest Build Version]
                o  21.02.2601
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
            o 1903.1401:• [Michael Arroyo] Posted
            o 1903.2201:• [Michael Arroyo] Added the Prefect Scan to determine last execution time.
                                            Note:  This is a partial scan as it only checks the Prefetch file names.
                        • [Michael Arroyo] Added User Hive Profile data
            o 1903.2401:• [Michael Arroyo] Added Error Msg around the Registry Queries for easier manageability
            o 1903.2501:• [Michael Arroyo] Updated Error Msg return
            o 1903.2601:• [Michael Arroyo] Updated the Get-HashInfo parameters.  It was not updating the Algorithm.
            o 21.02.2601• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                        • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                        • [Michael Arroyo] Updated the function to the new function tempatle
                        • [Michael Arroyo] Added more detailed information to the Return data
                        • [Michael Arroyo] Updated the Code to the '145' column width standard
                        • [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                        • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                        • [Michael Arroyo] Added support for Caching
                        • [Michael Arroyo] Added support for Clearing Garbage collecting
                        • [Michael Arroyo] Added supoort for SQLite DB
                        • [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
                        • [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                            unless you manually set the -Verbose parameter.
                        • [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                        • [Michael Arroyo] Updated the PrefetchService name now called (SysMain) on Windows 10 Build 1809 and later.
                        • [Michael Arroyo] Updated the registry call to grab (EnablePrefetcher) on some newer Windows Builds to detminer the
                                            Prefect statues
                        • [Michael Arroyo] Rebuilt Object reference to support Caching and DB injection
        #>
    #endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-RegistryProcessTracking','Get-BGRegistryProcessTracking')]
    #region Parameters
        Param
        (
            [ValidateSet('MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512')]
            [string]$Algorithm = 'MD5',

            [Switch]$Signature,

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
            $HashReturn['RegistryProcessTracking'] = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['RegistryProcessTracking'].StartTime = $($StartTime).DateTime
            $HashReturn['RegistryProcessTracking'].ParameterSetResults = ''
            $HashReturn['RegistryProcessTracking']['Items'] = @()
            $HashReturn['RegistryProcessTracking']['CachePath'] = $CachePath
            $HashReturn['RegistryProcessTracking'].PrefetchSetting = ''
            $HashReturn['RegistryProcessTracking'].PrefetchService = ''
            $HashReturn['RegistryProcessTracking'].Count = 0
            $HashReturn['RegistryProcessTracking'].AllUserHivesResults = @()
            $HashReturn['RegistryProcessTracking'].Comment = @()
        #endregion Create Return hash

        #region Parameter Set Results
            If
            (
                $PSBoundParameters
            )
            {
                $HashReturn['RegistryProcessTracking'].ParameterSetResults = $PSBoundParameters
            }
            Else
            {
                $HashReturn['RegistryProcessTracking'].ParameterSetResults = @()
            }
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
                    $HSqlite.TableName = 'BGRegistryProcessTracking'
                #endregion Table Name

                #region Set Column Information
                    $HSqlite.TableColumns = 'Path TEXT,
                        FileName TEXT,
                        BaseName TEXT,
                        LastModified TEXT,
                        CreatedOn TEXT,
                        FileSize INTEGER,
                        FileVersion TEXT,
                        LastExecutedOn TEXT,
                        OnDisk TEXT,
                        UserName TEXT,
                        Hash TEXT,
                        UserHive TEXT,
                        LoadedShell TEXT,
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
            #region Setup Registry Hives for PSProvider
                $null = New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue
                $null = New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -ErrorAction SilentlyContinue
                $null = New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue
            #endregion Setup Registry Hives for PSProvider

            #region Query Prefetch Registry Setting
                $Error.Clear()
                Try
                {
                    $PrefetchParameters = Get-ItemProperty -Path `
                        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name `
                        'EnableSuperfetch' -ErrorAction Stop | Select-Object -ExpandProperty EnableSuperfetch
                }
                Catch
                {
                    $PrefetchParameters = Get-ItemProperty -Path `
                        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name `
                        'EnablePrefetcher' -ErrorAction Stop | Select-Object -ExpandProperty EnablePrefetcher
                }

                Switch
                (
                    $PrefetchParameters
                )
                {
                    0
                    {
                        $HashReturn.RegistryProcessTracking.PrefetchSetting = 'Disable'
                        $PrefetchEnabled = 0
                    }
                    1
                    {
                        $HashReturn.RegistryProcessTracking.PrefetchSetting = 'Enable prefetching when program is launched'
                        $PrefetchEnabled = 1
                    }
                    2
                    {
                        $HashReturn.RegistryProcessTracking.PrefetchSetting = 'Enable boot prefetching'
                        $PrefetchEnabled = 1
                    }
                    3
                    {
                        $HashReturn.RegistryProcessTracking.PrefetchSetting = 'Enable prefetching of everything'
                        $PrefetchEnabled = 1
                    }
                    Default
                    {
                        $HashReturn.RegistryProcessTracking.PrefetchSetting = $($Error.Exception | Out-String)
                        $PrefetchEnabled = 0
                    }
                }
            #endregion Query Prefetch Registry Setting

            #region Query Prefect Service Setting
                Try
                {
                    $HashReturn.RegistryProcessTracking.PrefetchService = $(Get-Service -DisplayName Superfetch -ErrorAction Stop | `
                        Select-Object -ExpandProperty Status).toString()
                }
                Catch
                {
                    $HashReturn.RegistryProcessTracking.PrefetchService = $(Get-Service -DisplayName SysMain -ErrorAction Stop | `
                        Select-Object -ExpandProperty Status).toString()
                }

                If
                (
                    $HashReturn.RegistryProcessTracking.PrefetchService -eq 'Running'
                )
                {
                    $PrefetchEnabled += 1
                }
            #endregion Query Prefect Service Setting

            #region Create Parent Array
                $ArrTempData = @()
            #endregion Create Parent Array

            #region Pull all loaded user hives
                $Error.Clear()
                $AllUserHives = $(Get-BGLoadedRegHives -ReturnObject -ErrorAction SilentlyContinue)
            #endregion Pull all loaded user hives

            #region All User Hive Results
                If
                (
                    $AllUserHives
                )
                {
                    $HashReturn.RegistryProcessTracking.AllUserHivesResults += $AllUserHives
                }
            #endregion All User Hive Results

            #region Parse each loaded user hive
                $Error.Clear()
                If
                (
                    $AllUserHives
                )
                {
                    $AllUserHives | ForEach-Object `
                    -Process `
                    {
                        $CurUserHive = $_

                        #region Query Prefetch Items
                            $ArrNotMatch = @(
                                'LangID',
                                'PSPath',
                                'PSParentPath',
                                'PSChildName',
                                'PSDrive',
                                'PSProvider'
                            )

                            $ArrPrefetchCollection = $($(Get-ItemProperty `
                                $('{0}\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store' -f `
                                $CurUserHive.PSPath)  -ErrorAction SilentlyContinue).psobject.properties | Where-Object `
                                -FilterScript { $_.'TypeNameOfValue' -eq 'System.Byte[]' } | Select-Object -ExpandProperty Name)

                            If
                            (
                                -Not $ArrPrefetchCollection
                            )
                            {
                                $HashReturn['RegistryProcessTracking'].Comment += $('No Values Found: {0}\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store' -f $CurUserHive.PSPath)
                            }

                            $ArrPrefetchCollection += $($(Get-ItemProperty -Path `
                                $('{0}\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache' -f $CurUserHive.PSPath) `
                                -ErrorAction SilentlyContinue).psobject.properties | Where-Object -FilterScript `
                                { $_.'Name' -NotMatch '.ApplicationCompany' } | Select-Object -ExpandProperty Name) -replace `
                                ('.FriendlyAppName','') | Where-Object -FilterScript { $ArrNotMatch -notcontains $_ }

                            If
                            (
                                -Not $ArrPrefetchCollection
                            )
                            {
                                $HashReturn['RegistryProcessTracking'].Comment += $('No Values Found: {0}\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache' -f $CurUserHive.PSPath)
                            }
                        #endregion Query Prefetch Items

                        #region Set Property Details
                            If
                            (
                                $ArrPrefetchCollection
                            )
                            {
                                $ArrPrefetchCollection | ForEach-Object `
                                -Process `
                                {
                                    #region Build Object
                                        $CurPrefetchItem = $_

                                        $CurPrefetchObj = New-Object -TypeName PSObject -Property @{
                                            'Path' = ''
                                            'FileName' = ''
                                            'BaseName' = ''
                                            'LastModified' = ''
                                            'CreatedOn' = ''
                                            'FileSize' = 0
                                            'FileVersion' = ''
                                            'LastExecutedOn' = @()
                                            'OnDisk' = 'FALSE'
                                            'UserName' = $CurUserHive.UserName
                                            'Hash' = ''
                                            'UserHive' = $CurUserHive.UserHive
                                            'LoadedShell' = $CurUserHive.LoadedShell
                                            'Signature_Comment' = ''
                                            'Signature_FileVersion' = ''
                                            'Signature_Description' = ''
                                            'Signature_Date' = ''
                                            'Signature_Company' = ''
                                            'Signature_Publisher' = ''
                                            'Signature_Verified' = 'N/A'
                                        }

                                        Try
                                        {
                                            $CurPrefetchInfo = Get-Item -Path $CurPrefetchItem -Force -ErrorAction Stop
                                            $CurPrefetchObj.Path = $CurPrefetchInfo.FullName
                                            $CurPrefetchObj.OnDisk = 'True'
                                            $CurPrefetchObj.FileName = $CurPrefetchInfo.Name
                                            $CurPrefetchObj.BaseName = $CurPrefetchInfo.BaseName
                                            $CurPrefetchObj.Hash = $(Get-BGHashInfo `
                                                -Path $CurPrefetchItem -Algorithm $Algorithm -ErrorAction SilentlyContinue)
                                            $CurPrefetchObj.LastModified = $($CurPrefetchInfo.LastWriteTime | Out-String).Trim()
                                            $CurPrefetchObj.CreatedOn = $($CurPrefetchInfo.CreationTime | Out-String).Trim()
                                            $CurPrefetchObj.FileSize = $CurPrefetchInfo.Length
                                            $CurPrefetchObj.FileVersion = $($CurPrefetchInfo | `
                                                Select-Object -ExpandProperty VersionInfo | `
                                                Select-Object -ExpandProperty FileVersion | Out-String).Trim()
                                        }
                                        Catch
                                        {
                                            $CurPrefetchObj.FileName = Split-Path -Path $CurPrefetchItem -leaf
                                            $CurPrefetchObj.BaseName = $(Split-Path -Path $CurPrefetchItem -leaf) -replace '\..*$',''
                                        }
                                    #endregion Build Object

                                    #region Query LastWriteTime
                                        If
                                        (
                                            $PrefetchEnabled -eq 2 -and $($CurPrefetchInfo -ne '')
                                        )
                                        {
                                            $ArrCurLastWriteTime = @()
                                            $CurLastWriteTimeItemPrefetch = Get-ChildItem -Path $('{0}\Prefetch' -f $env:windir) `
                                                -Filter $('{0}*.pf' -f $($CurPrefetchObj.BaseName)) -Force -ErrorAction SilentlyContinue

                                            Switch
                                            (
                                                $($CurLastWriteTimeItemPrefetch).Count
                                            )
                                            {
                                                0
                                                {

                                                }

                                                Default
                                                {
                                                    $CurLastWriteTimeItemPrefetch | ForEach-Object `
                                                        -Process `
                                                        {
                                                            $ArrCurLastWriteTime += $($_.LastWriteTime.ToString() | Out-String).Trim()
                                                        }

                                                    $CurPrefetchObj.LastExecutedOn += $ArrCurLastWriteTime
                                                }
                                            }
                                        }
                                    #endregion Query LastWriteTime

                                    #region Query Signature
                                        If
                                        (
                                            $Signature -and $($CurPrefetchInfo -ne '')
                                        )
                                        {
                                            Try
                                            {
                                                $CurSignature = $(Get-BGSignature -Path $($CurPrefetchObj.Path) -Algorithm $Algorithm `
                                                    -ErrorAction Stop)

                                                $CurPrefetchObj.Signature_Comment = $($CurSignature).Comment
                                                $CurPrefetchObj.Signature_FileVersion = $($CurSignature).'File Version'
                                                $CurPrefetchObj.Signature_Description = $($CurSignature).Description
                                                $CurPrefetchObj.Signature_Date = $($CurSignature).Date
                                                $CurPrefetchObj.Signature_Company = $($CurSignature).Company
                                                $CurPrefetchObj.Signature_Publisher = $($CurSignature).Publisher

                                                If
                                                (
                                                    $($CurSignature).Verified
                                                )
                                                {
                                                    $CurPrefetchObj.Signature_Verified = $($CurSignature).Verified
                                                }
                                            }
                                            Catch
                                            {
                                                    #Nothing
                                            }
                                        }
                                    #endregion Query Signature

                                    #region Update Array DB Content to String
                                        If
                                        (
                                            $UpdateDB
                                        )
                                        {
                                            $CurPrefetchObj.LastExecutedOn = $CurPrefetchObj.LastExecutedOn | ConvertTo-Json -Compress
                                        }
                                    #endregion Update Array DB Content to String

                                    #region Process Item
                                        If
                                        (
                                            $UseCache
                                        )
                                        {
                                            '---' | Out-File -FilePath $CachePath -Append -Force
                                            $CurPrefetchObj | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                        }
                                        Else
                                        {
                                            $ArrTempData += $CurPrefetchObj
                                        }
                                        $CurPrefetchObj = $null
                                    #endregion Process Item
                                }
                            }
                        #endregion Set Property Details
                    }
                }
            #endregion Parse each loaded user hive

            #region CleanUp
                $PrefetchParameters = $null
                $AllUserHives = $null
                $CurUserHive = $null
                $ArrNotMatch = $null
                $ArrPrefetchCollection = $null
                $CurPrefetchItem = $null
                $CurPrefetchObj = $null
                $ArrCurLastWriteTime = $null
                $CurLastWriteTimeItemPrefetch = $null
                $CurSignature = $null

                If
                (
                    $ClearGarbageCollecting
                )
                {
                        $null = Clear-BlugenieMemory
                }
            #endregion CleanUp

            #region Set Item Info
                If
                (
                    $ArrTempData
                )
                {
                    $HashReturn['RegistryProcessTracking']['Items'] += $ArrTempData
                }
                ElseIf
                (
                    $UseCache
                )
                {
                    $ArrTempData = Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments | ConvertTo-Json | ConvertFrom-Json
                    $HashReturn['RegistryProcessTracking']['Items'] += $ArrTempData
                    If
                    (
                        $RemoveCache
                    )
                    {
                        $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
                    }
                }
            #endregion Set Item Info

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
                        Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($ArrTempData | `
                        Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                    }
                    Else
                    {
                        Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($ArrTempData | `
                        Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                    }
                }
            #endregion Update DB

            #region Update Count Information
                $HashReturn['RegistryProcessTracking'].Count = $ArrTempData.Count
            #endregion Update Count Information
        #endregion Main

        #region Output
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['RegistryProcessTracking'].EndTime = $($EndTime).DateTime
            $HashReturn['RegistryProcessTracking'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

            If
            (
                -Not $($VerbosePreference -eq 'Continue')
            )
            {
                #Add Hash Properties that are not needed without Verbose enabled.
                $null = $HashReturn['RegistryProcessTracking'].Remove('StartTime')
                $null = $HashReturn['RegistryProcessTracking'].Remove('ParameterSetResults')
                $null = $HashReturn['RegistryProcessTracking'].Remove('CachePath')
                $null = $HashReturn['RegistryProcessTracking'].Remove('PrefetchSetting')
                $null = $HashReturn['RegistryProcessTracking'].Remove('PrefetchService')
                $null = $HashReturn['RegistryProcessTracking'].Remove('AllUserHivesResults')
                $null = $HashReturn['RegistryProcessTracking'].Remove('EndTime')
                $null = $HashReturn['RegistryProcessTracking'].Remove('ElapsedTime')
            }

            #region Output Type
                $ResultSet = $ArrTempData
                $ArrTempData = $null

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
#endregion Get-BluGenieRegistryProcessTracking (Function)