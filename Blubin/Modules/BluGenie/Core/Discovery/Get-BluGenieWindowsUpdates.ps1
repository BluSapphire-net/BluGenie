#region Get-BluGenieWindowsUpdates (Function)
Function Get-BluGenieWindowsUpdates
{
<#
    .SYNOPSIS
        Get Windows Update, Patch, Rollup, Service Pack, Hotfix, and Definition Update Information

    .DESCRIPTION
        Get-BluGenieWindowsUpdates is a much more robust version of Get-HotFix.

        Get-Hotfix commandlet leverages the Win32_QuickFixEngineering WMI class to list Windows Updates,
        but only returns updates supplied by Component Based Servicing (CBS). Updates supplied by the
        Microsoft Windows Installer (MSI) or the Windows Update Site are not returned.

        Get-Hotfix is also not very descriptive.

        Get-BluGenieWindowsUpdates uses 3 different methods to pull Windows Update, Patch, Rollup, Service Pack, Hotfix,
		and Definition Update Information

            Methods (1) - Installer Files for Servicing\Packages
            Methods (2) - The Microsoft.Update.Session COMObject
            Methods (3) - HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Patches

        Example Return:
            HotFixID      : KB915597
            Title         : Definition Update for Windows Defender Antivirus - KB915597 (Definition 1.277.195.0)
            ReleaseType   : Definition Update
            InstalledDate : 9/29/2018 9:50:46 PM
            QueryLocation : Microsoft.Update.Session
            ID            : 915597
            SupportUrl    : http://support.microsoft.com/?kbid=915597

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
        Command: Get-BluGenieWindowsUpdates
        Description: Get Windows Update, Patch, Rollup, Service Pack, Hotfix, and Definition Update Information
        Notes: The default return is a Hash Table

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Get-BluGenieWindowsUpdates -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        •	Original Author           : Michael Arroyo
        •	Original Build Version    : 1904.0301
        •	Latest Author             : Michael Arroyo
        •	Latest Build Version      : 21.02.2401
        •	Comments                  :
        •	PowerShell Compatibility  : 2,3,4,5.x
        •	Forked Project            :
        •	Link                      :
                o
        •	Dependencies              :
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
    o 1904.0101:• [Michael Arroyo] Posted
    o 1904.0301:• [Michael Arroyo] Updated error controls around the compare objects
                • [Michael Arroyo] Updated registry patch results.  The function is cleaner.
    o 2002.2801:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                • [Michael Arroyo] Updated the function to the new function tempatle
                • [Michael Arroyo] Added more detailed information to the Return data
                • [Michael Arroyo] Updated the Code to the '145' column width standard
                • [Michael Arroyo] Added a path check for 'HKLM:\SOFTWARE\Classes\Installer\Patches' so there are no path errors
                • [Michael Arroyo] Added the HotFix values to the returning Hash Table. This was only viewable using ReturnObject switch
    o 21.02.2401• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				• [Michael Arroyo] Moved Build Notes out of General Posh Help section
				• [Michael Arroyo] Added support for Caching
				• [Michael Arroyo] Added support for Clearing Garbage collecting
				• [Michael Arroyo] Added supoort for SQLite DB
				• [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
				• [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
									unless you manually set the -Verbose parameter.
                • [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                • [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-WindowsUpdates','Get-BGWindowsUpdates')]
    #region Parameters
    Param
    (
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
        $HashReturn.WindowsUpdates = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['WindowsUpdates'].StartTime = $($StartTime).DateTime
        $HashReturn['WindowsUpdates']['Comments'] = @()
		$HashReturn['WindowsUpdates']['Updates'] = @()
		$HashReturn['WindowsUpdates']['Count'] = 0
        $HashReturn['WindowsUpdates']['ParameterSetResults'] = @()
        $HashReturn['WindowsUpdates']['CachePath'] = $CachePath
        $HashReturn['WindowsUpdates']['ServicingPackagesResults'] = @{}
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['WindowsUpdates']['ParameterSetResults'] += $PSBoundParameters
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
                $HSqlite.TableName = 'BGWindowsUpdates'
            #endregion Table Name

            #region Set Column Information
                #***Sample Column Names (Please Change)***
                $HSqlite.TableColumns = 'HotFixID TEXT,
                Title TEXT,
                Description TEXT,
                ReleaseType TEXT,
                InstalledDate TEXT,
                QueryLocation TEXT,
                ID TEXT,
                SupportUrl TEXT'
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
        $ArrTempData = @()

		#region Query Installed patches from the Servicing\Packages Directory
            #region Pull all Patch info for *KB*.mum files
                $Error.Clear()
                $ServicingPackages = $(Get-ChildItem -Path $('{0}\servicing\Packages' -f $env:windir) -Filter "*KB*.mum" `
					-ErrorAction SilentlyContinue)
                $FilteredServicingPackages = $ServicingPackages |
                Select-Object -Property `
                @{
                    Name='HotFixID'
                    Expression={
                        [RegEx]::Match($($_.BaseName),'(KB\d+)').captures.groups[1].value
                    }
                },
                @{
                    Name='Title'
                    Expression={
                        [RegEx]::Match($(Get-Content -Path $_.FullName),'displayName\=\"(.*?)\"').captures.groups[1].value
                    }
                },
                @{
                    Name='Description'
                    Expression={
                        [RegEx]::Match($(Get-Content -Path $_.FullName),'description\=\"(.*?)\"').captures.groups[1].value
                    }
                },
                @{
                    Name='ReleaseType'
                    Expression={
                        [RegEx]::Match($(Get-Content -Path $_.FullName),'releaseType\=\"(.*?)\"').captures.groups[1].value
                    }
                },
                @{
                    Name='InstalledDate'
                    Expression={
                        $($_.CreationTime.Tostring() | Out-String).Trim()
                    }
                },
                @{
                    Name='QueryLocation'
                    Expression={
                        $('{0}\servicing\Packages' -f $env:windir)
                    }
                }
            #endregion Pull all Patch info for *KB*.mum files

            #region Servicing\Packages file results check
                If
                (
                    $ServicingPackages
                )
                {
                    $HashReturn['WindowsUpdates']['ServicingPackagesResults'] += @{
                        'Status' = $true
                        'Comment' = $('Found {0} Servicing Package Results' -f $($ServicingPackages | `
							Measure-Object | Select-Object -ExpandProperty Count))
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
                Else
                {
                    $HashReturn['WindowsUpdates']['ServicingPackagesResults'] += @{
                        'Status' = $false
                        'Comment' = 'No data found for *KB*.mum'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = $($Error.Exception | Out-String)
                    }
                }
            #endregion Servicing\Packages file results check

            #region Filter and Rebuild Objects
                $ArrServicingPackages = @()

                $FilteredServicingPackages.HotFixID | Select-Object -Unique | ForEach-Object `
                -Process `
                {
                    $CurServicingPackage = $_
                    $ArrServicingPackages += $FilteredServicingPackages | `
						Where-Object -FilterScript { $_.'HotFixID' -eq $CurServicingPackage } | `
						Sort-Object -Property InstalledDate | Select-Object -Last 1
                }

                $ArrServicingPackages | ForEach-Object `
                -Process `
                {
                    $CurServicingPackageItem = $_
                    If
                    (
                        $CurServicingPackageItem.Title -eq 'default'
                    )
                    {
                        $CurServicingPackageItem.Title = $('{0} for Microsoft Windows ({1})' -f `
							$CurServicingPackageItem.ReleaseType,$CurServicingPackageItem.HotFixID)
                    }

                    $CurServicingPackageItem | Add-Member -MemberType NoteProperty -Name ID -Value $($($CurServicingPackageItem.HotFixID) `
						-replace ('^KB',''))
                    $CurServicingPackageItem | Add-Member -MemberType NoteProperty -Name SupportUrl `
						-Value $('http://support.microsoft.com/?kbid={0}' -f $($($CurServicingPackageItem.HotFixID) -replace ('^KB','')))

                    If
                    (
                        $UseCache
                    )
                    {
                        '---' | Out-File -FilePath $CachePath -Append -Force
                        $CurServicingPackageItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                    }
                    Else
                    {
                        $ArrTempData += $CurServicingPackageItem
                    }
                }
            #endregion Filter and Rebuild Objects

            #region Remove Garbage Collection
                $ServicingPackages = $null
                $FilteredServicingPackages = $null
                $ArrServicingPackages = $null
                $CurServicingPackageItem = $null
                $CurServicingPackage = $null

                If
                (
                    $ClearGarbageCollecting
                )
                {
                        $null = Clear-BlugenieMemory
                }
            #endregion Remove Garbage Collection
        #endregion Query Installed patches from the Servicing\Packages Directory

        #region Query Installed patches from the "Microsoft.Update.Session"
            #region Pull all Patch info Microsoft.Update.Session
                $Error.Clear()
                $Session = New-Object -ComObject "Microsoft.Update.Session"
                $Searcher = $Session.CreateUpdateSearcher()

                $historyCount = $Searcher.GetTotalHistoryCount()

                $HotFixList = $Searcher.QueryHistory(0, $historyCount) | Where-Object -FilterScript { $_.'Operation' -eq 1 } |
                Select-Object -Property `
                    @{
                        Name='HotFixID'
                        Expression={
                            [RegEx]::Match($($_.Title),'\W(KB\d+)\W').captures.groups[1].value
                        }
                    },
                    Title,
                    @{
                        Name='ReleaseType'
                        Expression={
                            [RegEx]::Match($($_.Title),'(\w*.Update)\s').captures.groups[1].value
                        }
                    },
                    @{
                        Name='InstalledDate'
                        Expression={
                            $($_.Date.Tostring() | Out-String).Trim()
                        }
                    },
                    @{
                        Name='QueryLocation'
                        Expression={
                            'Microsoft.Update.Session'
                        }
                    }
            #endregion Pull all Patch info Microsoft.Update.Session

            #region Microsoft.Update.Session results check
                If
                (
                    $HotFixList
                )
                {
                    $HashReturn.WindowsUpdates.MicrosoftUpdateSessionResults = @{
                        'Status' = $true
                        'Comment' = $('Found {0} Microsoft.Update.Session Results' -f $($HotFixList | `
							Measure-Object | Select-Object -ExpandProperty Count))
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
                Else
                {
                    $HashReturn.WindowsUpdates.MicrosoftUpdateSessionResults = @{
                        'Status' = $false
                        'Comment' = 'No data found for Microsoft.Update.Session'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = $($Error.Exception | Out-String)
                    }
                }
            #endregion Microsoft.Update.Session results check

            #region Filter and Rebuild Objects
                $ArrUpdateSession = @()

                $HotFixList.HotFixID | Select-Object -Unique | ForEach-Object `
                -Process `
                {
                    $CurUpdateSession = $_
                    $ArrUpdateSession += $HotFixList | Where-Object -FilterScript { $_.'HotFixID' -eq $CurUpdateSession } | `
						Sort-Object -Property InstalledDate | Select-Object -Last 1
                }

                $ArrUpdateSession | ForEach-Object `
                -Process `
                {
                    $CurUpdateSessionItem = $_
                    $CurUpdateSessionItem | Add-Member -MemberType NoteProperty -Name ID -Value $($($CurUpdateSessionItem.HotFixID) `
						-replace ('^KB','')) -Force -ErrorAction SilentlyContinue
                    $CurUpdateSessionItem | Add-Member -MemberType NoteProperty -Name SupportUrl `
						-Value $('http://support.microsoft.com/?kbid={0}' -f $($($CurUpdateSessionItem.HotFixID) -replace ('^KB',''))) `
                        -Force -ErrorAction SilentlyContinue
                    $CurUpdateSessionItem | Add-Member -MemberType NoteProperty -Name Description `
						-Value $($CurUpdateSessionItem.Title) -Force -ErrorAction SilentlyContinue

                    If
                    (
                        $CurUpdateSessionItem.ReleaseType -eq $null
                    )
                    {
                        Switch
                        (
                            $CurUpdateSessionItem.Title
                        )
                        {
                            #Match *Rollup
                            {
                                $_ -match '[a-zA-Z].*Rollup'
                            }
                            {
                                $CurUpdateSessionItem.ReleaseType = $($CurUpdateSessionItem.Title | `
									Select-String -Pattern '[a-zA-Z].*Rollup').matches.Value
                            }
                            #Match *Update
                            {
                                $_ -match '[a-zA-Z].*Update'
                            }
                            {
                                $CurUpdateSessionItem.ReleaseType = $($CurUpdateSessionItem.Title | `
									Select-String -Pattern '[a-zA-Z].*Update').matches.Value
                            }
                            #Match ^Update
                            {
                                $_ -match '^Update'
                            }
                            {
                                $CurUpdateSessionItem.ReleaseType = $($CurUpdateSessionItem.Title | `
									Select-String -Pattern '^Update').matches.Value
                            }
                            #Match ^Update
                            Default
                            {
                                $CurUpdateSessionItem.ReleaseType = 'Update'
                            }
                        }
                    }

                    If
                    (
                        $UseCache
                    )
                    {
                        '---' | Out-File -FilePath $CachePath -Append -Force
                        $CurUpdateSessionItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                    }
                    Else
                    {
                        $ArrTempData += $CurUpdateSessionItem
                    }
                }
            #endregion Filter and Rebuild Objects

            #region Remove Garbage Collection
                $Session = $null
                $Searcher = $nuull
                $historyCount = $null
                $HotFixList = $null
                $ArrUpdateSession = $null
                $CurUpdateSessionItem = $null
                $CurUpdateSession = $null

                If
                (
                    $ClearGarbageCollecting
                )
                {
                        $null = Clear-BlugenieMemory
                }
            #endregion Remove Garbage Collection
        #endregion Query Installed patches from the "Microsoft.Update.Session"

		#region Query Installed patches from 'HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Patches'
			#region Pull all Registry Patch Info
                $Error.Clear()

                If
                (
                    Test-Path -Path 'HKLM:\SOFTWARE\Classes\Installer\Patches'
                )
                {
                    $RegPatchList = $(Get-ItemProperty -ErrorAction SilentlyContinue -Path $($(Get-ChildItem -path `
                        'HKLM:\SOFTWARE\Classes\Installer\Patches' -Recurse -Force -ErrorAction SilentlyContinue | `
                        Where-Object -FilterScript { $_.'Name' -Like '*SourceList' } | Select-Object -ExpandProperty Name) `
                        -replace ('HKEY_LOCAL_MACHINE','HKLM:')) -Name PackageName | Select-Object -ExpandProperty PackageName)
                    $ArrPatchList = $($RegPatchList | Select-String -ErrorAction SilentlyContinue -Pattern '(KB\d+)' -AllMatches).Matches.Value
                }
            #endregion Pull all Registry Patch Info

            #region Regsitry results check
                If
                (
                    $ArrPatchList
                )
                {
                    $HashReturn.WindowsUpdates.RegistryResults = @{
                        'Status' = $true
                        'Comment' =  $('Found {0} Registry Results' -f $($ArrPatchList | `
                            Measure-Object | Select-Object -ExpandProperty Count))
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
                ElseIf
                (
                    $RegPatchList -and $($ArrPatchList -eq $null)
                )
                {
                    $HashReturn.WindowsUpdates.RegistryResults = @{
                        'Status' = $true
                        'Comment' = 'No Windows KBs found in "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Patches"'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
                Else
                {
                    $HashReturn.WindowsUpdates.RegistryResults = @{
                        'Status' = $false
                        'Comment' = 'No data found in "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Patches"'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
            #endregion Regsitry results check

            #region Filter and Rebuild Objects
                If
                (
                    $ArrPatchList
                )
                {
                    $ArrPatchList | ForEach-Object `
                    -Process `
                    {
                        $CurPatchListItem = $_
                        If
                        (
                            Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Updates'
                        )
                        {
                            Try
                            {
                                $CurPatchListReg = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Updates -Recurse -Force `
                                    -ErrorAction Stop | Where-Object -FilterScript { $_.'Name' -like "*$CurPatchListItem" }
                            }
                            Catch
                            {
                                #Nothing
                            }
                        }
                        ElseIf
                        (
                            Test-Path -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Updates'
                        )
                        {
                            Try
                            {
                                $CurPatchListReg = Get-ChildItem -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Updates -Recurse -Force `
                                    -ErrorAction Stop | Where-Object -FilterScript { $_.'Name' -like "*$CurPatchListItem" }
                            }
                            Catch
                            {
                                #Nothing
                            }
                        }

                        If
                        (
                            $CurPatchListReg
                        )
                        {
                            $CurPatchListProp = Get-ItemProperty -Path $($CurPatchListReg.Name -replace ('HKEY_LOCAL_MACHINE','HKLM:')) `
                                -ErrorAction SilentlyContinue

                            $FinalPatchObj = New-Object -TypeName PSObject -Property @{
                                HotFixID = $CurPatchListItem
                                Title = $CurPatchListProp.PackageName
                                Description = $CurPatchListProp.PackageName
                                ReleaseType = $CurPatchListProp.ReleaseType
                                InstalledDate = $('{0} 12:00:00 AM' -f $($CurPatchListProp.InstalledDate.ToString() | Out-String).Trim())
                                QueryLocation = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates'
                                ID = $($($CurPatchListItem) -replace ('^KB',''))
                                SupportUrl = $('http://support.microsoft.com/?kbid={0}' -f $($($CurPatchListItem) -replace ('^KB','')))
                            }

                            If
                            (
                                $UseCache
                            )
                            {
                                '---' | Out-File -FilePath $CachePath -Append -Force
                                $FinalPatchObj | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                            }
                            Else
                            {
                                $ArrTempData += $FinalPatchObj
                            }
                        }
                    }
                }
            #endregion Filter and Rebuild Objects

            #region Remove Garbage Collection
                $RegPatchList = $null
                $ArrPatchList = $null
                $ArrFinalNetPatchList = $null
                $CurPatchListItem = $null
                $CurPatchListReg = $null
                $CurPatchListProp = $null
                $FinalPatchObj = $null

                If
                (
                    $ClearGarbageCollecting
                )
                {
                        $null = Clear-BlugenieMemory
                }
            #endregion Remove Garbage Collection
		#endregion Query Installed patches from 'HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Patches'

        #region Item Count
            If
            (
                $ArrTempData
            )
            {
                $HashReturn.WindowsUpdates['Updates'] += $ArrTempData
                $ArrTempData = $null
            }
            ElseIf
            (
                $UseCache
            )
            {
                $HashReturn.WindowsUpdates['Updates'] += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
                If
                (
                    $RemoveCache
                )
                {
                    $null = Remove-Item  -Path $CachePath -Force -ErrorAction SilentlyContinue
                }
            }

            $HashReturn['WindowsUpdates'].Count = $($HashReturn.WindowsUpdates['Updates'] | Measure-Object | Select-Object -ExpandProperty Count)
        #endregion Item Count

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
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($HashReturn.WindowsUpdates['Updates'] | `
                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Replace
                }
                Else
                {
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($HashReturn.WindowsUpdates['Updates'] | `
                    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                }
            }
        #endregion Update DB
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['WindowsUpdates'].EndTime = $($EndTime).DateTime
        $HashReturn['WindowsUpdates'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
            Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Remove Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['WindowsUpdates'].Remove('StartTime')
            $null = $HashReturn['WindowsUpdates'].Remove('ParameterSetResults')
            $null = $HashReturn['WindowsUpdates'].Remove('CachePath')
            $null = $HashReturn['WindowsUpdates'].Remove('EndTime')
            $null = $HashReturn['WindowsUpdates'].Remove('ElapsedTime')
            $null = $HashReturn['WindowsUpdates'].Remove('ServicingPackagesResults')
            $null = $HashReturn['WindowsUpdates'].Remove('MicrosoftUpdateSessionResults')
            $null = $HashReturn['WindowsUpdates'].Remove('RegistryResults')
        }

        #region Output Type
            $ResultSet = $HashReturn['WindowsUpdates']['Updates']

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
#endregion Get-BluGenieWindowsUpdates (Function)