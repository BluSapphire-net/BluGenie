#region Invoke-BluGenieYara (Function)
Function Invoke-BluGenieYara
{
<#
    .SYNOPSIS
        Yara Scanner

    .DESCRIPTION
        Invoke-BluGenieYara is a wrapper around the YARA tool.  The Yara tools is designed to help malware researchers identify and classify
malware samples. It’s been called the pattern-matching Swiss Army knife for security researchers (and everyone else).

    .PARAMETER Rules
		Description: .Yar Rule Names (Filtered with RegEx)
		Notes:  Default is set to '.*'
		Alias:
		ValidateSet:

	.PARAMETER ItemToScan
		Description: File(s), Directory, PID, or AllPids Scan
		Notes:  If ItemToScan = "AllPids", every PID on the System will be scanned
		Alias:
		ValidateSet:

	.PARAMETER RulesSource
		Description: Source path to for your .Yar Rule files
		Notes:  Default Search Paths
					* $Env:SystemDrive\Windows\Temp
					* %Current Script Directory%
					* $Env:Temp
					This scan is not recursive.
		Alias:
		ValidateSet:

	.PARAMETER CompiledRules
		Description: Load compiled rules
		Notes:
		Alias: 'CR'
		ValidateSet:

    .PARAMETER ToolPath
		Description:
		Notes: Default is set to  $('{0}\Windows\Temp' -f $env:SystemDrive)
		Alias:
		ValidateSet:

    .PARAMETER Count
		Description: Print only number of matches
		Notes:
		Alias: 'C'
		ValidateSet:

    .PARAMETER Tag
		Description: Print only rules tagged as TAG
		Notes: tag=TAG
		Alias: 'T'
		ValidateSet:

    .PARAMETER Identifier
		Description: Print only rules named IDENTIFIER
		Notes: identifier=IDENTIFIER
		Alias: 'I'
		ValidateSet:

    .PARAMETER Negate
		Description: Print only not satisfied rules (negate)
		Notes:
		Alias: 'N'
		ValidateSet:

    .PARAMETER PrintTags
		Description: Print tags
		Notes:
		Alias: 'PT'
		ValidateSet:

    .PARAMETER PrintMeta
		Description: Print metadata
		Notes:
		Alias: 'PM'
		ValidateSet:

    .PARAMETER MaxStringsPerRule
		Description: Set maximum number of strings per rule (default=10000)
		Notes:
		Alias: 'MS'
		ValidateSet:

	.PARAMETER PrintStrings
		Description: Print matching strings
		Notes:
		Alias: 'PS'
		ValidateSet:

	.PARAMETER PrintStats
		Description: Print rules' statistics
		Notes:
		Alias: 'PA'
		ValidateSet:

	.PARAMETER PrintNamespace
		Description: Print rules' namespace
		Notes:
		Alias: 'PN'
		ValidateSet:

    .PARAMETER Threads
		Description: Use the specified NUMBER of threads to scan a directory
		Notes:
		Alias: 'TR'
		ValidateSet:

    .PARAMETER PrintStringLength
		Description: Print length of matched strings
		Notes:
		Alias: 'PL'
		ValidateSet:

    .PARAMETER MaxRules
		Description: Abort scanning after matching a NUMBER of rules
		Notes:
		Alias: 'M'
		ValidateSet:

    .PARAMETER Timeout
		Description: Abort scanning after the given number of SECONDS
		Notes:
		Alias: 'TO'
		ValidateSet:

    .PARAMETER Recurse
		Description: Recursively search directories (follows symlinks)
		Notes:
		Alias: 'R'
		ValidateSet:

    .PARAMETER FastScan
		Description: Fast matching mode
		Notes:
		Alias: 'F'
		ValidateSet:

    .PARAMETER StasckSize
		Description: Set maximum stack size (default=16384)
		Notes:
		Alias: 'SS'
		ValidateSet:

    .PARAMETER FailOnWarnings
		Description: Fail on warnings
		Notes:
		Alias: 'FW'
		ValidateSet:

    .PARAMETER NoWarnings
		Description: Disable warnings
		Notes:
		Alias: 'NW'
		ValidateSet:

    .PARAMETER Version
		Description: Show version information
		Notes:
		Alias: 'V'
		ValidateSet:

    .PARAMETER CommandHelp
		Description: Show the Yara command help
		Notes:
		Alias: 'CH'
		ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER UseCache
        Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
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
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP
        Description: Scan all files under $env:temp directory with any .Yar rules found
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -Recurse
        Description: Recursive Directory Scan
        Notes:

    .EXAMPLE
        Command: Invoke-BGYara -ItemToScan $env:TEMP -Recurse
        Description: Use the (BG) Alias to run Yara
        Notes:

    .EXAMPLE
        Command: Yara -ItemToScan $env:TEMP -Recurse
        Description: Use the Short Name Alias to run Yara scan
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan "$env:TEMP\AttachmentArchive.msg" -Rules 'Attachment'
        Description: Run all Rules with Attachment in the name against the .MSG file in the temp direcotry
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan "$env:TEMP\AttachmentArchive.msg" -Rules 'Attachment' -RulesSource Z:\YaraRules\Email
        Description: Run all Rules with Attachment in the name from a specific source, against the .MSG file in the temp direcotry
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $(Get-Process -Name notepad++ | Select-Object -ExpandProperty ID)
        Description: Scan a PID
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan 'AllPids'
        Description: Scan all PID using all found .Yar rules
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache
        Description: Cache found objects to disk to not over tax Memory resources
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -RemoveCache
        Description: Remove Cache data
        Notes: By default the Cache information is removed right before the data is returned to the caller

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -CachePath $Env:Temp
        Description: Change the Cache path to the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -ClearGarbageCollecting
        Description: Scan large directories and limit the memory used to track data
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieYara -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGenieYara -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o    Michael Arroyo
        • [Original Build Version]
            o    20.12.1401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o   Michael Arroyo
        • [Latest Build Version]
            o   21.03.0401
        • [Comments]
            o
        • [PowerShell Compatibility]
            o    2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o    Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o    Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o    New-BluGenieUID or New-UID - Create a New UID
            o    ConvertTo-Yaml - ConvertTo Yaml
            o    Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o    ConvertFrom-Yaml - Convert From Yaml
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 20.12.1101• [Michael Arroyo] Function Template
    o 20.12.1401• [Michael Arroyo] Posted
    o 21.03.0401• [Michael Arroyo] Updated the function to the new function template
                • [Michael Arroyo] Added more detailed information to the Return data
                • [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                • [Michael Arroyo] Added support for Caching
                • [Michael Arroyo] Added support for Clearing Garbage collecting
                • [Michael Arroyo] Added support for SQLite DB
                • [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
                • [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                    unless you manually set the -Verbose parameter.
                • [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                • [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                • [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                • [Michael Arroyo] Tools path updated with $('{0}\Tools\Yara\{1}' -f $(Get-Location | Select-Object -ExpandProperty Path), $Yara)
                • [Michael Arroyo] Updated the CommandlineOptions switch process to pull from the parameters directly instead of the
                    PSBoundParameters. This is cleaner and also allows you to test in real time.  The old way using PSBoundParameters
                    is only valid at runtime or debug mode.
                • [Michael Arroyo] 
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Invoke-Yara','Invoke-BGYara', 'Yara')]
    #region Parameters
        Param
        (
            [Parameter(Position = 0)]
            [String[]]$ItemToScan,

            [String]$Rules = '.*',

            [String[]]$RulesSource,

            [Alias('CR')]
            [Parameter()]
            [Switch]$CompiledRules,

            [Parameter()]
            [string]$ToolPath = $(Join-Path -Path $ToolsDirectory -ChildPath 'Yara'),

            [Alias('C')]
            [Parameter()]
            [Switch]$Count,

            [Alias('T')]
            [Parameter()]
            [String]$Tag,

            [Alias('I')]
            [Parameter()]
            [String]$Identifier,

            [Alias('N')]
            [Parameter()]
            [Switch]$Negate,

            [Alias('PT')]
            [Parameter()]
            [Switch]$PrintTags,

            [Alias('PM')]
            [Parameter()]
            [Switch]$PrintMeta,

            [Alias('MS')]
            [Parameter()]
            [Int32]$MaxStringsPerRule,

            [Alias('PS')]
            [Parameter()]
            [Switch]$PrintStrings,

            [Alias('PA')]
            [Parameter()]
            [Switch]$PrintStats,

            [Alias('PN')]
            [Parameter()]
            [Switch]$PrintNamespace,

            [Alias('TR')]
            [Parameter()]
            [Int32]$Threads,

            [Alias('PL')]
            [Parameter()]
            [Int32]$PrintStringLength,

            [Alias('M')]
            [Parameter()]
            [Int32]$MaxRules,

            [Alias('TO')]
            [Parameter()]
            [Int32]$Timeout,

            [Alias('R')]
            [Parameter()]
            [Switch]$Recurse,

            [Alias('F')]
            [Parameter()]
            [Switch]$FastScan,

            [Alias('SS')]
            [Parameter()]
            [Int32]$StasckSize,

            [Alias('FW')]
            [Parameter()]
            [Switch]$FailOnWarnings,

            [Alias('NW')]
            [Parameter()]
            [Switch]$NoWarnings,

            [Alias('V')]
            [Parameter()]
            [Switch]$Version,

            [Alias('CH')]
            [Parameter()]
            [Switch]$CommandHelp,

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
        $HashReturn['InvokeYara'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeYara']['Items'] = @()
        $HashReturn['InvokeYara']['Rules'] = @()
        $HashReturn['InvokeYara']['Comment'] = @()
        $HashReturn['InvokeYara']['ToolPath'] = ''
        $HashReturn['InvokeYara']['ToolCheck'] = 'FALSE'
        $HashReturn['InvokeYara'].StartTime = $($StartTime).DateTime
        $HashReturn['InvokeYara']['YaraCommandLine'] = @()
        $HashReturn['InvokeYara']['ParameterSetResults'] = @()
        $HashReturn['InvokeYara']['CachePath'] = $CachePath
    #endregion Create Return hash

    #region Parameter Set Results
        If
        (
            $PSBoundParameters
        )
        {
            $HashReturn['InvokeYara']['ParameterSetResults'] = $PSBoundParameters
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
                $HSqlite.TableName = 'BGYara'
            #endregion Table Name

            #region Set Column Information
                #***Sample Column Names (Please Change)***
                $HSqlite.TableColumns = 'Items TEXT'
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

    #region Arch Type
        if
        (
            $env:PROCESSOR_ARCHITECTURE -match '64'
        )
        {
            $Yara = 'yara64.exe'
        }
        else
        {
            $Yara = 'yara32.exe'
        }
    #endregion Arch Type

    #region Tool Check
        $Error.Clear()
		$ArrToolPath = @(
            $($ToolPath +'\' +$Yara),
            $('{0}\Windows\Temp\{1}' -f $env:SystemDrive, $Yara),
            $('{0}\{1}' -f $env:Temp, $Yara),
            $('{0}\{1}' -f $(Get-Location | Select-Object -ExpandProperty Path), $Yara),
            $($ToolsConfig.CopyTools  | Where-Object -FilterScript { $_.'Name' -eq $Yara } | Select-Object -ExpandProperty FullPath),
            $('{0}\Tools\Yara\{1}' -f $(Get-Location | Select-Object -ExpandProperty Path), $Yara),
            $('{0}\Dependencies\Tools\{1}' -f $(Get-Module | Where-Object -FilterScript { $_.Name -eq 'BluGenie' } | Select-Object `
                -ExpandProperty Path | Split-Path -Parent), $Yara),
            '..\Tools\Yara\'
		)

       <# $ArrToolPath | ForEach-Object `
        -Process `
        {
            If
            (
                $curToolPath = $_ 
            )
            {
                If
                (
                    -Not $HashReturn['InvokeYara']['ToolPath']
                )
                {
                    if
                    (
                        Test-Path -Path $var -ErrorAction SilentlyContinue
                    )
                    {
                        $HashReturn['InvokeYara']['ToolPath'] = $curToolPath
                        $HashReturn['InvokeYara']['ToolCheck'] = 'TRUE'
                    }
                }
            }
        }#>

        foreach
        (
            $CurToolPath in $ArrToolPath
        )
        {
			If
			(
				$CurToolPath
			)
			{
				if
				(
					Test-Path -Path $CurToolPath -ErrorAction SilentlyContinue
				)
				{
					$HashReturn['InvokeYara']['ToolPath'] = $CurToolPath
					$HashReturn['InvokeYara']['ToolCheck'] = $true
					Break
				}
			}
		}

    #endregion Tool Check

    #region Rules Check
        $Error.Clear()

        If
        (
            $RulesSource
        )
        {
            $ArrRulesPath = @($RulesSource)
        }
        Else
        {
            $ArrRulesPath = @(
                $ToolPath,
                $('{0}\Configs\YaraRules' -f $(Get-Module | Where-Object -FilterScript { $_.Name -eq 'BluGenie' } | `
                    Select-Object -ExpandProperty Path | Split-Path -Parent)),
                $(Get-Location | Select-Object -ExpandProperty Path)
            )
        }

		If
		(
			$Rules
		)
		{
            $ArrRulesPath | Sort-Object -Unique | ForEach-Object `
            -Process `
            {
                $CurRulePath = $_
                $CurRuleQuery = Get-ChildItem -Path $CurRulePath -Filter '*.yar' | Where-Object -FilterScript { $_.Name -match $Rules } | `
                    Select-Object -ExpandProperty Fullname

                If
                (
                    $CurRuleQuery
                )
                {
                    $HashReturn['InvokeYara']['Rules'] += $CurRuleQuery
                }
            }
		}
    #endregion Rules Check

    #region Process Parameters
        $CommandlineOptions = New-Object String[](0)
        switch
        (
            $null
        )
        {
            { $ItemToScan }
            {
                $ScanTarget = $ItemToScan
            }

            { $CompiledRules }
            {
                $CommandlineOptions += '-C'
            }

            { $Count }
            {
                $CommandlineOptions += '-c'
            }

            { $Tag }
            {
                $CommandlineOptions += "--tag=$Tag"
            }

            {$Identifier}
            {
                $CommandlineOptions += "--identifier=$Identifier"
            }

            { $Negate }
            {
                $CommandlineOptions += '-n'
            }

            { $PrintTags }
            {
                $CommandlineOptions += '-g'
            }

            { $PrintMeta }
            {
                $CommandlineOptions += '-m'
            }

            { $MaxStringsPerRule }
            {
                $CommandlineOptions += "--max-strings-per-rule=$MaxStringsPerRule"
            }

            { $PrintStrings }
            {
                $CommandlineOptions += '-s'
            }

            { $PrintStats }
            {
                $CommandlineOptions += '-S'
            }

            { $PrintNamespace }
            {
                $CommandlineOptions += '-e'
            }

            { $Threads }
            {
                $CommandlineOptions += "--threads=$Threads"
            }

            { $PrintStringLength }
            {
                $CommandlineOptions += "--print-string-length=$PrintStringLength"
            }

            { $MaxRules }
            {
                $CommandlineOptions += "--max-rules=$MaxRules"
            }

            { $YaraTimeout }
            {
                $CommandlineOptions += "--timeout=$Timeout"
            }

            { $Recurse }
            {
                $CommandlineOptions += '-r'
            }

            { $FastScan }
            {
                $CommandlineOptions += '-f'
            }

            { $StasckSize }
            {
                $CommandlineOptions += "--stack-size=$StasckSize"
            }

            { $FailOnWarnings }
            {
                $CommandlineOptions += '--fail-on-warnings'
            }

            { $NoWarnings }
            {
                $CommandlineOptions += '-w'
            }

            { $Version }
            {
                $CommandlineOptions += '-v'
            }

            { $CommandHelp }
            {
                $CommandlineOptions += '-h'
            }
        }

    #endregion Process Parameters

    #region Main
        $OldErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'SilentlyContinue'
        $ArrYaraData = @()

        #region Process Yara Command
            If
            (
                $ItemToScan -eq 'AllPids'
            )
            {
                $null = Remove-Item -Path Variable:\ItemToScan -Force
                $ItemToScan = $(Get-Process | Select-Object -ExpandProperty ID)
            }

            Switch
            (
                $null
            )
            {
                #region Version Information
                    {$CommandlineOptions -match '-v'}
                    {
                        $Error.Clear()
                        $HashReturn['InvokeYara']['Comment'] += $(Invoke-Expression -Command "$($HashReturn['InvokeYara']['ToolPath']) -v")

                        If
                        (
                            $Error
                        )
                        {
                            $HashReturn['InvokeYara']['Comment'] += $Error[0].ToString()
                            $Error.Clear()
                        }

                        $ReturnObject = $True

                        If
                        (
                            $VerbosePreference -eq 'Continue'
                        )
                        {
                            $HashReturn['InvokeYara']['YaraCommandLine'] += "$($HashReturn['InvokeYara']['ToolPath']) -v"
                        }
                        break
                    }
                #endregion Version Information

                #region Command Line Information
                    {$CommandlineOptions -match '-h'}
                    {
                        $Error.Clear()
                        $HashReturn['InvokeYara']['Comment'] += $(Invoke-Expression -Command "$($HashReturn['InvokeYara']['ToolPath']) -h")

                        If
                        (
                            $Error
                        )
                        {
                            $HashReturn['InvokeYara']['Comment'] += $Error[0].ToString()
                            $Error.Clear()
                        }

                        $ReturnObject = $True

                        If
                        (
                            $VerbosePreference -eq 'Continue'
                        )
                        {
                            $HashReturn['InvokeYara']['YaraCommandLine'] += "$($HashReturn['InvokeYara']['ToolPath']) -h"
                        }
                        break
                    }
                #endregion Command Line Information

                #region Default
                    Default
                    {
                        If
                        (
                            $ItemToScan.Count -gt 1
                        )
                        {
                            $ItemToScan | ForEach-Object `
                            -Process `
                            {
                                $Error.Clear()
                                $YaraReturn = $(Invoke-Expression -Command `
                                    "$($HashReturn.InvokeYara.ToolPath) $($CommandlineOptions -join ' ') $('"{0}"' -f $($HashReturn.InvokeYara.Rules `
                                    -join '" "')) $('"{0}"' -f $_)")

                                If
                                (
                                    $Error
                                )
                                {
                                    $HashReturn['InvokeYara']['Comment'] += $Error[0].ToString()
                                    $Error.Clear()
                                }

                                $HashReturn['InvokeYara']['YaraCommandLine'] += "$($HashReturn.InvokeYara.ToolPath) $($CommandlineOptions -join ' ') `
                                        $($HashReturn.InvokeYara.Rules -join ' ') $_"

                                If
                                (
                                    $UseCache
                                )
                                {
                                    $YaraReturn | Out-File -FilePath $CachePath -Append
                                }
                                Else
                                {
                                    $ArrYaraData += $YaraReturn
                                }

                                $YaraReturn = $null
                            }
                        }
                        Else
                        {
                            $Error.Clear()
                            $YaraReturn = $(Invoke-Expression -Command "$($HashReturn.InvokeYara.ToolPath) $($CommandlineOptions -join ' ') $('"{0}"' `
                                -f $($HashReturn.InvokeYara.Rules -join '" "')) $('"{0}"' -f $ItemToScan)")

                            If
                            (
                                $Error
                            )
                            {
                                $HashReturn['InvokeYara']['Comment'] += $Error[0].ToString()
                                $Error.Clear()
                            }

                            $HashReturn['InvokeYara']['YaraCommandLine'] += "$($HashReturn.InvokeYara.ToolPath) $($CommandlineOptions -join ' ') `
                                    $($HashReturn.InvokeYara.Rules -join ' ') $ItemToScan"

                            If
                            (
                                $UseCache
                            )
                            {
                                $YaraReturn | Out-File -FilePath $CachePath -Append
                            }
                            Else
                            {
                                $ArrYaraData += $YaraReturn
                            }

                            $YaraReturn = $null
                        }
                    }
                #endregion Default
            }

            $ErrorActionPreference = $OldErrorActionPreference
        #endregion Process Yara Command

        #region Remove Garbage Collection
            $ArrToolPath = $null
            $ArrRulesPath = $null
            $CommandlineOptions = $null

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
                $ArrYaraData
            )
            {
                $HashReturn['InvokeYara']['Items'] += $ArrYaraData
                $ArrYaraData = $null
            }
            ElseIf
            (
                $UseCache
            )
            {
                $YaraCache = Get-Content -Path $CachePath
                $YaraCache | ForEach-Object `
                    -Process `
                    {
                        $HashReturn['InvokeYara']['Items'] += $($_ | Out-String) -replace '\r\n'
                    }

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
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable `
                        $($HashReturn['InvokeYara']['Items'] | ConvertFrom-Csv -Header Items | Out-DataTable) `
                        -Table $HSqlite.TableName -Confirm:$false -ConflictClause Replace
                }
                Else
                {
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable `
                        $($HashReturn['InvokeYara']['Items'] | ConvertFrom-Csv -Header Items | Out-DataTable) `
                        -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                }
            }
        #endregion Update DB
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeYara'].EndTime = $($EndTime).DateTime
        $HashReturn['InvokeYara'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
            Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Remove Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['InvokeYara'].Remove('StartTime')
            $null = $HashReturn['InvokeYara'].Remove('ParameterSetResults')
            $null = $HashReturn['InvokeYara'].Remove('CachePath')
            $null = $HashReturn['InvokeYara'].Remove('EndTime')
            $null = $HashReturn['InvokeYara'].Remove('ElapsedTime')
            $null = $HashReturn['InvokeYara'].Remove('YaraCommandLine')
            $null = $HashReturn['InvokeYara'].Remove('ToolPath')
            $null = $HashReturn['InvokeYara'].Remove('ToolCheck')
        }

        #region Output Type
            $ResultSet = New-Object PSObject -Property @{
                Items = $($($HashReturn['InvokeYara']['Items']))
            }

            switch
            (
                $Null
            )
            {
                #region Beautify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 5 | ForEach-Object -Process { [regex]::Unescape($_) })
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
                                        Return $($ResultSet.Items | ConvertFrom-Csv -Header Items | ConvertTo-Csv -NoTypeInformation)
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
#endregion Invoke-BluGenieYara (Function)