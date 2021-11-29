#region Get-BluGenieCOMObjectInfo (Function)
Function Get-BluGenieCOMObjectInfo
{
<#
    .SYNOPSIS
        Get-BluGenieCOMObjectInfo will query for possible COM Object HiJacking.

    .DESCRIPTION
        Get-BluGenieCOMObjectInfo will query for possible COM Object HiJacking.  The process searches for .dll and .exe files that can be HiJacked using the registry CLSID.

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
        Description: Filter by Property Type 
        Notes:  
				Filter Option = "ComponentId"			-   Com Object ID
                Filter Option = "Caption"				-   Display name
                Filter Option = "KeyRoot"				-   Parent / Root Registry Key Path
                Filter Option = "Type"					-   Key Type ( InprocServer32 | LocalServer32 )
                Filter Option = "KeyPath"				-   Full Registry Key Path
                Filter Option = "KeyValue"				-   Value from the Full Registry Key Path
                Filter Option = "FilePath"				-   Full Name and Path of the file nested in the Registry Key Value
                Filter Option = "Arguments"				-   Associated Arguments for the command
                Filter Option = "Hash"					-   The Hash value of the Process ( MACTripleDES / MD5 / RIPEMD160 / SHA1 / SHA256 / SHA384 / SHA512 ) 
                Filter Option = "OnDisk"				-   Is the file located on disk ( True / False )
                Filter Option = "Signature_Comment"		-   Display error message while pulling Signature Information [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_FileVersion" -   File Version and OS Build information in part of the OS [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_Description" -   The description of the files signature [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_Date"		-   Date when the file was signed [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_Company"		-   The company signing the file [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_Publisher"	-   The Publisher signing the file [Note:  This is only available if you use the -Signature switch]
                Filter Option = "Signature_Verified"	-   Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use the -Signature switch]
        Alias:
        ValidateSet: 'Type','ComponentId','Caption','KeyRoot','KeyPath','KeyValue','FilePath','Arguments','OnDisk','Hash','Signature_Comment','Signature_FileVersion','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified'

    .PARAMETER COMType
        Description: Select which type of COM Object to search for
        Notes: 
				* InprocServer32
                * LocalServer32
        Alias:
        ValidateSet: 'InprocServer32','LocalServer32','All'
		
	.PARAMETER Pattern
		Description: Search Pattern using RegEx 
		Notes: Default Value = '.*' 
		Alias:
		ValidateSet: 
		
	.PARAMETER NotMatch
		Description: Show only results that do not match the given Pattern 
		Notes:  
		Alias:
		ValidateSet:  

	.PARAMETER Signature
		Description: Query Signature information 
		Notes:  
		Alias:
		ValidateSet:  

	.PARAMETER ResolveRegKeyPaths
		Description: Identify and resolve the Component ID to the parent registry key. 
		Notes: This slows down the query process and is disabled by default. 
		Alias:
		ValidateSet:  

	.PARAMETER TryToResolvePath
		Description: Query the $env:windir for the file that does not have a defined path in the Registry by default. 
		Notes: This slows down the query process and is disabled by default.
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

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo
        Description: Return all COM objects that have a value for InprocServer32 or LocalServer32
        Notes: The default Hash Algorithm is (MD5)

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo -Signature  -Algorithm SHA256
        Description: Return all COM objects, process Signature Authentication Information and set the Hash Algorithm to (SHA256)
        Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -Signature -FilterType Signature_Verified -NotMatch -Pattern '^Signed'
		Description: Filter type by (Signature_Verified) with a value not like 'Signed'
		Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -Pattern '7-Zip'
		Description: Filter type by (Caption) with a value like '7-Zip'
		Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -TryToResolvePath
		Description: Resolve path for any file not identiifed in the registry.  The search path is $env:windir and all sub directories.
		Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -TryToResolvePath -ResolveRegKeyPaths
		Description: Resolve the root registry key and the parent registry key paths
		Notes: This will slow the process down.  Most of the time this information is not needed.  By default this option is not set

	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -TryToResolvePath -FilterType OnDisk -NotMatch -Pattern 'True'
		Description: Query for any InprocServer32 or LocalServer32 Object references that have not been located on the local system disk.
		Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -FilterType ComponentId -Pattern '{581b6888-ba70-3d90-a5f9-865f03d29c6b1}'
		Description: Query for a Component ID
		Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieCOMObjectInfo -TryToResolvePath -FilterType Hash -Pattern '5808c2e483c1e42bdd69d8227e80b96f|7a53101d82f382fcbc883b485b01f4e4|a54e980e453ed712a6ecf639ca70f4db'
		Description: RegEx pattern to search for several instances
		Notes: 

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo -OutUnEscapedJSON
        Description: Return all COM objects that have a value for InprocServer32 or LocalServer32 and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieCOMObjectInfo -ReturnObject
        Description: Return all COM objects that have a value for InprocServer32 or LocalServer32 and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1910.1001
        * Latest Author             : Michael Arroyo 
        * Latest Build Version      : 1912.1201
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
        * Build Version Details     :
                                        ~ 1901.2701: * [Michael Arroyo] Posted
                                        ~ 1903.1201: * [Michael Arroyo] Added external call to New-TimeStamp for logging
                                                     * [Michael Arroyo] Added external call to Get-LoadedRegHives to query all the loaded users hives
                                                     * [Michael Arroyo] Removed the Argument split from the InprocServer32.  This was causing issues.
                                        ~ 1903.1202: * [Michael Arroyo] Added more error trapping
                                                     * [Michael Arroyo] Added the ReturnObject switch to return only Object data (no JSON report)
                                        ~ 1906.1701: * [Michael Arroyo] Added the OutUnEscapedJSON switch to return an UnEscaped JSON file.
                                                     * [Michael Arroyo] Removed the ExactMatch switch.  The process will use RegEx only.
                                                     * [Michael Arroyo] Update the Walkthrough function to (Ver: 1905.2401)
                                                     * [Michael Arroyo] Rebuilt the ComObject Query to be faster
                                                     * [Michael Arroyo] Added a Start, End, and Time Span entry in the JSON Report
                                                     * [Michael Arroyo] Added the Parameter Set Results query to the JSON Report
                                                     * [Michael Arroyo] Added the Parameter ResolveRegKeyPaths which will identify and resolve the Component ID to the parent registry key.
                                                     * [Michael Arroyo] Added the Parameter TryToResolvePath which will query the $env:windir for the file that does not have a defined path in the Registry by default.
                                                     * [Michael Arroyo] Updated the FilterType Parameter.
                                                     * [Michael Arroyo] Added new file idendtifiers to the COM search list (*.exe, *.dll, *.ax, *.cpl, *.ocx).  Previsouly it was just (*.exe, & *.dll).
                                                     * [Michael Arroyo] Updated Help Examples
                                        ~ 1906.1702: * [Michael Arroyo] Updated the default path for Where.exe.  On some clients the default path is corrupt.
                                        ~ 1906.1704: * [Michael Arroyo] Added utility data capturing for Where.exe
                                                     * [Michael Arroyo] Updated the default path for Where.exe.  The path is still not found when using $env:windir.  Updated to $env:systemdrive\Windows.
                                        ~ 1907.0801: * [Michael Arroyo] Updated the Where.exe process to only look for the file name.  When an item isn't found it was pull the entire string.  The string can still be a path and it would fail to search correctly.
                                                     * [Micahel Arroyo] Added error management to the Command Where.exe.
										~ 1912.0801: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
													 * [Michael Arroyo] Updated the Hash Information to follow the new function standards
													 * [Michael Arroyo] Added more detailed information to the Return data
													 * [Michael Arroyo] Forced Type Cast "OnDisk" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Verified" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Caption" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Hash" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Comment" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_FileVersion" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Description" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Date" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Company" to [Text] to support Elastic Search
													 * [Michael Arroyo] Forced Type Cast "Signature_Publisher" to [Text] to support Elastic Search
										~ 1912.1201: * [Michael Arroyo] Removed RuleNames from the Return Hash Table
#>
    [cmdletbinding()]
    [Alias('Get-COMObjectInfo')]
    Param
    (
        [Parameter(Position = 0)]
        [ValidateSet('Type','ComponentId','Caption','KeyRoot','KeyPath','KeyValue','FilePath','Arguments','OnDisk','Hash','Signature_Comment','Signature_FileVersion','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified')]
        [string]$FilterType = 'Caption',

        [Parameter(Position = 1)]
        [string]$Pattern = '.*',

		[Parameter(Position = 2)]
        [ValidateSet('InprocServer32','LocalServer32','All')]
        [string]$COMType = 'All',

		[Parameter(Position=3)]
        [ValidateSet("MACTripleDES", "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]$Algorithm = "MD5",
		
        [switch]$NotMatch,

        [switch]$Signature,

        [Switch]$ResolveRegKeyPaths,

        [Switch]$TryToResolvePath,

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject,

        [Switch]$OutUnEscapedJSON
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
        $HashReturn['COMObjectList'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['COMObjectList'].StartTime = $($StartTime).DateTime
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['COMObjectList'].ParameterSetResults = $PSBoundParameters
		$HashReturn.COMObjectList.ParameterSetResults += @{
                            'SearchPath' = $('{0}\Windows\System32' -f $env:SystemDrive)
                            'Utilities Found' = $(Test-Path -Path $('{0}\Windows\System32\Where.exe' -f $env:SystemDrive) -ErrorAction SilentlyContinue)
                        }
    #endregion Parameter Set Results
	
	#region Check Pattern Value
        If
        (
            -Not $Pattern
        )
        {
            Return
        }
    #endregion Check Pattern Value
	
	#region Setup Registry Hives for PSProvider
        New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue | Out-Null
        New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -ErrorAction SilentlyContinue | Out-Null
        New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue | Out-Null
    #endregion Setup Registry Hives for PSProvider

    #region Main
        #region Build CLSID Registry Key List
	        $CLSIDRoot = @()
	        $CLSIDRoot += Get-ChildItem -path HKLM:\SOFTWARE\Classes\CLSID -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name

	        $LoadedHives = Get-LoadedRegHives -ReturnObject -ErrorAction SilentlyContinue
	        $LoadedHives.UserName | ForEach-Object `
	        -Process `
	        {
	            $CurHKU = $_
	            $CLSIDRoot += Get-ChildItem -Path $('HKU:\{0}\SOFTWARE\Classes\CLSID' -f $CurHKU) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
	        }
	    #endregion Build CLSID Registry Key List

	    #region Query COM Settings
	        $ArrInprocServer32 = @()
	        $ArrLocalServer32 = @()
	        $ComObjects = Get-WmiObject -Class Win32_COMSetting -ErrorAction SilentlyContinue
	        
	        $ComObjects | ForEach-Object `
	        -Process `
	        {
	            $CurObject = $_

	            Switch
	            (
	                $Null
	            )
	            {
	                {$CurObject.InprocServer32 -ne $null}
	                {
	                    $ArrInprocServer32 += $CurObject | Select-Object -Property @{Name='Type';Expression={'InprocServer32'}},
	                                                    ComponentId,
	                                                    Caption,
	                                                    @{
	                                                        Name = 'KeyRoot'
	                                                        Expression = 
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'KeyPath'
	                                                        Expression = 
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'KeyValue'
	                                                        Expression =
	                                                        {
	                                                            $($CurObject.InprocServer32)
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'FilePath'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Arguments'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'OnDisk'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Hash'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Comment'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_FileVersion'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Description'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Date'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Company'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Publisher'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Verified'
	                                                        Expression =
	                                                        {
	                                                           'False'
	                                                        }
	                                                    }
	                                                    
	                }
	                {$CurObject.LocalServer32 -ne $null}
	                {
	                    $ArrLocalServer32 += $CurObject | Select-Object -Property @{Name='Type';Expression={'LocalServer32'}},
	                                                    ComponentId,
	                                                    Caption,
	                                                    @{
	                                                        Name = 'KeyRoot'
	                                                        Expression = 
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'KeyPath'
	                                                        Expression = 
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'KeyValue'
	                                                        Expression =
	                                                        {
	                                                            $($CurObject.LocalServer32)
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'FilePath'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Arguments'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'OnDisk'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Hash'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Comment'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_FileVersion'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Description'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Date'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Company'
	                                                        Expression =
	                                                        {
	                                                            ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Publisher'
	                                                        Expression =
	                                                        {
	                                                           ''
	                                                        }
	                                                    },
	                                                    @{
	                                                        Name = 'Signature_Verified'
	                                                        Expression =
	                                                        {
	                                                           'False'
	                                                        }
	                                                    }
	                }
	            }
	        }
	    #endregion Query COM Settings

	    #region Build Object - InprocServer32
	        If
	        (
	            $($COMType -eq 'All') -or $($COMType -eq 'InprocServer32')
	        )
	        {
	            $ArrInprocServer32 | ForEach-Object `
	            -Process `
	            {
	                $CurCLSID = $_

	                #region Resolve Registry Key Paths
	                    If
	                    (
	                        $ResolveRegKeyPaths
	                    )
	                    {
	                        $CurCLSID.KeyRoot = $($($CLSIDRoot | Select-String -SimpleMatch $CurCLSID.ComponentId | Out-String).Trim())
	                        $CurCLSID.KeyPath = $('{0}\InprocServer32' -f $($CLSIDRoot | Select-String -SimpleMatch $CurObject.ComponentId))
	                    }
	                #endregion Resolve Registry Key Paths

	                #region Parse FilePath
	                    $CurCLSIDLiteralPath = Get-LiteralPath -Path $CurCLSID.KeyValue.ToLower()
	                    
	                    Switch
	                    (
	                        $Null
	                    )
	                    {
	                        {$CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w\w'}
	                        {
	                            $null = $CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w\w'
	                            $RegExFilePath = $Matches[0]
	                            $Matches = $null
	                                
	                            Switch
	                            (
	                                $null
	                            )
	                            {
	                                {$RegExFilePath -match '(^.*?\.dll)'}
	                                {
	                                    $null = $RegExFilePath -match '(^.*?\.dll)'
	                                    $CurCLSID.FilePath = $Matches[0]
	                                    $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                    $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                    $Matches = $null
	                                    break
	                                }
	                                {$RegExFilePath -match '(^.*?\.exe)'}
	                                {
	                                    $null = $RegExFilePath -match '(^.*?\.exe)'
	                                    $CurCLSID.FilePath = $Matches[0]
	                                    $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                    $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                    $Matches = $null
	                                    break
	                                }
	                                {$RegExFilePath -match '(^.*?\.cpl)'}
	                                {
	                                    $null = $RegExFilePath -match '(^.*?\.cpl)'
	                                    $CurCLSID.FilePath = $Matches[0]
	                                    $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                    $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                    $Matches = $null
	                                    break
	                                }
	                                {$RegExFilePath -match '(^.*?\.ocx)'}
	                                {
	                                    $null = $RegExFilePath -match '(^.*?\.ocx)'
	                                    $CurCLSID.FilePath = $Matches[0]
	                                    $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                    $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                    $Matches = $null
	                                    break
	                                }
	                            }
	                            break
	                        }
	                        {$CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w'}
	                        {
	                            $null = $CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w'
	                            $RegExFilePath = $Matches[0]
	                            $Matches = $null
	                            If
	                            (
	                                $RegExFilePath -match '(^.*?\.ax)'
	                            )
	                            {
	                                $null = $RegExFilePath -match '(^.*?\.ax)'
	                                $CurCLSID.FilePath = $Matches[0]
	                                $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                $Matches = $null
	                            }
	                            break
	                        }
	                        Default
	                        {
	                        }
	                    }
	                #endregion Parse FilePath

	                #region OnDisk Check
	                    Try
	                    {
	                        $null = Get-Item -Path $CurCLSID.FilePath -Force -ErrorAction Stop
	                        $CurCLSID.OnDisk = 'True'
	                    }
	                    Catch
	                    {
	                        If
	                        (
	                            $TryToResolvePath
	                        )
	                        {
	                            $RedirectErrOutput = $('{0}\{1}' -f $env:TEMP, $(New-UID -ErrorAction SilentlyContinue))
	                            $TryPath = Invoke-Expression -Command $( $('{0}\Windows\System32\cmd.exe /c {0}\Windows\System32\Where.exe /R {0}\Windows {1} 2`> {2}' -f $env:SystemDrive, $($CurCLSID.FilePath | Split-Path -Leaf -ErrorAction SilentlyContinue), $RedirectErrOutput) ) -ErrorAction SilentlyContinue | Select-Object -First 1
	                            $null = Remove-Item -Path $RedirectErrOutput -Force -ErrorAction SilentlyContinue
	                            $Error.Clear()
	                            If
	                            (
	                                $TryPath
	                            )
	                            {
	                                $CurCLSID.OnDisk = 'True'
	                                $CurCLSID.FilePath = $TryPath
	                            }
	                            Else
	                            {
	                                $CurCLSID.OnDisk = 'False'
	                            }
	                        }
	                        Else
	                        {
	                            $CurCLSID.OnDisk = 'False'
	                        }
	                    }
	                #endregion OnDisk Check

	                #region Hash Check
	                    If
	                    (
	                        $CurCLSID.OnDisk
	                    )
	                    {
	                        $CurCLSID.Hash = $(Get-HashInfo -Path $CurCLSID.FilePath -Algorithm $Algorithm -ErrorAction SilentlyContinue)
	                    }
	                #endregion Hash Check

	                #region Signature Check
	                    If
	                    (
	                        $Signature
	                    )
	                    {
	                        Try
	                        {
	                            $CurSignature = $(Get-Signature -Path $CurCLSID.FilePath -Algorithm $Algorithm -ErrorAction SilentlyContinue)
	                        }
	                        Catch
	                        {
	                        }   

	                        $CurCLSID.Signature_Comment = $($CurSignature).Comment
	                        $CurCLSID.Signature_FileVersion = $($CurSignature).'File Version'
	                        $CurCLSID.Signature_Description = $($CurSignature).Description
	                        $CurCLSID.Signature_Date = $($CurSignature).Date
	                        $CurCLSID.Signature_Company = $($CurSignature).Company
	                        $CurCLSID.Signature_Publisher = $($CurSignature).Publisher

	                        If
	                        (
	                            $($CurSignature).Verified
	                        )
	                        {
	                            $CurCLSID.Signature_Verified = $($CurSignature).Verified
	                        }
	                    }
	                #endregion Signature Check
					
					#region Fix Type Casting
						switch
						(
							$null
						)
						{
							#ReCheck the Caption Property
							{ $CurCLSID.Caption -eq $null }
							{
								$CurCLSID.Caption = ''
							}
							#ReCheck the Hash Property
							{ $CurCLSID.Hash -eq $null }
							{
								$CurCLSID.Hash = ''
							}
							#ReCheck the Signature_Comment Property
							{ $CurCLSID.Signature_Comment -eq $null }
							{
								$CurCLSID.Signature_Comment = ''
							}
							#ReCheck the Signature_FileVersion Property
							{ $CurCLSID.Signature_FileVersion -eq $null }
							{
								$CurCLSID.Signature_FileVersion = ''
							}
							#ReCheck the Signature_Description Property
							{ $CurCLSID.Signature_Description -eq $null }
							{
								$CurCLSID.Signature_Description = ''
							}
							#ReCheck the Signature_Date Property
							{ $CurCLSID.Signature_Date -eq $null }
							{
								$CurCLSID.Signature_Date = ''
							}
							#ReCheck the Signature_Company Property
							{ $CurCLSID.Signature_Company -eq $null }
							{
								$CurCLSID.Signature_Company = ''
							}
							#ReCheck the Signature_Publisher Property
							{ $CurCLSID.Signature_Publisher -eq $null }
							{
								$CurCLSID.Signature_Publisher = ''
							}
						}
					#endregion Fix Type Casting
					
					#region Fix Type Casting
						switch
						(
							$null
						)
						{
							#ReCheck the Caption Property
							{ $CurCLSID.Caption -eq $null }
							{
								$CurCLSID.Caption = ''
							}
							#ReCheck the Hash Property
							{ $CurCLSID.Hash -eq $null }
							{
								$CurCLSID.Hash = ''
							}
							#ReCheck the Signature_Comment Property
							{ $CurCLSID.Signature_Comment -eq $null }
							{
								$CurCLSID.Signature_Comment = ''
							}
							#ReCheck the Signature_FileVersion Property
							{ $CurCLSID.Signature_FileVersion -eq $null }
							{
								$CurCLSID.Signature_FileVersion = ''
							}
							#ReCheck the Signature_Description Property
							{ $CurCLSID.Signature_Description -eq $null }
							{
								$CurCLSID.Signature_Description = ''
							}
							#ReCheck the Signature_Date Property
							{ $CurCLSID.Signature_Date -eq $null }
							{
								$CurCLSID.Signature_Date = ''
							}
							#ReCheck the Signature_Company Property
							{ $CurCLSID.Signature_Company -eq $null }
							{
								$CurCLSID.Signature_Company = ''
							}
							#ReCheck the Signature_Publisher Property
							{ $CurCLSID.Signature_Publisher -eq $null }
							{
								$CurCLSID.Signature_Publisher = ''
							}
						}
					#endregion Fix Type Casting
	            }
	        }
	    #endregion Build Object - InprocServer32

	    #region Build Object - LocalServer32
	        If
	        (
	            $($COMType -eq 'All') -or $($COMType -eq 'LocalServer32')
	        )
	        {
	            $ArrLocalServer32 | ForEach-Object `
	            -Process `
	            {
	                $CurCLSID = $_

	                #region Resolve Registry Key Paths
	                    If
	                    (
	                        $ResolveRegKeyPaths
	                    )
	                    {
	                        $CurCLSID.KeyRoot = $($($CLSIDRoot | Select-String -SimpleMatch $CurCLSID.ComponentId | Out-String).Trim())
	                        $CurCLSID.KeyPath = $('{0}\LocalServer32' -f $($CLSIDRoot | Select-String -SimpleMatch $CurObject.ComponentId))
	                    }
	                #endregion Resolve Registry Key Paths
	                
	                #region Parse FilePath
	                    Try
	                    {
	                        $CurCLSIDLiteralPath = Get-LiteralPath -Path $CurCLSID.KeyValue.ToLower()
	                    
	                        Switch
	                        (
	                            $Null
	                        )
	                        {
	                            {$CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w\w'}
	                            {
	                                $null = $CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w\w'
	                                $RegExFilePath = $Matches[0]
	                                $Matches = $null
	                                
	                                Switch
	                                (
	                                    $null
	                                )
	                                {
	                                    {$RegExFilePath -match '(^.*?\.dll)'}
	                                    {
	                                        $null = $RegExFilePath -match '(^.*?\.dll)'
	                                        $CurCLSID.FilePath = $Matches[0]
	                                        $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                        $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                        $Matches = $null
	                                        break
	                                    }
	                                    {$RegExFilePath -match '(^.*?\.exe)'}
	                                    {
	                                        $null = $RegExFilePath -match '(^.*?\.exe)'
	                                        $CurCLSID.FilePath = $Matches[0]
	                                        $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                        $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                        $Matches = $null
	                                        break
	                                    }
	                                    {$RegExFilePath -match '(^.*?\.cpl)'}
	                                    {
	                                        $null = $RegExFilePath -match '(^.*?\.cpl)'
	                                        $CurCLSID.FilePath = $Matches[0]
	                                        $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                        $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                        $Matches = $null
	                                        break
	                                    }
	                                    {$RegExFilePath -match '(^.*?\.ocx)'}
	                                    {
	                                        $null = $RegExFilePath -match '(^.*?\.ocx)'
	                                        $CurCLSID.FilePath = $Matches[0]
	                                        $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                        $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                        $Matches = $null
	                                        break
	                                    }
	                                }
	                                break
	                            }
	                            {$CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w'}
	                            {
	                                $null = $CurCLSIDLiteralPath -match '^\w:\\.*?\.\w\w'
	                                $RegExFilePath = $Matches[0]
	                                $Matches = $null
	                                If
	                                (
	                                    $RegExFilePath -match '(^.*?\.ax)'
	                                )
	                                {
	                                    $null = $RegExFilePath -match '(^.*?\.ax)'
	                                    $CurCLSID.FilePath = $Matches[0]
	                                    $CurCLSID.Arguments = $CurCLSIDLiteralPath.Replace($CurCLSID.FilePath,'')
	                                    $CurCLSID.Arguments = $CurCLSID.Arguments.Trim()
	                                    $Matches = $null
	                                }
	                                break
	                            }
	                            Default
	                            {
	                            }
	                        }
	                    }
	                    Catch
	                    {
	                    }
	                #endregion Parse FilePath

	                #region OnDisk Check
	                    Try
	                    {
	                        $null = Get-Item -Path $CurCLSID.FilePath -Force -ErrorAction Stop
	                        $CurCLSID.OnDisk = 'True'
	                    }
	                    Catch
	                    {
	                        If
	                        (
	                            $TryToResolvePath
	                        )
	                        {
	                            $RedirectErrOutput = $('{0}\{1}' -f $env:TEMP, $(New-UID -ErrorAction SilentlyContinue))
	                            $TryPath = Invoke-Expression -Command $( $('{0}\Windows\System32\cmd.exe /c {0}\Windows\System32\Where.exe /R {0}\Windows {1} 2`> {2}' -f $env:SystemDrive, $($CurCLSID.FilePath | Split-Path -Leaf -ErrorAction SilentlyContinue), $RedirectErrOutput) ) -ErrorAction SilentlyContinue | Select-Object -First 1
	                            $null = Remove-Item -Path $RedirectErrOutput -Force -ErrorAction SilentlyContinue
	                            $Error.Clear()
	                            If
	                            (
	                                $TryPath
	                            )
	                            {
	                                $CurCLSID.OnDisk = 'True'
	                                $CurCLSID.FilePath = $TryPath
	                            }
	                            Else
	                            {
	                                $CurCLSID.OnDisk = 'False'
	                            }
	                        }
	                        Else
	                        {
	                            $CurCLSID.OnDisk = 'False'
	                        }
	                    }
	                #endregion OnDisk Check

	                #region Hash Check
	                    If
	                    (
	                        $CurCLSID.OnDisk
	                    )
	                    {
	                        $CurCLSID.Hash = $(Get-HashInfo -Path $CurCLSID.FilePath -Algorithm $Algorithm -ErrorAction SilentlyContinue)
	                    }
	                #endregion Hash Check

	                #region Signature Check
	                    If
	                    (
	                        $Signature
	                    )
	                    {
	                        Try
	                        {
	                            $CurSignature = $(Get-Signature -Path $CurCLSID.FilePath -Algorithm $Algorithm -ErrorAction SilentlyContinue)
	                        }
	                        Catch
	                        {
	                        }   

	                        $CurCLSID.Signature_Comment = $($CurSignature).Comment
	                        $CurCLSID.Signature_FileVersion = $($CurSignature).'File Version'
	                        $CurCLSID.Signature_Description = $($CurSignature).Description
	                        $CurCLSID.Signature_Date = $($CurSignature).Date
	                        $CurCLSID.Signature_Company = $($CurSignature).Company
	                        $CurCLSID.Signature_Publisher = $($CurSignature).Publisher

	                        If
	                        (
	                            $($CurSignature).Verified
	                        )
	                        {
	                            $CurCLSID.Signature_Verified = $($CurSignature).Verified
	                        }
	                    }
	                #endregion
	            }
	        }
	    #endregion Build Object - LocalServer32

	    #region Filter Type
	        $ArrResults = @()
	        Switch
	        (
	            $null
	        )
	        {
	            {$ArrInprocServer32 -ne $null}
	            {
	                $ArrResults += $ArrInprocServer32
	            }
	            {$ArrLocalServer32 -ne $null}
	            {
	                $ArrResults += $ArrLocalServer32
	            }
	        }

	        If
	        (
	            $($FilterType -eq 'Caption' -and $Pattern -eq '.*')
	        )
	        {
	            $HashReturn.COMObjectList.COMObjects = $ArrResults
	        }
	        Else
	        {
	            If
	            (
	                $NotMatch
	            )
	            {
	                $HashReturn.COMObjectList.COMObjects = $ArrResults | Where-Object -FilterScript { $_.$($FilterType) -NotMatch $Pattern }
	            }
	            Else
	            {
	                $HashReturn.COMObjectList.COMObjects = $ArrResults | Where-Object -FilterScript { $_.$($FilterType) -Match $Pattern }
	            }
	        }

	        $HashReturn.COMObjectList.QueryCount = $HashReturn.COMObjectList.COMObjects | Measure-Object | Select-Object -ExpandProperty Count
	        $HashReturn.COMObjectList.TotalCOMProcessed = $ComObjects | Measure-Object | Select-Object -ExpandProperty Count
	        $HashReturn.COMObjectList.TotalInprocServer32 = $ArrInprocServer32 | Measure-Object | Select-Object -ExpandProperty Count
	        $HashReturn.COMObjectList.TotalLocalServer32 = $ArrLocalServer32 | Measure-Object | Select-Object -ExpandProperty Count
	    #endregion Filter Type
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['COMObjectList'].EndTime = $($EndTime).DateTime
        $HashReturn['COMObjectList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		#region Output Type
			switch
			(
				$Null
			)
			{
				#region Beatify the JSON return and not Escape any Characters
	                { $OutUnEscapedJSON }
					{
						Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
					}
				#endregion Beatify the JSON return and not Escape any Characters
				
				#region Return a PowerShell Object
					{ $ReturnObject }
					{
                        Return $ArrResults
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
#endregion Get-BluGenieCOMObjectInfo (Function)