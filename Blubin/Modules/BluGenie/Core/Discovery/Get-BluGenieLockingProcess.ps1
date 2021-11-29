#region Get-BluGenieLockingProcess (Function)
Function Get-BluGenieLockingProcess
{
<#
    .SYNOPSIS
        Report on which process is locking the file or directory

    .DESCRIPTION
        Report on which process is locking the file or directory

    .PARAMETER Path
        Description: Path (file or directory)
        Notes:  This can be an Array, a single path, or a single string with a comma separator
        Alias:
        ValidateSet:  

    .PARAMETER ToolPath
        Description: Path to the Handle.exe SysInternals Utility
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

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: This is set to $true by default.  To change to false run -ReturnObject:$false
        Alias: 
        ValidateSet: 

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias: 
        ValidateSet: 

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log'
        Description: Show the Process locking the file given
        Notes: 
			- Sample Output -
                LockedPath        : C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log                     
				ProcessId         : 8020                                                                      
				Name              : OneDrive.exe                                                              
				CommandLine       : "C:\Users\Admin\AppData\Local\Microsoft\OneDrive\OneDrive.exe" /background
				SessionId         : 1                                                                         
				Path              : C:\Users\Admin\AppData\Local\Microsoft\OneDrive\OneDrive.exe              
				Hash              : 78e5e5f44cc67195278179cd60453ec8                                          
				ProcessOwner      : Admin                                                             
				Caption           : OneDrive.exe                                                              
				ParentProcessId   : 5792                                                                      
				ParentProcessName : explorer                                                                  
				ParentProcessPath : C:\Windows\Explorer.EXE                                                   
				ParentHash        : 4e196cea0c9c46a7d656c67e52e8c7c7                                          
				Comment           :                                                                           

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log,C:\Users\Admin\AppData\Local\Temp'
        Description: Show the Process locking the paths in a sinlge string using a comma separator
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log','C:\Users\Admin\AppData\Local\Temp'
        Description: Show the Process locking the paths in an Array
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log' -ReturnObject:$False
	    Description: Reset the default output to a Hash Table
	    Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log' -ToolPath 'C:\Temp\Handle.exe'
        Description: Locate the Handle.exe tool in C:\Temp and Show the Process locking the file given
	    Notes: 

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
                    Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
                    Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Users\Admin\AppData\Local\Temp\aria-debug-8020.log' -OutUnEscapedJSON
        Description: Show the Authentication Handle Information and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.

    .EXAMPLE
	    Command: Get-BluGenieLockingProcess -Path 'C:\Windows\Notepad.exe' -ReturnObject
        Description: Show the Authentication Handle Information and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default option

    .OUTPUTS
        TypeName: System.Object

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.05.2101
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 20.11.2801
        * Comments                  :
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
		    ~ Handle.exe - SysInternals Utility
		    ~ Get-LiteralPath - Get-LiteralPath will convert System Variable defined paths to a Literal Path
        * Build Version Details     :
            ~ 1911.2201: * [Michael Arroyo] Posted
            ~ 2002.2301: * [Michael Arroyo] Added the missing parameter for handle.exe --> accepteula
            ~ 20.05.2101: • [Michael Arroyo] Updated to support Posh 2.0
            ~ 20.11.2801: • [Michael Arroyo] Changed the validation set for Algorithm from using (Double Quotes) to (Single Quotes)
						  • [Michael Arroyo] Added the FormatView parameter including the new FormatView Output process
						  • [Michael Arroyo] Added the current local path to the Tool Search path process to find Handle.exe in the current path
						  • [Michael Arroyo] Updated the Get-Item call to the .NET call [System.IO.File] to better manage the file information process
						  
			
#>
	[cmdletbinding()]
    [Alias('Get-LockingProcess')]    
    Param
    (
        [Parameter(Position=1)]
        [String[]]$Path,

        [Parameter(Position=2)]
        [String]$ToolPath,

        [Parameter(Position=3)]
        [ValidateSet('MACTripleDES', 'MD5', 'RIPEMD160', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm = 'MD5',

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject = $true,

        [Switch]$OutUnEscapedJSON,

        [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
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
	
	#region Path Parameter Check
        If
        (
            -Not $Path
        )
        {
            Return
        }
    #endregion Path Parameter Check

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetLockingProcess'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetLockingProcess'].StartTime = $($StartTime).DateTime
        $HashReturn['GetLockingProcess'].ParameterSetResults = @()
        $HashReturn['GetLockingProcess']['Handles'] = @()
		$HashReturn['GetLockingProcess']['ToolCheck'] = $false
		$HashReturn['GetLockingProcess']['ToolPath'] = ''
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetLockingProcess'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results
	
	#region Tool Check
        $Error.Clear()
		$ArrToolPath = @(
			$ToolPath,
	        $('{0}\Handle.exe' -f $(Get-BluGenieLiteralPath -Path $($BGTools | Where-Object -FilterScript { $_.'Name' -eq 'Handle.exe' } | `
                Select-Object -ExpandProperty RemoteDestination) -ErrorAction SilentlyContinue)),
			$($ToolsConfig.CopyTools  | Where-Object -FilterScript { $_.'Name' -eq 'Handle.exe' } | Select-Object -ExpandProperty FullPath),
			$('{0}\Windows\Temp\Handle.exe' -f $env:SystemDrive),
			$('{0}\Handle.exe' -f $env:Temp),
			'.\Tools\SysinternalsSuite\Handle.exe',
            $('{0}\Handle.exe' -f $(Get-Location | Select-Object -ExpandProperty Path))
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
					$HashReturn['GetLockingProcess']['ToolPath'] = $CurToolPath
					$HashReturn['GetLockingProcess']['ToolCheck'] = $true
					Break
				}
			}
		}
    #endregion Tool Check

    #region Main
        #region If Tool Exists --> Continue
			If
			(
				$HashReturn['GetLockingProcess']['ToolCheck']
			)
			{
				#region Handle Properties	
					$HandleProps = @{
						'LockedPath'		= ''
                        'ProcessId'			= 'No matching handles found'
						'Name'				= ''
						'CommandLine'		= ''
						'SessionId'			= ''
						'Path'				= ''
						'Hash'				= ''
						'ProcessOwner'		= ''
						'Caption'			= ''
						'ParentProcessId'	= ''
						'ParentProcessName'	= ''
						'ParentProcessPath'	= ''
						'ParentHash'		= ''
						'Comment'			= ''
					}
				#endregion Handle Properties
			
				#region Validate Path(s)
					[System.Collections.ArrayList]$ArrPaths = @()
					
					#region Parse and validate all paths
						switch
						(
							$Null
						)
						{
							#region Check if path is a single string with a comma separator
								{$Path -match ','}
								{
									$Paths = $Path -split ',' | ForEach-Object `
									 -Process `
									 {
									 	$CurPathCheck = Get-BluGenieLiteralPath -Path $($_) -ErrorAction SilentlyContinue
                                        $CurPathObject = New-Object -TypeName PSObject -Property $HandleProps

										If
										(
                                            [System.IO.File]::Exists($CurPathCheck)
										)
										{
											$CurPathObject.LockedPath = $CurPathCheck
											$null = $ArrPaths.Add($CurPathObject)
										}
										Else
										{
											$CurPathObject.LockedPath = $CurPathCheck
											$CurPathObject.Comment = 'Path not found'
											$null = $ArrPaths.Add($CurPathObject)
										}
									 }
								}
							#endregion Check if path is a single string with a comma separator
							
							#region Check if path is an Array with more than 1 item
								{$Path.Count -gt 1}
								{
									$Path | ForEach-Object `
									-Process `
									{
										$CurPathCheck = Get-BluGenieLiteralPath -Path $($_) -ErrorAction SilentlyContinue
                                        $CurPathObject = New-Object -TypeName PSObject -Property  $HandleProps

										If
										(
											[System.IO.File]::Exists($CurPathCheck)
										)
										{
											$CurPathObject.LockedPath = $CurPathCheck
											$null = $ArrPaths.Add($CurPathObject)
										}
										Else
										{
											$CurPathObject.LockedPath = $CurPathCheck
											$CurPathObject.Comment = 'Path not found'
											$null = $ArrPaths.Add($CurPathObject)
										}
									}
								}
							#endregion Check if path is an Array with more than 1 item
							
							#region Default - Single Path
								Default
								{
									$CurPathCheck = Get-BluGenieLiteralPath -Path $($Path) -ErrorAction SilentlyContinue
                                    $CurPathObject = New-Object -TypeName PSObject -Property  $HandleProps

									If
									(
										[System.IO.File]::Exists($CurPathCheck)
									)
									{
										
										$CurPathObject.LockedPath = $CurPathCheck
										$null = $ArrPaths.Add($CurPathObject)
									}
									Else
									{
										$CurPathObject.LockedPath = $CurPathCheck
										$CurPathObject.Comment = 'Path not found'
										$null = $ArrPaths.Add($CurPathObject)
									}
								}
							#endregion Default - Single Path
						}
					#endregion Parse and validate all paths
                #endregion Validate Path(s)
				
				#region Query Object Values
					$ArrPaths | Where-Object -FilterScript { $_.Comment -ne 'Path not found' } | ForEach-Object `
					 -Process `
					 {
					 	$CurValidPathObj = $_
						
						
						$data = Start-BluGenieNewProcess -FileName $('"{0}"' -f $HashReturn['GetLockingProcess']['ToolPath']) `
												 -Arguments $('"{0}" -nobanner -accepteula' -f $($CurValidPathObj.LockedPath)) | 
												 Select-Object -ExpandProperty StdOut
						

                        <#
						#region Match Pattern
                            $matchPattern = '^(?<Name>\w+\.\w+)\s+pid:\s(?<PID>\d+)\s+type:\s(?<Type>\w+)\s+.*:?\s(?<Path>.*)'
							$Matches = $null
						
							If
							(
								$data -match "$matchPattern"
							)
							{
								$CurValidPathObj.ProcessId = $Matches.PID
							}
						#endregion Match Pattern
                        #>
                        $ParseData = $data -replace '\s\s+',',' -replace ',$|pid:\s|type:\s' | `
                            ConvertFrom-Csv -Header 'NAME','PID','TYPE','PATH' | `
                            Select-Object -Property NAME,PID,TYPE,@{Name='PATH';Expression={$_.Path -replace '^\d+\:\s'}}
                            
                        $CurValidPathObj.ProcessId = $ParseData.PID
						
						#region Query Process Information
                            If
                            (
                                $CurValidPathObj.ProcessId
                            )
                            {
							    $ProcessListResults = Get-WmiObject -Class Win32_Process -Filter $('ProcessId={0}' -f $CurValidPathObj.ProcessId) | Select-Object -Property `
							                            Caption,
							                            CommandLine,
							                            Name,
							                            ProcessId,
							                            SessionId,
							                            Path,
							                            ParentProcessId,
							                            @{Name='ParentProcessName';Expression={$(Get-Process -Id $($_.ParentProcessId) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)}},
							                            @{Name='ParentProcessPath';Expression={$(Get-Process -Id $($_.ParentProcessId) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path)}},
							                            @{Name='ComputerName';Expression={$env:COMPUTERNAME}},
							                            @{Name='ProcessOwner';Expression={$($(Get-WmiObject -ErrorAction SilentlyContinue -Class Win32_Process -Filter "ProcessID = $($_.ProcessID)").GetOwner() | Select-Object -Property @{Name='Owner';Expression={$('{0}\{1}' -f $_.Domain,$_.User)}}).Owner}},
													    @{Name='Hash';Expression={$null}},
													    @{Name='ParentHash';Expression={$null}}
													
							    switch
							    (
								    $null
							    )
							    {
								    {$CurValidPathObj.LockedPath}
								    {
									    $ProcessListResults.Hash = $(Get-BluGenieHashInfo -Path $($CurValidPathObj.LockedPath) -Algorithm MD5)
								    }
								
								    {$ProcessListResults.ParentProcessPath}
								    {
									    $ProcessListResults.ParentHash = $(Get-BluGenieHashInfo -Path $($ProcessListResults.ParentProcessPath) -Algorithm MD5)
								    }
							    }

							    $CurValidPathObj.Name = $ProcessListResults.Name
							    $CurValidPathObj.CommandLine = $ProcessListResults.CommandLine
							    $CurValidPathObj.SessionId = $ProcessListResults.SessionId
							    $CurValidPathObj.Path = $ProcessListResults.Path
							    $CurValidPathObj.Hash = $ProcessListResults.Hash
							    $CurValidPathObj.ProcessOwner = $ProcessListResults.ProcessOwner
							    $CurValidPathObj.Caption = $ProcessListResults.Caption
							    $CurValidPathObj.ParentProcessId = $ProcessListResults.ParentProcessId
							    $CurValidPathObj.ParentProcessName = $ProcessListResults.ParentProcessName
							    $CurValidPathObj.ParentProcessPath = $ProcessListResults.ParentProcessPath
							    $CurValidPathObj.ParentHash = $ProcessListResults.ParentHash
                            }
						#endregion Query Process Information
					 }			
				#endregion Query Object Values
				
				$HashReturn['GetLockingProcess']['Handles'] += $ArrPaths
			}
		#endregion If Tool Exists --> Continue
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetLockingProcess'].EndTime = $($EndTime).DateTime
        $HashReturn['GetLockingProcess'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $ArrPaths

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
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ResultSet | ConvertTo-Json -Depth 10)
                                        }
                                        Catch
                                        {
                                        }
        			                }
        		                #endregion JSON

                                #region OutUnEscapedJSON
        			                'OutUnEscapedJSON'
        			                {
        				                Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                                -Process `
                                                {
                                                    [regex]::Unescape($_)
                                                }
                                            )
                                        }
                                        Catch
                                        {
                                        }
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
#endregion Get-BluGenieLockingProcess (Function)