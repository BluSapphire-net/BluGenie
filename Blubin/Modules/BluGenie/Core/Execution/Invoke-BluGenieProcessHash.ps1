#region Invoke-BluGenieProcessHash (Function)
Function Invoke-BluGenieProcessHash
{
<#
    .SYNOPSIS
        Suspend, Resume, Stop and Export processes or process information based on the Hash value.
        This function is setup to take one or many hash descriptors, locate the running item,
        and manage it by either Suspending it Resuming it, or Stopping / Killing it.

    .DESCRIPTION
        Suspend, Resume, Stop and Export processes or process information based on the 'Process','Handle','Path', or 'Hash'
        This function is setup to take one or many descriptors, locate the running item(s),
        and manage it by either Suspending it Resuming it, or Stopping / Killing it.

    .PARAMETER Hash
        Description: The Hash value for a specific process
        Notes:  
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

    .PARAMETER Managetype
        Description: Manage the behavior of the process (Suspend, Resume, Stop)
        Notes:  
        Alias:
        ValidateSet: 'Report','Suspend','Resume','Stop'
		
	.PARAMETER FilterType
		Description:  Which property to filter by
        Notes:  
            Filter Option
			•	"Process"
					Process Name
			•	"Handle"
					Handle of the Process
            •	"Path"
					Full path with extension of the executable
            •	"Hash"
					Hash value based on 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512' which is controlled wit the 
				-Algorithm parameter
		Alias:
		ValidateSet: 'Process','Handle','Path','Hash'
		
	.PARAMETER Pattern
		Description:  RegEx supported Search patterns to help filter the returning criteria
		Notes:  
		Alias:
		ValidateSet:  
		
	.PARAMETER TimerLoop
		Description: Set how many loops the terminate process checks for validation
		Notes:  
		Alias:
		ValidateSet:  

	.PARAMETER SleepTime
		Description: Set the Sleep time between each loop
		Notes:  
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
	    Invoke-BluGenieProcessHash
        Description: Display the hash information for all running Processes.
        Notes: The default Algorithm is (MD5)

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -Hash 80c6dd21910db50b90f0a5d00957ab6e011c43e23dfb4bf174c1448ce2863e0c81fbc8cc07e9b0bd4f4dbef2ada31c1dc7e676e9bc0b40bf7b85f2d052fdf5a9 -Algorithm SHA512
        Description: Terminate the Process with the specific hash.
        Notes: The Algorithm used is (SHA512)

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -Hash 74b64b52a66c242fe8a3119fb8445295e0b8719187653cd08cedeeaa26e97452 -Algorithm SHA256 -ManageType Suspend
        Description: Suspend the Process with the specific hash.
        Notes: The Algorithm used is (SHA256)

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -Hash 74b64b52a66c242fe8a3119fb8445295e0b8719187653cd08cedeeaa26e97452 -Algorithm SHA256 -ManageType Resume
        Description: Resume the Process with the specific hash.
        Notes: The Algorithm used is (SHA256)
		
	.EXAMPLE
		Command: Invoke-BluGenieProcessHash -FilterType 'Process' -Pattern 'notepad'
		Description: Filter all processes by Process name and look for any process that matches ( notepad ) in the name
		Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieProcessHash -FilterType 'Process' -Pattern '^notepad\.exe$'
		Description: Filter all processes by Process name and look for the exact match of ( Notepad.exe )
		Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieProcessHash -FilterType 'Hash' -Pattern 'f1139811bbf61362915958806ad30211|88c998e5af2e07a81c35d34b6edd0006'
		Description: Search for multiple items with Regex
		Notes: 
		
	.EXAMPLE
		Command: Invoke-BluGenieProcessHash -FilterType 'Hash' -Pattern 'f1139811bbf61362915958806ad30211|88c998e5af2e07a81c35d34b6edd0006' -Managetype Stop
		Description: Terminate multiple items with Regex
		Notes: 

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
					Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
					Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -OutUnEscapedJSON
        Description: Display the hash information for all running Processes and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Invoke-BluGenieProcessHash -ReturnObject
        Description: Display the hash information for all running Processes and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1807.2801
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 2002.2601
        * Comments                  :
        * Dependencies              :
			• Invoke-WalkThrough
					Invoke-WalkThrough is an interactive help menu system
			• Get-HashInfo
					Get-HashInfo is a PowerShell Version 2 port of Get-FileHash
			• Get-LiteralPath
					Get-LiteralPath will convert System Variable defined paths to a Literal Path
        * Build Version Details     :
            ~ 1807.2801: • [Michael Arroyo] Posted
            ~ 1809.2901: • [Michael Arroyo] Added WMI Termination Process as a 2nd attempt to kill a process
                         • [Michael Arroyo] Added a Recheck to fix the false positives, if a process stayed open even after a kill was sent
            ~ 1901.2001: • [Michael Arroyo] Added the Hash Algorithm to support multiple Algorithm values
                         • [Michael Arroyo] Removed the internal Hash syntax and now calling an external function
                         • [Michael Arroyo] Updated the Help information
            ~ 1902.0601: • [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
            ~ 1911.0101: • [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                         • [Michael Arroyo] Updated the Hash Information to follow the new function standards
                         • [Michael Arroyo] Added more detailed information to the Return data
			~ 1912.0201: • [Michael Arroyo] Updated the ReturnObject parameter to always be $true
						 • [Michael Arroyo] Updated the Output to the new format to support the ReturnObject always being enabled.
						 • [Michael Arroyo] Added parameter ( FilterType ) to Filter on both reporting and Process management
						 • [Michael Arroyo] Added parameter ( Pattern ) to support RegEx Search patterns 
						 • [Michael Arroyo] Added parameter ( TimerLoop ) to set how many loops the terminate process checks for validation
						 • [Michael Arroyo] Added parameter ( SleepTime ) to set the sleep time between each loop
			~ 1912.0601: • [Michael Arroyo] Updated the Suspend and Resume identifier.  It was being trapped and pushed to the log.
			~ 1912.0602: • [Michael Arroyo] Updated the Select-Object references to support PS3,PS4, and PS5.  They were only working correctly 
												in PS5.
			~ 1912.1202: • [Michael Arroyo] Updated all the Try Catch statements with more error return data
			~ 2002.2601: • [Michael Arroyo] Updated the Code to the '145' column width standard
						 • [Michael Arroyo] Updates the Suspend and Resume function to process multiple PID's based on Hash information
#>
    [Alias('Manage-ProcessHash')]
	#region Param
    Param
    (
        [Parameter(Position=0)]
        [string[]]$Hash,

		[Parameter(Position=1)]
        [ValidateSet('Report',
					 'Suspend',
					 'Resume',
					 'Stop'
		)]
        [string]$Managetype = 'Report',
		
		[Parameter(Position=2)]
		[ValidateSet('MACTripleDES',
					 'MD5',
					 'RIPEMD160',
					 'SHA1',
					 'SHA256',
					 'SHA384',
					 'SHA512'
		)]
        [string]$Algorithm = 'MD5',
		
		[ValidateSet('Process',
					 'Handle',
					 'Path',
					 'Hash'
		)]
        [string]$FilterType = 'Hash',

        [string]$Pattern = '.*',
		
		[Int]$TimerLoop = 12,
		
		[Int]$SleepTime = 5,

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject = $true,

        [Switch]$OutUnEscapedJSON
    )
	#endregion Param

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
        $HashReturn['ManageProcessHash'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ManageProcessHash'].StartTime = $($StartTime).DateTime
        [System.Collections.ArrayList]$HashReturn['ManageProcessHash'].Processes = @()
		$HashReturn['ManageProcessHash'].CountFound = ''
		$HashReturn['ManageProcessHash'].TotalQueried = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['ManageProcessHash'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Update Parameter values
            If
            (
                $Hash -and $($Managetype -eq 'Report')
            )
            {
                $Managetype = 'Stop'
            }
			
			If
			(
				$Hash
			)
			{
				$FilterType = 'Hash'
				If
				(
					$Hash -match ','
				)
				{
					$Pattern = $Hash -replace ',','|'
				}
				Else
				{
					$Pattern = $($hash | out-string).trim() -replace '\s','|' -replace '\|\|','|'
				}
			}
			
			
        #endregion Update ManageType if a Hash value is specified
		
		#region Create Threader Namespace
			Try
			{
	        	$null = Add-Type -Name Threader -Namespace '' -MemberDefinition @"
[Flags]
public enum ThreadAccess : int
{
Terminate = (0x0001),
SuspendResume = (0x0002),
GetContext = (0x0008),
SetContext = (0x0010),
SetInformation = (0x0020),
GetInformation = (0x0040),
SetThreadToken = (0x0080),
Impersonate = (0x0100),
DirectImpersonation = (0x0200)
}
[Flags]
public enum ProcessAccess : uint
{
Terminate = 0x00000001,
CreateThread = 0x00000002,
VMOperation = 0x00000008,
VMRead = 0x00000010,
VMWrite = 0x00000020,
DupHandle = 0x00000040,
SetInformation = 0x00000200,
QueryInformation = 0x00000400,
SuspendResume = 0x00000800,
Synchronize = 0x00100000,
All = 0x001F0FFF
}

[DllImport("ntdll.dll", EntryPoint = "NtSuspendProcess", SetLastError = true)]
public static extern uint SuspendProcess(IntPtr processHandle);

[DllImport("ntdll.dll", EntryPoint = "NtResumeProcess", SetLastError = true)]
public static extern uint ResumeProcess(IntPtr processHandle);

[DllImport("kernel32.dll")]
public static extern IntPtr OpenProcess(ProcessAccess dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

[DllImport("kernel32.dll")]
public static extern IntPtr OpenThread(ThreadAccess dwDesiredAccess, bool bInheritHandle, uint dwThreadId);

[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool CloseHandle(IntPtr hObject);

[DllImport("kernel32.dll")]
public static extern uint SuspendThread(IntPtr hThread);

[DllImport("kernel32.dll")]
public static extern int ResumeThread(IntPtr hThread);
"@
		    }
			Catch
			{
			}
		#endregion Create Threader Namespace

        #region Build Process List
            [System.Collections.ArrayList]$ArrHashExport = @()

            $RunningProcesses = Get-WmiObject -Class Win32_Process | Select-Object -Property Name,Handle,Path # | Sort-Object Name -Unique
			$HashReturn['ManageProcessHash'].TotalQueried = $RunningProcesses | Measure-Object | Select-Object -ExpandProperty Count
			#Where-Object -FilterScript { $_.Path -ne $null } | Select-Object -Property Name,Handle,Path | Sort-Object Name -Unique

            $RunningProcesses | ForEach-Object `
            -Process `
            {
                $CurRunProc = $_
                
                #region Process Try Catch
                    Try
                    {
                        $CurProcess 	= [string]$CurProcess = $CurRunProc | Select-Object -ExpandProperty Name
                    }
                    Catch
                    {
                        $CurProcess = ''
                    }
                #endregion Process Try Catch
                
                #region Handle Try Catch
                    Try
                    {
                        $CurHandle 	= [int]$CurHandle = $CurRunProc | Select-Object -ExpandProperty Handle
                    }
                    Catch
                    {
                        $CurHandle = ''
                    }
                #endregion Handle Try Catch
                
                #region Path Try Catch
                    Try
                    {
                        $CurPath 	= [string]$CurPath = $CurRunProc | Select-Object -ExpandProperty Path
                    }
                    Catch
                    {
                        $CurPath = ''
                    }
                #endregion Path Try Catch
                
                #region Hash Try Catch
                    Try
                    {
                        $CurHash 	= [string]$(Get-HashInfo -Path $CurPath -Algorithm $Algorithm -ErrorAction SilentlyContinue)
                    }
                    Catch
                    {
                        $CurHash = ''
                    }
                #endregion Hash Try Catch
                
				$ObjHashExport 	= New-Object -TypeName PSObject -Property @{
                    'Process' 	= $CurProcess
					'Handle' 	= $CurHandle
					'Path' 		= $CurPath
					'Hash' 		= $CurHash
					'Action' 	= 'Report'
					'Status' 	= 'True'
					'Comment'	= ''
				}

                $null = $($ArrHashExport += $ObjHashExport)
			}
		#endregion Build Process List
		
		#region Filter List
			If
			(
				-Not $($FilterType -eq 'Process' -and $Pattern -eq '.*')
			)
			{
				$ArrFilterExport = $ArrHashExport | Where-Object -Property $FilterType -Match $Pattern
				[System.Collections.ArrayList]$ArrHashExport = @()
				$null = $($ArrHashExport += $ArrFilterExport)
			}
		#endregion Filter List
		
		#region Manage Process
			If
			(
				$ArrHashExport
			)
			{
				if
				(
					-Not $($Managetype -eq 'Report')
				)
				{
					$ArrHashExport | ForEach-Object `
					-Process `
					{
						$CurHashExportItem = $_
						
						$CurProcessHandle = ($pProc = [Threader]::OpenProcess('SuspendResume', $false, $($CurHashExportItem.Handle))) `
							-ne [IntPtr]::Zero
						
						switch
	                    (
	                        $Managetype
	                    )
	                    {
	                        'Suspend'
	                        {
	                            if
	                            (
	                                $CurProcessHandle
	                            )
	                            {
									Try
									{
										$Error.Clear()
		                                $result = [Threader]::SuspendProcess($pProc)

		                                if
		                                (
		                                    $result -ne 0
		                                )
		                                {
		                                    $CurHashExportItem.Action = 'Suspend'
		                                    $CurHashExportItem.Status = 'False'
											$CurHashExportItem.Commnt = $error[0].exception.message | out-string
		                                }
		                                else
		                                {
		                                    $CurHashExportItem.Action = 'Suspend'
		                                    $CurHashExportItem.Status = 'True'
		                                }
									}
									Catch
									{
										$CurHashExportItem.Action = 'Suspend'
	                                    $CurHashExportItem.Status = 'False'
										$CurHashExportItem.Commnt = $error[0].exception.message | out-string
									}
	                            }
	                            else
	                            {
	                                $CurHashExportItem.Action = 'Suspend'
	                                $CurHashExportItem.Status = 'False'
									$CurHashExportItem.Commnt = $error[0].exception.message | out-string
	                            }
	                        }
	                        'resume'
	                        {
	                            if
	                            (
	                                $CurProcessHandle
	                            )
	                            {
									Try
									{
			                            $result = [Threader]::ResumeProcess($pProc)

			                            if
			                            (
			                                $result -ne 0
			                            )
			                            {
											$CurHashExportItem.Action = 'Resume'
			                                $CurHashExportItem.Status = 'False'
											$CurHashExportItem.Commnt = $error[0].exception.message | out-string
			                            }
			                            else
			                            {
			                                $CurHashExportItem.Action = 'Resume'
			                                $CurHashExportItem.Status = 'True'
			                            }
									}
									Catch
									{
										$CurHashExportItem.Action = 'Resume'
		                                $CurHashExportItem.Status = 'False'
										$CurHashExportItem.Commnt = $error[0].exception.message | out-string
									}
	                            }
	                            else
	                            {
	                                $CurHashExportItem.Action = 'Resume'
	                                $CurHashExportItem.Status = 'False'
									$CurHashExportItem.Commnt = $error[0].exception.message | out-string
	                            }
	                        }
	                        'stop'
	                        {
								For
								(
									$i = 0
									$i -lt $TimerLoop
									$i++
								)
								{
									$CurProcess = $CurHashExportItem.Process
									
									If
									(
										#Get-Process -Name $($CurProcess).Replace('.exe','') -ErrorAction SilentlyContinue
										Get-Process | Where-Object -Property Name -eq $($CurProcess).Replace('.exe','')
									)
									{
										Try
										{
											$Error.Clear()
											Stop-Process -Name $($CurProcess).Replace('.exe','') -Force -ErrorAction Stop
										}
										Catch
										{
											If
											(
												#Get-Process -Name $($CurProcess).Replace('.exe','') -ErrorAction SilentlyContinue
												Get-Process | Where-Object -Property Name -eq $($CurProcess).Replace('.exe','')
											)
											{
												Try
												{
													$Error.Clear()
													#Force a 2nd pass using WMI
					                                $ProcessesPull = Get-WmiObject -Class Win32_Process -Filter "name='$CurProcess'" `
														-ErrorAction Stop
					                                $ProcessesPull | ForEach-Object `
					                                -Process `
					                                {
					                                    $CurValue = $_
					                                    $null = $CurValue.terminate()
					                                }
												}
												Catch
												{
												}
											}
										}
									}
									
									Start-Sleep -Seconds $SleepTime

	                                If
	                                (
	                                    #Get-Process -Name $($CurProcess).Replace('.exe','') -ErrorAction SilentlyContinue
										Get-Process | Where-Object -Property Name -eq $($CurProcess).Replace('.exe','')
	                                )
	                                {
	                                    $CurHashExportItem.Action = 'Stop'
	                                	$CurHashExportItem.Status = 'False'
										$CurHashExportItem.Commnt = $error[0].exception.message | out-string
	                                }
	                                Else
	                                {
	                                    $CurHashExportItem.Action = 'Stop'
	                                	$CurHashExportItem.Status = 'True'
										
										$i = $TimerLoop
	                                }
								}
	                        }
	                    }
					}
	            }
				}
		#endregion Manage Process

		#region Clean up 
            If
            (
                $pProc
            )
            {
                $null = [Threader]::CloseHandle($pProc)
            }
		#endregion Clean up 
    #endregion Main

	#region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['ManageProcessHash'].EndTime = $($EndTime).DateTime
        $HashReturn['ManageProcessHash'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
			Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds
		$null = $HashReturn['ManageProcessHash'].Processes.Add($ArrHashExport)
		$HashReturn['ManageProcessHash'].CountFound = $ArrHashExport | Measure-Object | Select-Object -ExpandProperty Count
		
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
						break
					}
				#endregion Beatify the JSON return and not Escape any Characters
				
				#region Return a PowerShell Object
					{ $ReturnObject }
					{
						Return $ArrHashExport
						break
					}
				#endregion Return a PowerShell Object
				
				#region Default
					Default
					{
						Return $HashReturn
						break
					}
				#endregion Default
			}
		#endregion Output Type
    #endregion Output
}
#endregion Invoke-BluGenieProcessHash (Function)