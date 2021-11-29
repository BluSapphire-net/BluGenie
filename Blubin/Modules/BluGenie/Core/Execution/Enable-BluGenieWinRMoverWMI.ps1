#region Enable-BluGenieWinRMoverWMI (Function)
Function Enable-BluGenieWinRMoverWMI
{
<#
    .SYNOPSIS
        Enable-BluGenieWinRMoverWMI will try and connect to a remote host and enable WinRM

    .DESCRIPTION
        Enable-BluGenieWinRMoverWMI will try and connect to a remote host and enable WinRM.  The Service, Firewall, and Configuration will be enabled.

    .PARAMETER ComputerName
        Description: Computer name of the remote host
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER looptimer
        Description: How long to wait before processing another loop
        Notes:  Default 5 seconds
        Alias:
        ValidateSet: 

    .PARAMETER termloopcounter
        Description: How many times the process should loop before exiting
        Notes:  Default 6 times
        Alias:
        ValidateSet: 

    .PARAMETER MaxConcurrentUsers
        Description: Set WMI value for MaxConcurrentUsers
        Notes:  Default 25
        Alias:
        ValidateSet: 

    .PARAMETER MaxProcessesPerShell
        Description: Set WMI value for MaxConcurrentUsers
        Notes:  Default 100
        Alias:
        ValidateSet: 

    .PARAMETER MaxMemoryPerShellMB
        Description: Set WMI value for MaxMemoryPerShellMB
        Notes:  Default 1024
        Alias:
        ValidateSet: 

    .PARAMETER MaxShellsPerUser
        Description: Set WMI value for MaxShellsPerUser
        Notes:  Default 30
        Alias:
        ValidateSet: 

    .PARAMETER MaxShellRunTime
        Description: Set WMI value for MaxShellRunTime
        Notes:  Default 2147483647 for PowerShell 3.0 and above
        Alias:
        ValidateSet: 

    .PARAMETER SetMaxValues
        Description: Allow for WMI value to be set to the Max Values and overwrite any parameters given.
        Notes:  
        Alias:
        ValidateSet: 

    .PARAMETER SetValues
        Description: Allow for WMI value to be set.
        Notes:  By default this is view only
        Alias:
        ValidateSet: 

    .PARAMETER ReturnDetails
        Description: Gather more detailed information on WMI and PowerShell
        Notes:  By default the return is (True / False) for Enabled or not
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
		
    .PARAMETER FormatView
		Description: Select which format to return the object data in.
		Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
		Alias:
		ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'

    .EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -ComputerName [Computer Name]
        Description: This will enable WinRM over WMI
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -OutUnEscapedJSON
        Description: Enable-BluGenieWinRMoverWMI and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -ReturnObject
        Description: Enable-BluGenieWinRMoverWMI and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -ReturnObject -FormatView JSON
        Description: Enable-BluGenieWinRMoverWMI and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Enable-BluGenieWinRMoverWMI -ReturnObject -FormatView Custom
        Description: Enable-BluGenieWinRMoverWMI and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1812.2301
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 2002.2801
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            : 
        * Link                      :
            ~ 
        * Dependencies              :
            ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 1812.2301: [Michael Arroyo] * Posted
            ~ 1901.0201: [Michael Arroyo] * Updated the WMI call to not run an external version of Powershell before trying to run.
            ~ 1903.1901: [Michael Arroyo] * Updated the looptimer variable to 0/Zero. By default each Invoke-Command has a 20 sec delay if the 
                                            system is having issues or slow.
                         [Michael Arroyo] * Updated the termloopcounter variable to 1. By default each Invoke-Command has a 20 sec delay if the 
                                            system is having issues or slow.
                         [Michael Arroyo] * Changed the Do While counter and the got this function down to less then 2 min on failed computer.
            ~ 2001.1301: [Michael Arroyo] * Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                         [Michael Arroyo] * Updated the Hash Information to follow the new function standards
                         [Michael Arroyo] * Added more detailed information to the Return data
                         [Michael Arroyo] * Changed the query process to detect WinRm first and not WMI
			~ 2002.2801: [Michael Arroyo] * Fixed the $CurSystem value to be set with either FQDN or Hostname.
                                                    
#>
    [cmdletbinding()]
    [Alias('Enable-WinRMoverWMI')]
    Param
    (
        [Parameter(Position = 0)]
        [string]$ComputerName,

        [Int]$looptimer = 5,

        [Int]$termloopcounter = 6,

        [Int]$MaxConcurrentUsers = 25,

        [Int]$MaxProcessesPerShell = 100,

        [Int]$MaxMemoryPerShellMB = 1024,

        [Int]$MaxShellsPerUser = 30,

        [Int]$MaxShellRunTime = 2147483647,

        [switch]$SetMaxValues,

        [switch]$SetValues,

        [switch]$ReturnDetails,

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject,

        [Switch]$OutUnEscapedJSON,

        [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
        [string]$FormatView = 'Table'
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
        $HashReturn['EnableWinRM'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['EnableWinRM'].StartTime = $($StartTime).DateTime
        $HashReturn['EnableWinRM'] = @{
            Enabled = $false
            Comments = @()
            ValidComputerName = ''
            OrgConnectionBroker = ''
            PSVersion = ''
			Status = ''
        }
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['EnableWinRM'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Set MaxValues
            $MaxConcurrentUsersPS2 = 100
            $MaxConcurrentUsersPS3 = 100

            $MaxProcessesPerShellPS2 = 2147483647
            $MaxProcessesPerShellPS3 = 2147483647
                            
            $MaxMemoryPerShellMBPS2 = 1024
            $MaxMemoryPerShellMBPS3 = 2147483647
                            
            $MaxShellsPerUserPS2 = 2147483647
            $MaxShellsPerUserPS3 = 2147483647
                            
            $MaxShellRunTimePS2 = 2147483647
            $MaxShellRunTimePS3 = 2147483647
        #endregion Detect and Set MaxValues
		
		#region Check Status
			$HashReturn['EnableWinRM'].Status = $(Resolve-BgDnsName -ComputerName $ComputerName -ReturnObject)
		#endregion Check Status

		If
		(
			$HashReturn['EnableWinRM'].Status.Results -eq 'Up'
		)
		{
	        #region Run Check
                $DNSCurSystem = $HashReturn.EnableWinRM.Status.ComputerName
                Try
                {
                    $CurSystem = Invoke-Command -ComputerName $DNSCurSystem -ScriptBlock {"$env:computername"} -ErrorAction Stop
                    $HashReturn.EnableWinRM.OrgConnectionBroker = 'WinRM'
                    $HashReturn.EnableWinRM.ValidComputerName = $CurSystem
                    $ReturnWinRM = 'WinRm Enabled'
                }
                Catch
                {
                    $HashReturn['EnableWinRM'].Comments += Get-ErrorAction
                    Try
                    {
                        $CurSystem = Get-WmiObject -ComputerName $DNSCurSystem -Class Win32_OperatingSystem -ErrorAction Stop | Select-Object -ExpandProperty CSName
                        $HashReturn.EnableWinRM.OrgConnectionBroker = 'WMI'
                        $HashReturn.EnableWinRM.ValidComputerName = $CurSystem
                    }
                    Catch
                    {
                        $HashReturn['EnableWinRM'].Comments += Get-ErrorAction
                    }
					
					$CurSystem = $DNSCurSystem
                }
	        #endregion Run Check
			
			If
			(
                    $HashReturn.EnableWinRM.OrgConnectionBroker
			)
			{
		        #region Update WinRM
		            $loopcount = 0

		            do
		            {
		                Try
		                {
		                    $ReturnWinRM = Invoke-Command -ComputerName $CurSystem -ScriptBlock {"WinRm Enabled"} -ErrorAction Stop
		                    $HashReturn.EnableWinRM.loopcount = $($loopcount)
		                    $HashReturn.EnableWinRM.Enabled = $true
		                    $loopcount = $termloopcounter
		                    $HashReturn.EnableWinRM.PSVersion = $(Invoke-Command -ComputerName $ComputerName -ScriptBlock { $PSVersionTable.PSVersion } | Select-Object -ExpandProperty Major | Out-String) -replace '\s'

		                    #region Set WinRM Configuration Values
		                        If
		                        (
		                            $SetValues
		                        )
		                        {
		                            If
		                            (
		                                $HashReturn.EnableWinRM.PSVersion -match '2'
		                            )
		                            {
		                                If
		                                (
		                                    $SetMaxValues
		                                )
		                                {
		                                    $WinRMCmd = 'Set WinRM/Config/WinRS @{MaxConcurrentUsers="' + $MaxConcurrentUsersPS2 + '";MaxProcessesPerShell="' + $MaxProcessesPerShellPS2 + '";MaxMemoryPerShellMB="' + $MaxMemoryPerShellMBPS2 + 
		'";MaxShellsPerUser="' + $MaxShellsPerUserPS2 + '";MaxShellRunTime="' + $MaxShellRunTimePS2 + '"} -Remote:' + $ComputerName
		                                    Start-Process -FilePath $('{0}\Windows\System32\WinRm.cmd' -f $env:SystemDrive) -ArgumentList $WinRMCmd -WindowStyle Hidden -ErrorAction SilentlyContinue
		                                    Start-Sleep -Seconds 2
		                                    $WinRMReturnConfig = Invoke-Expression -Command $('{0}\Windows\System32\WinRm.cmd Get WinRM/Config/WinRS -Remote:{1}' -f $env:SystemDrive, $ComputerName) | Select-String -Pattern '\=' | Out-String
		                                    $HashReturn.EnableWinRM.Config = $WinRMReturnConfig.Trim() -replace '\r\n\s+',"`r`n" -split '\r\n'
		                                }
		                                Else
		                                {
		                                    $WinRMCmd = 'Set WinRM/Config/WinRS @{MaxConcurrentUsers="' + $MaxConcurrentUsers + '";MaxProcessesPerShell="' + $MaxProcessesPerShell + '";MaxMemoryPerShellMB="' + $MaxMemoryPerShellMB + 
		'";MaxShellsPerUser="' + $MaxShellsPerUser + '";MaxShellRunTime="' + $MaxShellRunTime + '"} -Remote:' + $ComputerName
		                                    Start-Process -FilePath $('{0}\Windows\System32\WinRm.cmd' -f $env:SystemDrive) -ArgumentList $WinRMCmd -WindowStyle Hidden -ErrorAction SilentlyContinue
		                                    Start-Sleep -Seconds 2
		                                    $WinRMReturnConfig = Invoke-Expression -Command $('{0}\Windows\System32\WinRm.cmd Get WinRM/Config/WinRS -Remote:{1}' -f $env:SystemDrive, $ComputerName) | Select-String -Pattern '\=' | Out-String
		                                    $HashReturn.EnableWinRM.Config = $WinRMReturnConfig.Trim() -replace '\r\n\s+',"`r`n" -split '\r\n'
		                                }
		                            }
		                            Else
		                            {
		                                If
		                                (
		                                    $SetMaxValues
		                                )
		                                {
		                                    $WinRMCmd = 'Set WinRM/Config/WinRS @{MaxConcurrentUsers="' + $MaxConcurrentUsersPS3 + '";MaxProcessesPerShell="' + $MaxProcessesPerShellPS3 + '";MaxMemoryPerShellMB="' + $MaxMemoryPerShellMBPS3 + 
		'";MaxShellsPerUser="' + $MaxShellsPerUserPS3 + '";MaxShellRunTime="' + $MaxShellRunTimePS3 + '"} -Remote:' + $ComputerName
		                                    Start-Process -FilePath $('{0}\Windows\System32\WinRm.cmd' -f $env:SystemDrive) -ArgumentList $WinRMCmd -WindowStyle Hidden -ErrorAction SilentlyContinue
		                                    Start-Sleep -Seconds 2
		                                    $WinRMReturnConfig = Invoke-Expression -Command $('{0}\Windows\System32\WinRm.cmd Get WinRM/Config/WinRS -Remote:{1}' -f $env:SystemDrive, $ComputerName) | Select-String -Pattern '\=' | Out-String
		                                    $HashReturn.EnableWinRM.Config = $WinRMReturnConfig.Trim() -replace '\r\n\s+',"`r`n" -split '\r\n'
		                                }
		                                Else
		                                {
		                                    $WinRMCmd = 'Set WinRM/Config/WinRS @{MaxConcurrentUsers="' + $MaxConcurrentUsers + '";MaxProcessesPerShell="' + $MaxProcessesPerShell + '";MaxMemoryPerShellMB="' + $MaxMemoryPerShellMB + 
		'";MaxShellsPerUser="' + $MaxShellsPerUser + '";MaxShellRunTime="' + $MaxShellRunTime + '"} -Remote:' + $ComputerName
		                                    Start-Process -FilePath $('{0}\Windows\System32\WinRm.cmd' -f $env:SystemDrive) -ArgumentList $WinRMCmd -WindowStyle Hidden -ErrorAction SilentlyContinue
		                                    Start-Sleep -Seconds 2
		                                    $WinRMReturnConfig = Invoke-Expression -Command $('{0}\Windows\System32\WinRm.cmd Get WinRM/Config/WinRS -Remote:{1}' -f $env:SystemDrive, $ComputerName) | Select-String -Pattern '\=' | Out-String
		                                    $HashReturn.EnableWinRM.Config = $WinRMReturnConfig.Trim() -replace '\r\n\s+',"`r`n" -split '\r\n'
		                                }
		                            }
		                        }
		                    #endregion Set WinRM Configuration Values
		                }
		                Catch
		                {
		                    $HashReturn['EnableWinRM'].Comments += Get-ErrorAction
		                    Try
		                    {
		                        $null = Invoke-WmiMethod -ComputerName $CurSystem -Path win32_process -Name create -ArgumentList 'powershell.exe -command Enable-PSRemoting -SkipNetworkProfileCheck -Force' -ErrorAction Stop
		                        $null = Invoke-WmiMethod -ComputerName $CurSystem -Path win32_process -Name create -ArgumentList 'powershell.exe -command winrm quickconfig -quiet' -ErrorAction Stop
		                        $null = Invoke-WmiMethod -ComputerName $CurSystem -Path win32_process -Name create -ArgumentList 'powershell.exe -command Start-Service -Name WinRM' -ErrorAction Stop
		                    }
		                    Catch
		                    {
		                        $HashReturn['EnableWinRM'].Comments += Get-ErrorAction
		                    }

		                    Start-Sleep -Seconds $looptimer
		                    $loopcount += 1
		                    $HashReturn.EnableWinRM.loopcount = $($loopcount)
		                }
		            }
		            while
		            (
		                $loopcount -ne $termloopcounter
		            )
		        #endregion Update WinRM
			}
			Else
			{
				Write-Error -Message 'No Connection Broker found'
				$HashReturn['EnableWinRM'].Comments += Get-ErrorAction
			}	
		}
		Else
		{
			Write-Error -Message $('{0} is Offline' -f $($HashReturn.EnableWinRM.Status.ComputerName))
			$HashReturn['EnableWinRM'].Comments += Get-ErrorAction
		}

    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['EnableWinRM'].EndTime = $($EndTime).DateTime
        $HashReturn['EnableWinRM'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | 
                                                     Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $ReturnDetails
        )
        {
            Return $($HashReturn.EnableWinRM.Enabled)
        }

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
						#region Switch FormatView
	                        switch 
                            (
                                $FormatView
                            )
	                        {
		                        #region Table
			                        'Table'
			                        {
				                        Return $($<Updated_2_Object> | Format-Table -AutoSize -Wrap)
			                        }
		                        #endregion Table

                                #region CSV
			                        'CSV'
			                        {
				                        Return $($<Updated_2_Object> | ConvertTo-Csv -NoTypeInformation)
			                        }
		                        #endregion CSV

                                #region CustomModified
			                        'CustomModified'
			                        {
				                        Return $($<Updated_2_Object> | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
			                        }
		                        #endregion CustomModified

                                #region Custom
			                        'Custom'
			                        {
				                        Return $($<Updated_2_Object> | Format-Custom)
			                        }
		                        #endregion Custom

                                #region JSON
			                        'JSON'
			                        {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($<Updated_2_Object> | ConvertTo-Json -Depth 10)
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
                                            Return $($<Updated_2_Object> | ConvertTo-Json -Depth 10 | ForEach-Object `
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
			                            Return $CurSessionInfo
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
#endregion Enable-BluGenieWinRMoverWMI (Function)