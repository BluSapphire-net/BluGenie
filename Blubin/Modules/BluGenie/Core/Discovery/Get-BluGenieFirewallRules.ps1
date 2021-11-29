#region Get-BluGenieFirewallRules (Function)
Function Get-BluGenieFirewallRules
{
<#
    .SYNOPSIS
        Get a list of Windows FireWall Rules

    .DESCRIPTION
        Get a list of Windows FireWall Rules

    .PARAMETER Type
        Description: Select a specific rule type status
        Notes: Type status ('Enabled', 'Disabled', 'All')
        Alias:
        ValidateSet: 'Enabled','Disabled','All'

    .PARAMETER AllProperties
        Description: Query all firewall property values.
        Notes: The default values are [Name, Description, ApplicationName, Enabled]
        Alias:
        ValidateSet:

    .PARAMETER RuleName
        Description: Name of the Rule(s) you would like to report on.  If the value is not set, the report will be based on (Type) information
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
        Command: Get-BluGenieFirewallRules
        Description: Report on all (Enabled) Windows Firewall Rules
        Notes:

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -Type 'Enabled' -AllProperties
        Description: Report on all Enabled Windows Firewall Rules
        Notes:

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -Type 'Disabled' -AllProperties
        Description: Report on all Disabled Windows Firewall Rules
        Notes:

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -Type 'All' -AllProperties
        Description: Report on all All Windows Firewall Rules
        Notes:

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -UseCache
        Description: Cache found objects to disk to not over tax Memory resources
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -UseCache -RemoveCache
        Description: Remove Cache data
        Notes: By default the Cache information is removed right before the data is returned to the caller

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -UseCache -CachePath $Env:Temp
        Description: Change the Cache path to the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -UseCache -ClearGarbageCollecting
        Description: Scan large directories and limit the memory used to track data
        Notes:

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
                Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the ForMat

    .EXAMPLE
        Command: Get-BluGenieFirewallRules -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : Michael Arroyo
        • Original Build Version    : 1809.1501
        • Latest Author             : Ravi Vinod Dubey & Michael Arroyo
        • Latest Build Version      : 21.02.2201
        • Comments                  :
        • Dependencies              :
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
    ~ 1809.1501:• [Michael Arroyo] Posted
    ~ 1902.0501:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
    ~ 1911.0101:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                • [Michael Arroyo] Added more detailed information to the Return data
    ~ 21.02.2201• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                • [Michael Arroyo] Moved Build Notes out of General Posh Help section
                • [Ravi Vinod Dubey] Added support for Caching
                • [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
                • [Ravi Vinod Dubey] Added support for SQLite DB
                • [Ravi Vinod Dubey] Added support for OutYaml
                • [Ravi Vinod Dubey] Updated Process Query and Filtering
                • [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                    unless you manually set the -Verbose parameter.
                • [Ravi Vinod Dubey] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-FirewallRules','Get-BGFirewallRules')]
    #region Parameters
        Param
        (
            [Parameter(Position=0)]
            [ValidateSet('Enabled','Disabled','All')]
            $Type = 'Enabled',

            [Parameter(Position = 1)]
            [Switch]$AllProperties,

            [Parameter(Position = 2)]
            [string]$RuleName = '.*',

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
        $HashReturn['GetFirewallRules'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetFirewallRules'].StartTime = $($StartTime).DateTime
        $HashReturn['GetFirewallRules']['Rulenames'] = @()
        $HashReturn['GetFirewallRules'].ParsedCount = 0
		$HashReturn['GetFirewallRules'].Count = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetFirewallRules'].ParameterSetResults = $PSBoundParameters
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
				$HSqlite.TableName = 'BGFirewallRule'
			#endregion Table Name

			#region Set Column Information
				$HSqlite.TableColumns = " Name  TEXT,
                    Description        			TEXT,
                    ApplicationName    			TEXT,
                    serviceName 		 		TEXT,
                    Protocol  		 			INTEGER,
                    LocalPorts 		 			INTEGER,
                    RemotePorts		 			TEXT,
                    LocalAddresses     			TEXT,
                    RemoteAddresses 	 		TEXT,
                    IcmpTypesAndCodes  			TEXT,
                    Direction 		 			INTEGER,
                    Interfaces 					TEXT,
                    InterfaceTypes     			TEXT,
                    Enabled 			 		TEXT ,
                    Grouping     				TEXT,
                    Profiles  		 			INTEGER,
                    EdgeTraversal  	 			TEXT,
                    Action 		 	 			INTEGER,
                    EdgeTraversalOptions 		TEXT,
                    LocalAppPackageId   		TEXT,
                    LocalUserOwner        		TEXT,
                    LocalUserAuthorizedList     TEXT,
                    RemoteUserAuthorizedList    TEXT,
                    RemoteMachineAuthorizedList TEXT,
                    SecureFlags 				TEXT"
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
        $objFirewall = New-object -comObject HNetCfg.FwPolicy2

        $HashReturn['GetFirewallRules'].ParsedCount =  $objFirewall.Rules.Count #ParsedCount

        $ArrTempData = @()
            $objFirewall.Rules | ForEach-Object `
            -Process `
            {
                $CurRuleName = $_

                If
                (
                    $CurRuleName.Name -match $RuleName
                )
                {
                    switch
                    (
                        $Type
                    )
                    {
                        'enabled'
                        {
                            if
                            (
                                $CurRuleName.Enabled -eq $true
                            )
                            {
                                #region Setup Caching
                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        '---' | Out-File -FilePath $CachePath -Append -Force
                                        $($CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv) | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                    }
                                    Else
                                    {
                                        $ArrTempData += $CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv
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
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }
                                #endregion Setup Caching
                            }

                            $CurRuleName = $null
                        }

                        'disabled'
                        {
                            if
                            (
                                $CurRuleName.Enabled -eq $false -or $CurRuleName.Enabled -eq $null -or $CurRuleName.Enabled -eq ''
                            )
                            {
                                #region Setup Caching
                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        '---' | Out-File -FilePath $CachePath -Append -Force
                                        $($CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv)| ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                    }
                                    Else
                                    {
                                        $ArrTempData += $CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv
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
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }
                                #endregion Setup Caching
                            }

                            $CurRuleName = $null
                        }

                        'all'
                        {
                            if
                            (
                                $CurRuleName
                            )
                            {
                                #region Setup Caching
                                    If
                                    (
                                        $UseCache
                                    )
                                    {
                                        '---' | Out-File -FilePath $CachePath -Append -Force
                                        $($CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv)| ConvertTo-Yaml | Out-File $CachePath -Append -Force
                                    }
                                    Else
                                    {
                                        $ArrTempData += $CurRuleName | ConvertTo-Csv -NoTypeInformation | ConvertFrom-Csv
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
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
                                        }
                                        Else
                                        {
                                            Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurRuleName | `
                                                Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                                        }
                                    }
                                #endregion Setup Caching
                            }

                            $CurRuleName = $null
                        }
                    }
                }
            }

            #region Rules Count
                If
                (
                    $ArrTempData
                )
                {
                    $HashReturn['GetFirewallRules']['Rulenames'] += $ArrTempData
                }
                ElseIf
                (
                    $UseCache
                 )
                {
                    $HashReturn['GetFirewallRules']['Rulenames'] += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
                }

                $HashReturn['GetFirewallRules'].Count = $($HashReturn['GetFirewallRules']['Rulenames'] | Measure-Object | Select-Object -ExpandProperty Count)
            #endregion Rules Count

            #region Cleanup
				$objFirewall = $null
                $ArrTempData = $null

				If
				(
					$ClearGarbageCollecting
				)
				{
					$null = Clear-BlugenieMemory
				}
            #endregion CleanUp
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetFirewallRules'].EndTime = $($EndTime).DateTime
        $HashReturn['GetFirewallRules'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
			Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		If
		(
			-Not $($VerbosePreference -eq 'Continue')
		)
		{
			#Remove Hash Properties that are not needed without Verbose enabled.
			$null = $HashReturn['GetFirewallRules'].Remove('StartTime')
			$null = $HashReturn['GetFirewallRules'].Remove('ParameterSetResults')
			$null = $HashReturn['GetFirewallRules'].Remove('CachePath')
			$null = $HashReturn['GetFirewallRules'].Remove('EndTime')
			$null = $HashReturn['GetFirewallRules'].Remove('ElapsedTime')
		}

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

		#region Output Type
			$ResultSet = $($HashReturn['GetFirewallRules']['Rulenames'])

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
						Return $($($HashReturn| ConvertTo-Yaml))
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
#endregion Get-BluGenieFirewallRules (Function)