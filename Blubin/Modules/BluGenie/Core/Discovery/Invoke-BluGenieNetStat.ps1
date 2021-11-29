#region Invoke-BluGenieNetStat (Function)
Function Invoke-BluGenieNetStat
{
<#
    .SYNOPSIS
        Report and Manage processes that have created a Listening port

    .DESCRIPTION
        Report and Manage processes that have created a Listening port
		
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
			Filter Types
			•	"CommandLine"
						Command line used to spawn the Network Connection
            •	"Foreign_Address"
						The Remote Address for the currect connection with port information
            •	"Hash"
						The Hash value of the Process ( MACTripleDES / MD5 / RIPEMD160 / SHA1 / SHA256 / SHA384 / SHA512 ) 
            •	"Local_Address"
						The IP of the Local host with port information
            •	"PID"
						The current Process ID associated with the Connection
            •	"ProcessName"
						The Process name associated with the Connection
            •	"Path"
						The path of the Process associated with the Connection
            •	"Protocol"
						What Protocal is used for the currect Connection
			•	"Caption"
						The Caption property of the associated process
			•	"Description"
						The Description property of the associated process
			•	"Name"
						The Name of the associated process
			•	"ProcessId"
						The current Process ID associated with the Connection
			•	"SessionId"
						The current Session associated with the Connection
            •	"Signature_Comment"
						Display error message while pulling Signature Information [Note: This is only available if you use the -Signature switch]
            •	"Signature_FileVersion"
						File Version and OS Build information in part of the OS [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Description"
						The description of the files signature [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Date"
						Date when the file was signed [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Company"
						The company signing the file [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Publisher"
						The Publisher signing the file [Note:  This is only available if you use the -Signature switch]
            •	"Signature_Verified"
						Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use the -Signature switch]
        Alias:
        ValidateSet: 'CommandLine','Foreign_Address','Hash','Local_Address','PID','ProcessName','Path','Caption','Description','Name','ProcessId','SessionId','Proto','Signature_Comment','Signature_FileVersion','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified'

    .PARAMETER Pattern
        Description: Search Pattern using RegEx
        Notes:  
        Alias:
        ValidateSet: 'Item1','Item2','Item3' 

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes: Default Value = '.*'
        Alias: Help
        ValidateSet: 
		
	.PARAMETER Managetype
		Description: Manage the behavior of the process (Suspend, Resume, Stop) 
		Notes:  
		Alias:
		ValidateSet: Suspend,Resume,Stop
		
	.PARAMETER State
		Description: What state is the Connection in ( LISTENING / CLOSE_WAIT / TIME_WAIT / ESTABLISHED )
		Notes:  
		Alias:
		ValidateSet: LISTENING,ESTABLISHED,LISTENING & ESTABLISHED,WAIT,ALL
		
	.PARAMETER Signature
		Description: Query Signature information 
		Notes:  
		Alias:
		ValidateSet:  
		
	.PARAMETER NotMatch
		Description: Not Matching or Exclude pattern queries 
		Notes:  
		Alias:
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
	    Command: Invoke-BluGenieNetStat
        Description: Output any (Listening or Established) connection information
        Notes: 
				The Default Hash Algorithm is (MD5)
				- Sample Output -
                    "State":  "LISTENING",
                    "PID":  "664",
                    "Protocol":  "TCP",
                    "Local_Address":  "[::]:49701",
                    "Foreign_Address":  "[::]:0",
                    "Process_Name":  "lsass.exe",
                    "Process_StartTime":  null,
                    "Process_Path":  "C:\\WINDOWS\\system32\\lsass.exe",
                    "Hash":  "3df3b76b19da92a8adc01ff38560282d",
                    "CommandLine":  null,
                    "Signature_Comment":  "",
                    "Signature_FileVersion":  "10.0.17134.376 (WinBuild.160101.0800)",
                    "Signature_Description":  "Local Security Authority Process",
                    "Signature_Date":  "2:45 AM 10/21/2018",
                    "Signature_Company":  "Microsoft Corporation",
                    "Signature_Publisher":  "Microsoft Windows Publisher",
                    "Signature_Verified":  "Signed"

    .EXAMPLE
	    Command: Invoke-BluGenieNetStat -State ALL -Algorithm SHA256
        Description: Connection information with Hash value of SHA256
        Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieNetStat -FilterType Local_Address -Pattern 3389
		Description: Report on all Listening or Established ports that have a port of 3389
		Notes: The -Pattern is a (RegEx) query by default.  If you used :3389 for the port 
               you would have to escape the (:) like so '\:3389'
			   
	.EXAMPLE
		Command: Invoke-BluGenieNetStat -FilterType Process_Name -Pattern Windows10FirewallService
		Description: Connection information with with any ( Process Name ) of ( Windows10FirewallService ) 
		Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieNetStat -FilterType Process_Name -Pattern Windows10FirewallService -Managetype Stop
		Description: Terminate any connection based on the search terms
		Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieNetStat -NotMatch -Pattern '\[\:\:\]\:0|0.0.0.0:0'
		Description: Report on all Listening or Established ports that do not have a value for Foreign_Address of '[::]:0' or '0.0.0.0:0'
		Notes: 	The -Pattern is a (RegEx) query by default.  If you used '[::]:0' for the Foreign_Address 
                you would have to escape the ascii charactors '\[\:\:\]\:0'.  You can also use the pipe command to do an (OR) in Regex.

    .EXAMPLE
	    Command: Invoke-BluGenieNetStat -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
					Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Invoke-BluGenieNetStat -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
					Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Invoke-BluGenieNetStat -OutUnEscapedJSON
        Description: Invoke-BluGenieNetStat and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Invoke-BluGenieNetStat -ReturnObject
        Description: Invoke-BluGenieNetStat and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1807.2801
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1912.0201
        * Comments                  :
        * Dependencies              :
        	~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
			~ Get-HashInfo 					- PowerShell Version 2 port of Get-FileHash
			~ Get-LiteralPath 				- Convert System Variable defined paths to a Literal Path.  %WinDir% --> C:\Windows
			~ Get-Signature					- Report on the Files Authenication Signature Information
        * Build Version Details     :
            ~ 1807.2801: • [Michael Arroyo] Posted
            ~ 1809.0901: • [Michael Arroyo] Added QueryIP command
            ~ 1809.2301: • [Michael Arroyo] Fixed the kill process method 
            ~ 1901.0501: • [Michael Arroyo] Added a new switch parameter (QueryResultsOnly) to all only the Query Results to be returned and not 
												the entire service list                
            ~ 1901.2001: • [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
                         • [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
                         • [Michael Arroyo] Updated the Help information  
                         • [Michael Arroyo] Added new parameter to Manage-ProcessHash to now support the updated Hash Algorithm   
            ~ 1902.0601: • [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information            
            ~ 1902.1101: • [Michael Arroyo] Fixed the Validation Set for ManageType
            ~ 1902.1201: • [Michael Arroyo] Converted the entire function to use the new search process
                         • [Michael Arroyo] Added the Authentication Signature Information to the report
            ~ 1902.1801: • [Michael Arroyo] Updated the Authentication Signature Information method.  This will pull the Signature information 
												using SigCheck.exe
                         • [Michael Arroyo] Added Signature switch.  This will pull the Signature information for the giving file or process.
                         • [Michael Arroyo] Added the Signature Search options to the -FilterType Search string
            ~ 1902.1802: • [Michael Arroyo] Add Try/Catch to the Get-Signature call.  This is done to prevent errors if the function wasn't 
												loaded for any reason.
            ~ 1905.2901: • [Michael Arroyo] Process a quick filter using the default NetStat properties 
												[ Foreign_Address | Local_Address | PID | Proto | State ]
                         • [Michael Arroyo] Process a second filter to process all other properties if none of the above are used to filter.
                         • [Michael Arroyo] Append all WMI Process information to each found NetStat process
                         • [Michael Arroyo] Updated the Walktrough Function to version 1905.2401
                         • [Michael Arroyo] Added Parameter ReturnObject, to return the needed information in an Object
                         • [Michael Arroyo] Added Parameter OutUnEscapedJSON, this will beautify the json data and clean up the formatting.
                         • [Michael Arroyo] Added Parameter -NotMatch, this will filter out references that do not match the -Pattern information
                         • [Michael Arroyo] Added Parameter Check for all Bound parameters
                         • [Michael Arroyo] Changed the default FilterType value to [ Foreign_Address ]
            ~ 1906.1702: • [Michael Arroyo] Added support for setting the Foreign Address as an IP or a Domain name.
			~ 1911.3001: • [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
						 • [Michael Arroyo] Updated the Hash Information to follow the new function standards
						 • [Michael Arroyo] Added more detailed information to the Return data
						 • [Michael Arroyo] Updated the ( Hash ) property for ES
						 • [Michael Arroyo] Updated the Function format to follow the new New Function schema
						 • [Michael Arroyo] Removed the follow properties from the Query list 
						 						( Scope, Options, ClassPath, Properties, SystemProperties, Qualifiers, __DERIVATION )
			~ 1912.0201: • [Michael Arroyo] Fixed the search process name issue
						 • [Michael Arroyo] Added more Properties to filter in FilterType
						 • [Michael Arroyo] Updated the Help information regarding the new FilterTypes
						 • [Michael Arroyo] Fixed the Manage-ProcessHash.  The call was giving a True value on return
						 • [Michael Arroyo] Fixed the Manage-ProcessHash false results when killing a process is really true
			~ 2002.2601: • [Michael Arroyo] Updated the Code to the '145' column width standard
						 • [Michael Arroyo] Updated the (State) filter to query all NetStat Connections using the (.) regex pattern.
#>
	#region Params
    [cmdletbinding()]
    [Alias('Invoke-NetStat')]
    Param
    (
        [Parameter(Position = 0)]
        [ValidateSet('CommandLine',
					 'Foreign_Address',
					 'Hash',
					 'Local_Address',
					 'PID',
					 'ProcessName',
					 'Path',
					 'Caption',
					 'Description',
					 'Name',
					 'ProcessId',
					 'SessionId',
					 'Proto',
					 'Signature_Comment',
					 'Signature_FileVersion',
					 'Signature_Description',
					 'Signature_Date',
					 'Signature_Company',
					 'Signature_Publisher',
					 'Signature_Verified'
		)]
        [string]$FilterType = 'Foreign_Address',

        [Parameter(Position = 1)]
        [string]$Pattern = '.*',

		[Parameter(Position = 2)]
        [ValidateSet('Suspend', 'Resume', 'Stop')]
        [string]$Managetype,

        [ValidateSet('MACTripleDES',
					 'MD5',
					 'RIPEMD160',
					 'SHA1',
					 'SHA256',
					 'SHA384',
					 'SHA512'
		)]
        [string]$Algorithm = 'MD5',

        [ValidateSet('LISTENING',
					 'ESTABLISHED',
					 'LISTENING|ESTABLISHED'
					 ,'WAIT'
					 ,'.'
		)]
        [String]$State = 'LISTENING|ESTABLISHED',

        [switch]$Signature,

        [switch]$NotMatch,

        [switch]$ForeignAddressAsIP,

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject,

        [Switch]$OutUnEscapedJSON
    )
	#endregion Params

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
        $HashReturn['NetStat'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['NetStat'].StartTime = $($StartTime).DateTime
		$HashReturn['NetStat'].ManageProcess = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['NetStat'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results
	
	#region Query NetStat
        $Error.Clear()
        If
        (
            $ForeignAddressAsIP
        )
        {
            $NetStatResults = Invoke-Expression -Command $('{0}\System32\NETSTAT.EXE -nao' -f $env:windir)
        }
        Else
        {
            $NetStatResults = Invoke-Expression -Command $('{0}\System32\NETSTAT.EXE -ao' -f $env:windir)
        }
    #endregion

    #region Main
		#region Create NetState Reference Object
			## Updated to support PS2
            $RefObjNetState = $NetStatResults -replace ('\n','') -replace ('\s\s+',',') -replace ('\s','_') -replace '^\,'  
            $ArrObjNetState = @()
            $RefObjNetState | ForEach-Object `
            -Process `
            {
                $CurString = $_
                Switch
                (
                    $($CurString -split ',').Count
                )
                {
                    '4'
                    {
                        $UpdateCurString = $CurString -split ','
                        $CurString = $('{0},{1},{2},{3},{4}' -f `
							$UpdateCurString[0], $UpdateCurString[1], $UpdateCurString[2], $null, $UpdateCurString[3])
                        $ArrObjNetState += $CurString
                    }
                    '5'
                    {
                        $ArrObjNetState += $CurString
                    }
                }
            }

            $ObjNetState = $ArrObjNetState | ConvertFrom-Csv -ErrorAction SilentlyContinue
        #endregion Create NetState Reference Object
	
        #region First Pass Filter
            If
            (
                $FilterType -eq 'Foreign_Address' -or `
				$FilterType -eq 'Local_Address' -or `
				$FilterType -eq 'PID' -or `
				$FilterType -eq 'Proto' -or `
				$FilterType -eq 'State'
            )
            {
                Switch
                (
                    $null
                )
                {
                    { $NotMatch }
                    {
                        $FirstPassFilter = $ObjNetState | Where-Object -FilterScript { $_.$($FilterType) -NotMatch $Pattern } | `
							Where-Object -FilterScript { $_.'State' -Match $State }
                        Break
                    }
                    Default
                    {
                        $FirstPassFilter = $ObjNetState | Where-Object -FilterScript { $_.$($FilterType) -Match $Pattern } | `
							Where-Object -FilterScript { $_.'State' -Match $State }
                    }
                }

                $FirstPassQuery = $false
            }
            Else
            {
                $FirstPassFilter = $ObjNetState
                $FirstPassQuery = $true
            }
        #endregion First Pass Filter

        #region Second Pass Filter
            $SecondPassFilter = @()

            $FirstPassFilter | ForEach-Object `
            -Process `
            {
                $CurFirstPassFilter = $_
                $CurNetStatObj = $(Get-WmiObject -Class Win32_process -Filter ('processid = {0}' -f $($CurFirstPassFilter.PID)) `
					-ErrorAction SilentlyContinue | Select-Object -Property *,
                                        @{
                                            Name = 'Proto'
                                            Expression = {$($CurFirstPassFilter).Proto}
                                        },
                                            @{
                                            Name = 'Local_Address'
                                            Expression = {$($CurFirstPassFilter).Local_Address}
                                        },
                                            @{
                                            Name = 'Foreign_Address'
                                            Expression = {$($CurFirstPassFilter).Foreign_Address}
                                        },
                                            @{
                                            Name = 'State'
                                            Expression = {$($CurFirstPassFilter).State}
                                        },
                                            @{
                                            Name = 'PID'
                                            Expression = {$($CurFirstPassFilter).PID}
                                        },
                                        @{
                                            Name = 'Hash'
                                            Expression = {$(Get-HashInfo -Path $_.Path -Algorithm $Algorithm)}
                                        } -ExcludeProperty Scope,Options,ClassPath,Properties,SystemProperties,Qualifiers,__DERIVATION
                                    )
									
				If
				(
					-Not $CurNetStatObj.Hash
				)
				{
					If
					(
						$CurNetStatObj
					)
					{
						$CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Hash' -Value '' -Force -ErrorAction SilentlyContinue
					}
				}
				
				#region Signature
	                If
	                (
	                    $Signature
	                )
	                {
	                    Try
	                    {
	                        $CurSignature = $(Get-Signature -Path $CurNetStatObj.Path -Algorithm $Algorithm)
	                    }
	                    Catch
	                    {
	                        $Null
	                    }
	                }

	                If
	                (
	                    $Signature
	                )
	                {
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Comment' -Value $($CurSignature).Comment
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_FileVersion' -Value $($CurSignature).'File Version'
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Description' -Value $($CurSignature).Description
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Date' -Value $($CurSignature).Date
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Company' -Value $($CurSignature).Company
	                    $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Publisher' -Value $($CurSignature).Publisher

	                    If
	                    (
	                        $($CurSignature).Verified
	                    )
	                    {
	                        $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' -Value $($CurSignature).Verified
	                    }
	                    Else
	                    {
	                        $CurNetStatObj | Add-Member -MemberType NoteProperty -Name 'Signature_Verified' -Value 'N/A'
	                    }
	                }
				#endregion Signature

                $SecondPassFilter += $CurNetStatObj
            }

            If
            (
                $FilterType -eq 'Foreign_Address' -and $Pattern -eq '.*'
            )
            {
                $ThirdPassQuery = $false
            }
            Else
            {
                $ThirdPassQuery = $true
            }
        #endregion Second Pass Filter

        #region Third Pass Filter
            If
            (
                $ThirdPassQuery
            )
            {
				$ArrNetStatObj = @()
			
                Switch
                (
                    $null
                )
                {
                    { $NotMatch }
                    {
                        $ArrNetStatObj = $SecondPassFilter | Where-Object -Property $FilterType -NotMatch $Pattern | `
							Where-Object -FilterScript { $_.'State' -Match $State }
                        Break
                    }
                    Default
                    {
                        $ArrNetStatObj = $SecondPassFilter | Where-Object -Property $FilterType -Match $Pattern | `
							Where-Object -FilterScript { $_.'State' -Match $State }
                    }
                }
            }
            Else
            {
                $ArrNetStatObj = $SecondPassFilter
            }
        #endregion Third Pass Filter
		
		#region Add Connections to HashTable
            $HashReturn.NetStat.Connections = $ArrNetStatObj
        #endregion Add Connections to HashTable

        #region NetState Item Count
            $HashReturn.NetStat.Count = $($HashReturn.NetStat.Connections | Measure-Object | Select-Object -ExpandProperty Count)
        #endregion NetState Item Count

        #region $Managetype
            If
            (
                $Managetype
            )
            {
                $CurHashes = $ArrNetStatObj | Select-Object -ExpandProperty Hash -Unique
                
                switch
                (
                    $Managetype
                )
                {
                    'Suspend'
                    {
                        $null = $($HashReturn['NetStat'].ManageProcess += $(Manage-ProcessHash -Hash $CurHashes `
							-Managetype Suspend -Algorithm $Algorithm))
                    }
                    'Resume'
                    {
                        $null = $($HashReturn['NetStat'].ManageProcess += $(Manage-ProcessHash -Hash $CurHashes `
							-Managetype Resume -Algorithm $Algorithm))
                    }
                    'Stop'
                    {
                        $null = $($HashReturn['NetStat'].ManageProcess += $(Manage-ProcessHash -Hash $CurHashes `
							-Managetype Stop -Algorithm $Algorithm))
                    }
                }
            }
        #endregion
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['NetStat'].EndTime = $($EndTime).DateTime
        $HashReturn['NetStat'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
			Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
						Return $(New-Object -TypeName PSObject -Property @{
                                NetStat = $ArrNetStatObj
                                Managetype = $HashReturn.NetStat.ManageProcess
                            })
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
#endregion Invoke-BluGenieNetStat (Function)