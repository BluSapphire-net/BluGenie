#region Trace-BluGenieFireWallStatus (Function)
Function Trace-BluGenieFireWallStatus
{
<#
    .SYNOPSIS
        Trace-BluGenieFireWallStatus will track and revert the Windows Firewall Service and Profile settings

    .DESCRIPTION
        Trace-BluGenieFireWallStatus will track and revert the Windows Firewall Service and Profile settings

    PARAMETER ProfileType
        Description:  Select which profile to update
        Notes: 
                - DOMAIN
                - PRIVATE
                - PUBLIC
                - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
        Alias:
        ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'

    .PARAMETER Revert
        Description: Revert the tracked changes that are found in the Registry 
        Notes: Information is saved in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus' 
        Alias: 
        ValidateSet: 
		
	.PARAMETER SnapShot
        Description: Take a SnapShot of the Firewall Service and Profile settings and save them in the registry
        Notes: Information is saved in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus' 
			   Snapshot is also enabled by default.
        Alias: 
        ValidateSet: 
		
	.PARAMETER Force
		Description: Force the snapshot information to over write any previously saved information in the registry
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
	    Command: Trace-BluGenieFireWallStatus
        Description: Track and backup the Firewall Service and Profile configuration
        Notes: 

    .EXAMPLE
	    Command: Trace-BluGenieFireWallStatus -Force
        Description: Force the backup of the Firewall Service and Profile configuration even if the information is already there.
        Notes: 
		
	.EXAMPLE
		Command: Trace-BluGenieFireWallStatus -Revert
		Description: Revert the Firewall Service and Profile configuration back to what was saved in the registry
		Notes: 

    .EXAMPLE
	    Command: Trace-BluGenieFireWallStatus -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Trace-BluGenieFireWallStatus -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Trace-BluGenieFireWallStatus -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Trace-BluGenieFireWallStatus -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.05.2101
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
										~ Get-ErrorAction				- Get-ErrorAction is a function that will round up any errors into a smiple object
        * Build Version Details     :
                                        ~ 1912.1901: * [Michael Arroyo] Posted
                                        ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
                                                    
#>
    [cmdletbinding()]
    [Alias('Track-FireWallStatus')]
    Param
    (
        [Parameter(Position = 1)]
        [ValidateSet('DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC')]
        [String]$ProfileType = 'DOMAIN+PRIVATE+PUBLIC',

        [Switch]$Revert,
		
		[Switch]$SnapShot = $true,
		
		[Switch]$Force,

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
        $HashReturn['TrackFireWallStatus'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TrackFireWallStatus'].StartTime = $($StartTime).DateTime
        $HashReturn['TrackFireWallStatus']['Comments'] = @()
		$HashReturn['TrackFireWallStatus']['SnapShot'] = @{
			Actioned = 'False'
		}
		$HashReturn['TrackFireWallStatus']['Revert'] = @{
			Actioned = 'False'
		}
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['TrackFireWallStatus'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results
	
	#region Clear the error list before starting
		$Error.Clear()
	#endregion Clear the error list before starting

    #region Main
		#region SnapShot
			If
			(
				$SnapShot -and $(-Not $Revert)
			)
			{
				$HashReturn['TrackFireWallStatus']['SnapShot'].Actioned = 'True'
			
				#region Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus)
	                If
	                (
	                    Test-Path -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus'
	                )
	                {
	                   	$HashReturn['TrackFireWallStatus']['SnapShot'].ParentKeyAlreadyExisted = 'True'
						$HashReturn['TrackFireWallStatus']['SnapShot'].GetFireWallStatusKeyCreated = 'Exists'
	                }
	                Else
	                {
	                   	$HashReturn['TrackFireWallStatus']['SnapShot'].ParentKeyAlreadyExisted = 'False'
						
						Try
	                    {
	                        $null = New-Item -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Force -ErrorAction Stop
	                       	$HashReturn['TrackFireWallStatus']['SnapShot'].GetFireWallStatusKeyCreated = 'True'
	                        
	                    }
	                    Catch
	                    {
							$HashReturn['TrackFireWallStatus']['SnapShot'].GetFireWallStatusKeyCreated = 'False'
							$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
	                    }
	                }
	            #endregion Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus)
				
				#region Pull Service Info
					Try
					{
						$CurServiceObj = Get-Service -Name 'mpssvc' -ErrorAction Stop | Select-Object Name, 
																							  DisplayName, 
																							  @{
																							      Name = 'Status'
																								  Expression = {
																								  	$($_.Status).ToString().Trim()
																								  }
																							  },
																							  @{
																							      Name = 'StartType'
																								  Expression = {
																								  	$($_.StartType).ToString().Trim()
																								  }
																							  }
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
				#endregion Pull Service Info
				
				#region Pull Profile Info
					Try
					{
						$ProfileInfo = Update-FirewallProfileStatus -ReportOnly -ReturnObject -ProfileType $ProfileType -ErrorAction Stop
						$CurServiceObj | Add-Member -MemberType NoteProperty -Name 'Profile' -Value $ProfileInfo -Force -ErrorAction Stop
						$HashReturn['TrackFireWallStatus']['SnapShot'].Service = $CurServiceObj
						
						$CSVService = $CurServiceObj | ConvertTo-Csv -NoTypeInformation -ErrorAction Stop
						$CSVProfile = $CurServiceObj.Profile | ConvertTo-Csv -NoTypeInformation -ErrorAction Stop
						
						#region Take SnapShot
							If
							(
								$Force
							)
							{
								Try
								{
									$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Service' -Value $CSVService -Type MultiString -Force -ErrorAction Stop
									$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Profile' -Value $CSVProfile -Type MultiString -Force -ErrorAction Stop
								}
								Catch
								{
									$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
								}
							}
							Else
							{
								Try
								{
									$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Service' -Value $CSVService -Type MultiString -ErrorAction Stop
									$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Profile' -Value $CSVProfile -Type MultiString -ErrorAction Stop
								}
								Catch
								{
									$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
								}
							}
						#endregion Take SnapShot
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
				#endregion Pull Profile Info
			}
		#endregion Setup SnapShot
				
		#region Revert Settings back to the original
			If
			(
				$Revert
			)	
			{
				$HashReturn['TrackFireWallStatus']['Revert'].ServiceInfo = New-Object -TypeName System.Object
				$HashReturn['TrackFireWallStatus']['Revert'].Actioned = 'True'
				
				#region Pull Information from Registry
					Try
					{
						$ServiceInfo = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Service' -ErrorAction Stop | Select-Object -ExpandProperty 'Service' | ConvertFrom-Csv
						$ServiceInfo.Profile = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -Name 'Profile' -ErrorAction Stop | Select-Object -ExpandProperty 'Profile' | ConvertFrom-Csv
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
				#endregion Pull Information from Registry
				
				If
				(
					$ServiceInfo
				)
				{
					$ArrServiceInfo = @()
					$ObjServiceInfo = New-Object -TypeName PSObject -Property @{
							Profiles = @()
							Status = ''
							StartType = ''
						}
				
					$ServiceInfo.Profile | ForEach-Object `
					-Process `
					{
						$CurFWProfile = $_
						
						$ObjProfileInfo = New-Object -TypeName PSObject -Property @{
							Name = $CurFWProfile.Profile
							State = ''
							Set_InBound = ''
							Set_OutBound = ''
						}
						

						If
						(
							$CurFWProfile.State -eq 'ON'
						)
						{
							$CurFWStatus = 'ENABLE'
						}
						Else
						{
							$CurFWStatus = 'DISABLE'
						}
						
						If
						(
							$($CurFWProfile.FirewallPolicy).split(',')[0] -match 'Block'
						)
						{
							$CurInbound = 'Block'
						}
						Else
						{
							$CurInbound = 'Allow'
						}
						
						If
						(
							$($CurFWProfile.FirewallPolicy).split(',')[1] -match 'Block'
						)
						{
							$CurOutbound = 'Block'
						}
						Else
						{
							$CurOutbound = 'Allow'
						}
						
						$ReturnUpdateFirewall = $(Update-FirewallProfileStatus -ProfileType $($CurFWProfile.Profile) -Status $CurFWStatus -ReturnObject -ErrorAction SilentlyContinue)
						$ReturnSetFirewall = $(Set-FirewallStatus -ProfileType $($CurFWProfile.Profile) -InBound $($CurInbound) -OutBound $($CurOutbound) -ReturnObject -ErrorAction SilentlyContinue)
						
						If
						(
							$Error
						)
						{
							$ErrorReturn = New-Object -TypeName PSObject -Property @{
								'Error' = $($Error[0].exception | Out-String)
								'StackTrace' = $($Error[0].ScriptStackTrace -replace '^(.*)?,.*:\s(line\s\d?)','$1,$2' -split '\n') | Select-Object -First 1
							}
							
							$HashReturn['TrackFireWallStatus'].Comments += $ErrorReturn
							$null = Remove-Variable -Name ErrorReturn -Force
						}
						
						$ObjProfileInfo.State = $ReturnUpdateFirewall.State
						$ObjProfileInfo.Set_InBound = $ReturnSetFirewall.Set_InBound
						$ObjProfileInfo.Set_OutBound = $ReturnSetFirewall.Set_OutBound
						
						$ObjServiceInfo.Profiles += $ObjProfileInfo
					}
			
					Try
					{
						$null = Set-Service -Name $($serviceinfo.name) -StartupType $($serviceinfo.StartType) -ErrorAction Stop
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
						
					Try
					{
						switch
						(
							$serviceinfo.Status
						)
						{
							'Running'
							{
								$null = Start-Service -Name $($serviceinfo.name) -ErrorAction Stop
							}
							'Stopped'
							{
								$null = Stop-Service -Name $($serviceinfo.name) -Force -ErrorAction Stop
							}
						}
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
					
					Try
					{
						$CurUpdatedService = Get-Service -Name $($serviceinfo.name) | Select-Object Status,StartType
						
						$ObjServiceInfo.Status = $($CurUpdatedService.Status | Out-String).Trim()
						$ObjServiceInfo.StartType = $($CurUpdatedService.StartType | Out-String).Trim()
						
						$null = Remove-Item -Path 'HKLM:\SOFTWARE\BluGenie\GetFireWallStatus' -ErrorAction Stop
					}
					Catch
					{
						$HashReturn['TrackFireWallStatus'].Comments += Get-ErrorAction -Clear
					}
					
					$HashReturn['TrackFireWallStatus']['Revert'].ServiceInfo = $ObjServiceInfo
				}
			}
		#endregion Revert Settings back to the original
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TrackFireWallStatus'].EndTime = $($EndTime).DateTime
        $HashReturn['TrackFireWallStatus'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
						If
						(
							$Revert
						)
						{
							$ObjReturn = New-Object -TypeName PSObject -Property @{
								'Objective' = $HashReturn['TrackFireWallStatus']['Revert']
								'Comments' = $HashReturn['TrackFireWallStatus']['Comments']
							}
						}
						Else
						{
							$ObjReturn = New-Object -TypeName PSObject -Property @{
								'Objective' = $HashReturn['TrackFireWallStatus']['SnapShot']
								'Comments' = $HashReturn['TrackFireWallStatus']['Comments']
							}
						}
						Return $ObjReturn
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
#endregion Trace-BluGenieFireWallStatus (Function)