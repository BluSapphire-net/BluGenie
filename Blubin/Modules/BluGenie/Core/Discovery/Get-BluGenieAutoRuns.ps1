#region Get-BluGenieAutoRuns (Function)
Function Get-BluGenieAutoRuns
{
<#
    .SYNOPSIS
        Get-BluGenieAutoRuns reports on what programs are configured to run during system bootup or login

    .DESCRIPTION
        Get-BluGenieAutoRuns reports on what programs are configured to run during system bootup or login, and when you start various built-in
        Windows applications like Internet Explorer, Explorer and media players. These programs and drivers include ones
        in your startup folder, Run, RunOnce, and other Registry keys.

    .PARAMETER ToolPath
        Description: ToolPath for the AutoRunSC.exe
        Notes: The default ToolPath is ( .\Tools\SysinternalsSuite ) with a backup path of ( $env:Windir\Temp )
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
        Notes:  This will slow down the query
        Alias:
        ValidateSet: 
		
	.PARAMETER HideSigned
        Description: Hide signed files to help quickly identify 3rd party or unsigned entries 
        Notes:  
        Alias:
        ValidateSet: 'Item1','Item2','Item3' 

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
	    Command: Get-BluGenieAutoRuns
        Description: Report on currently configured auto-start applications as well as the full list of Registry and file system locations available for auto-start configuration
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieAutoRuns -Algorithm SHA256
        Description: Report on currently configured auto-start information, also display the Hash Algorithm in "SHA256"
        Notes: The Hash Algorithm will be set to "SHA256".  The default is "MD5"
		
	.EXAMPLE
	    Command: Get-BluGenieAutoRuns -Signature -HideSigned Microsoft
        Description: Report on currently configured auto-start information that do not have an Authorized Signature from Microsoft.
        Notes: This report will quickly identify any 3rd party or unsigned entries.
			   To display Signature information you need to use the (-Signature) switch
		
	.EXAMPLE
	    Command: Get-BluGenieAutoRuns -Signature -HideSigned All
        Description: Report on currently configured auto-start information that do not have an Authorized Signature.
        Notes: This report will quickly identify any 3rd party or unsigned entries.
			   To display Signature information you need to use the (-Signature) switch
		
	.EXAMPLE
	    Command: Get-BluGenieAutoRuns -Signature
        Description: Report on currently configured auto-start information with Authorized Signature Information.
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieAutoRuns -ToolPath 'C:\Temp\AutoRunSC.exe'
        Description: Locate the AutoRun tool under C:\Temp and Report on currently configured auto-start information
        Notes: 

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -UseCache
        Description: Cache found objects to disk to not over tax Memory resources
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -UseCache -RemoveCache
        Description: Remove Cache data
        Notes:

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -SearchPath Temp -Recurse -UseCache -CachePath $Env:Temp
        Description: Change the Cache path to the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -UseCache -ClearGarbageCollecting
        Description: Scan large directories and limit the memory used to track data
        Notes:

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -UpdateDB
        Description: Search every user and system Temp directory for all normal file information including hash and save the return to a DB
        Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie


    .EXAMPLE
	    Command: Get-BluGenieAutoRuns -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieAutoRuns -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieAutoRuns -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieAutoRuns -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -SearchPath Temp -Recurse -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -SearchPath Temp -Recurse -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        This parameter is also used with the ForMat

    .EXAMPLE
        Command: Get-BluGenieAutoRuns -SearchPath Temp -Recurse -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml', 'XML')
     Default is set to (None) and normal PSObject.


    .OUTPUTS
        TypeName: System.Collections.Hashtable
		
		- Sample Data -
            Time                  : 8/20/2018 4:09 PM
            Entry Location        : HKLM\Software\Wow6432Node\Microsoft\Office\Excel\Addins
            Entry                 : Connect Class
            Enabled               : enabled
            Category              : Office Addins
            Profile               : System-wide
            Description           : TFSOfficeAdd-in.dll
            Company               : Microsoft Corporation
            Image Path            : c:\program files\common files\microsoft shared\team foundation server\15.0\x86\tfsofficeadd-in.dll
            Version               : 15.129.28020.1
            Launch String         : HKCR\CLSID\{5DC1CC51-2694-47CD-B7B7-21363388FFFC}
            Hash                  : d877ffaced4067cf99c85b79165929fdab2c80b32100539f12efb790b99922b0
            Signature_Comment     :
            Signature_FileVersion : 11.00.17134.471 (WinBuild.160101.0800)
            Signature_Description : Internet Browser
            Signature_Date        : 3:35 AM 12/9/2018
            Signature_Company     : Microsoft Corporation
            Signature_Publisher   : Microsoft Windows
            Signature_Verified    : Signed

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1910.1001
        * Latest Author             : Dubey Ravi Vinod
        * Latest Build Version      : 21.02.2301
        * Comments                  :
        • Dependencies              :
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o  New-BluGenieUID or New-UID - Create a New UID
            o  ConvertTo-Yaml - ConvertTo Yaml
            o  Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o  ConvertFrom-Yaml - Convert From Yaml
            o  Invoke-SQLiteBulkCopy - Inject Bulk data into a SQL Lite Database

#region Build Notes

<#

    ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    ~ 1809.1501:• [Michael Arroyo] Posted
    ~ 1902.0501:• [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
    ~ 1911.0101:• [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                • [Michael Arroyo] Added more detailed information to the Return data
    ~ 21.02.2201• [Ravi Vinod Dubey] Moved Build Notes out of General Posh Help section
                • [Ravi Vinod Dubey] Added support for Caching
                • [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
                • [Ravi Vinod Dubey] Added support for SQLite DB
                • [Ravi Vinod Dubey] Updated Process Query and Filtering
                • [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                    unless you manually set the -Verbose parameter.
                • [Ravi Vinod Dubey] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                • [Ravi Vinod Dubey] Change the script to check the AutoRuns tools in ..\Tools\SysinternalsSuite\
#>
#endregion Build Notes


    [cmdletbinding()]
    [Alias('Get-AutoRuns')]
    Param
    (
        [Parameter(Position = 0)]
        [string]$ToolPath = $(Join-Path -Path $ToolsDirectory -ChildPath 'SysinternalsSuite'),

        [Parameter(Position=1)]
        [ValidateSet("MACTripleDES", "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]$Algorithm = "MD5",
		
		[Parameter(Position = 2)]
        [switch]$Signature,

        [Parameter(Position = 3)]
        [ValidateSet('Microsoft','All')]
        [string]$HideSigned,

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
        $HashReturn['GetAutoRuns'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetAutoRuns'].StartTime = $($StartTime).DateTime
        $HashReturn['GetAutoRuns']['AutoRunItems'] = @()
		$HashReturn['GetAutoRuns']['AutoRunTotal'] = $null
		$HashReturn['GetAutoRuns']['ToolCheck'] = $false
		$HashReturn['GetAutoRuns']['ToolPath'] = $null
        $HashReturn['GetAutoRuns'].ParsedCount = 0
		$HashReturn['GetAutoRuns'].Count = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetAutoRuns'].ParameterSetResults = $PSBoundParameters
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

            {$ForceDBUpdate}
            {
                $UpdateDB = $true
            }

            {$NewDBTable}
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
				$HSqlite.TableName = 'BGAutoRuns'
			#endregion Table Name

			#region Set Column Information
				$HSqlite.TableColumns = "Entry_Location  TEXT,
                    Entry                 TEXT,
                    Hash                  TEXT,
                    TIME                  TEXT,
                    Enabled               TEXT,
                    Category              TEXT,
                    Profile               TEXT,
                    Description           TEXT,
                    Company               TEXT,
                    Image_Path            TEXT,
                    Version               TEXT,
                    Launch_String         TEXT,
                    Signature_Comment     TEXT, 
                    Signature_FileVersion TEXT, 
                    Signature_Description TEXT, 
                    Signature_Date        TEXT, 
                    Signature_Company     TEXT, 
                    Signature_Publisher   TEXT, 
                    Signature_Verified    TEXT"


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

				Invoke-SqliteQuery -DataSource $HSqlite.Database -Query   $HSqlite.CreateTableStr
			#endregion Create DB Table
		}
	#endregion Build Data Table Hash Table

	#region Tool Check
        $Error.Clear()
		$ArrToolPath = @(
			$($ToolPath +'\' + 'AutoRunSc.exe'),
	        $('{0}\AutoRunSc.exe' -f $(Get-LiteralPath -Path $($BGTools | Where-Object -FilterScript { $_.'Name' -eq 'AutoRunSc.exe' } | Select-Object -ExpandProperty RemoteDestination) -ErrorAction SilentlyContinue)),
			$($ToolsConfig.CopyTools  | Where-Object -FilterScript { $_.'Name' -eq 'AutoRunSc.exe' } | Select-Object -ExpandProperty FullPath),
			$('{0}\Windows\Temp\AutoRunSc.exe' -f $env:SystemDrive),
			$('{0}\AutoRunSc.exe' -f $env:Temp),
			'..\Tools\SysinternalsSuite\AutoRunSc.exe'
		)

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
					$HashReturn['GetAutoRuns']['ToolPath'] = $CurToolPath
					$HashReturn['GetAutoRuns']['ToolCheck'] = $true
					Break
				}
			}
		}

    #endregion Tool Check

    #region Main

        $ArrTempData = @()
        
		If
		(
			$HashReturn['GetAutoRuns']['ToolCheck']
		)
		{
		    #region Pull Main AutoRun information
		    Try
		    {
		        $AutoRunOptions = '-nobanner -accepteula -a * -c' #NoBanner, Export to CSV
		        $AutoRunObj = Invoke-Expression -Command $('{0} {1}' -f $CurToolPath,$AutoRunOptions) -ErrorAction SilentlyContinue | ConvertFrom-Csv -ErrorAction SilentlyContinue
		    }
		    Catch
		    {
		    }
		    #endregion Pull Main AutoRun information
			   
			#region Add Hash Information to Object

            $HashReturn.GetAutoRuns.ParsedCount = $AutoRunObj | Measure-Object -ErrorAction Stop  | `
			Select-Object -ExpandProperty 'Count' -ErrorAction Stop
		   
            $AutoRunObj | ForEach-Object `
		    -Process `
		    {
		        $CurHashItem = $_
		        $CurHashItem | Add-Member -MemberType NoteProperty -Name Hash -Value $(Get-HashInfo -Path $(Get-LiteralPath -Path $CurHashItem.'Image Path' -ErrorAction SilentlyContinue) -Algorithm $Algorithm -ErrorAction SilentlyContinue) -Force -ErrorAction SilentlyContinue
                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Entry_Location' -Value $($CurHashItem.'Entry Location') -Force -ErrorAction SilentlyContinue
                $CurHashItem.PSObject.Properties.Remove('Entry Location')
                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Image_Path' -Value $($CurHashItem.'Image Path') -Force -ErrorAction SilentlyContinue
                $CurHashItem.PSObject.Properties.Remove('Image Path')
                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Launch_String' -Value $($CurHashItem.'Launch String') -Force -ErrorAction SilentlyContinue
                $CurHashItem.PSObject.Properties.Remove('Launch String')

                #region Process Signature Information
		        If
		        (
		            $Signature
		        )
                {		                  
		            Try
		            {
		                $CurSignature = $(Get-Signature -Path $(Get-LiteralPath -Path $CurHashItem.'Image_Path' -ErrorAction Stop) -Algorithm $Algorithm)
                        $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Comment' -Value $($CurSignature).Comment -Force -ErrorAction SilentlyContinue
		                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_FileVersion' -Value $($CurSignature).'File Version' -Force -ErrorAction SilentlyContinue
		                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Description' -Value $($CurSignature).Description -Force -ErrorAction SilentlyContinue
		                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Date' -Value $($CurSignature).Date -Force -ErrorAction SilentlyContinue
		                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Company' -Value $($CurSignature).Company -Force -ErrorAction SilentlyContinue
		                $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Publisher' -Value $($CurSignature).Publisher -Force -ErrorAction SilentlyContinue
                                
		                If
		                (
		                    $($CurSignature).Verified
		                )
		                {
		                    $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' -Value $($CurSignature).Verified -Force -ErrorAction SilentlyContinue
		                }
		                Else
		                {
		                    $CurHashItem | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' -Value 'N/A' -Force -ErrorAction SilentlyContinue
		                }
                                
		            }
		            Catch
		           {
                       $CurSignature = $null
		           }                               
               }
               #endregion Process Signature Information


               #region Setup Caching
					   
			    If
			    (
	         	    $UseCache
		        )
			    {
			        '---' | Out-File -FilePath $CachePath -Append -Force
				    $CurHashItem | ConvertTo-Yaml | Out-File $CachePath -Append -Force
	            }
			    Else
			    {
				    $ArrTempData += $CurHashItem
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
					    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurHashItem | `
					    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false  -ConflictClause Replace
					}
					Else
					{
					    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable $($CurHashItem | `
					    Out-DataTable) -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
					}
				 }

				$CurHashItem = $null
			  #endregion Setup Caching 
             }              
		            
		    #endregion Add Hash Information to Object

            #region Service Count
		    If
		    (
			    $ArrTempData
            )
	        {
	            $HashReturn['GetAutoRuns']['AutoRunItems'] += $ArrTempData
	        }
		    ElseIf
		    (
			    $UseCache
		    )
		    {
			    $HashReturn['GetAutoRuns']['AutoRunItems'] += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
		    }
            $HashReturn['GetAutoRuns'].Count = $($HashReturn['GetAutoRuns']['AutoRunItems'] | Measure-Object | Select-Object -ExpandProperty Count)
           #endregion Service Count

           #region Cleanup
	           $AutoRunObj = $null
               $ArrTempData = $null
               If
		       (
		           $ClearGarbageCollecting
		       )
		       {
			       $null = Clear-BlugenieMemory
		       }
		    #endregion Cleanup
		#endregion Process Signature Information
		  }
          
    #endregion Main

     #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetAutoRuns'].EndTime = $($EndTime).DateTime
        $HashReturn['GetAutoRuns'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['GetAutoRuns'].Remove('StartTime')
            $null = $HashReturn['GetAutoRuns'].Remove('ParameterSetResults')
            $null = $HashReturn['GetAutoRuns'].Remove('CachePath')
            $null = $HashReturn['GetAutoRuns'].Remove('EndTime')
            $null = $HashReturn['GetAutoRuns'].Remove('ElapsedTime')
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

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = $HashReturn['GetAutoRuns']['AutoRunItems']

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
#endregion Get-BluGenieAutoRuns (Function)