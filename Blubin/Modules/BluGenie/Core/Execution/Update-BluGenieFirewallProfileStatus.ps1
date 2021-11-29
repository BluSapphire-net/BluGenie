#region Update-BluGenieFirewallProfileStatus (Function)
Function Update-BluGenieFirewallProfileStatus
{
<#
    .SYNOPSIS
        Enable or Disable the Window Firewall Profile(s) *Not the Service*

    .DESCRIPTION
        Enable or Disable the Window Firewall Profile(s) *Not the Service*

    .PARAMETER ProfileType
        Description:  Select which profile to update
        Notes: 
                - DOMAIN
                - PRIVATE
                - PUBLIC
                - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
        Alias:
        ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'

    .PARAMETER Status
        Description: Option to enable or disable the Firewall Profile  
        Notes:  - ENABLE - (Default Selection)
                - DISABLE
        Alias:
        ValidateSet: 'ENABLE','DISABLE'

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
	    Command: Update-BluGenieFirewallProfileStatus
        Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on
        Notes: 

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -ProfileType PRIVATE -Status DISABLE
        Description: Set the Windows Firewall Profile "PRIVATE" to disabled
        Notes: 

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -ProfileType DOMAIN -Status ENABLE
        Description: Set the Windows Firewall Profile "DOMAIN" to Enabled
        Notes: 

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -Status DISABLE
        Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to disabled / off
        Notes: 

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -OutUnEscapedJSON
        Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Update-BluGenieFirewallProfileStatus -ReturnObject
        Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1809.1501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 20.05.2101
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough
        * Build Version Details     :
                                        ~ 1809.1501: * [Michael Arroyo] Posted
                                        ~ 1902.0701: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                        ~ 1910.2401: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                     * [Michael Arroyo] Added support for ReturnObject
										~ 1911.1601: * [Michael Arroyo] Updated the Firewall Status Information content.  Data is now being captured from NetSH.exe
                                        ~ 1911.2001: * [Michael Arroyo] Set Type Cast for the ProfileType and Status Parameters.  This indentifier is used in the Dynamic Help Meny system
										~ 1912.1601: * [Michael Arroyo] Added a ReportOnly Parameter
													 * [Michael Arroyo] Updated the Status Output to only show Profiles that are selected from the ProfileType parameter
													 * [Michael Arroyo] Removed Parameter Positions for ( Walkthrough, ReturnObject, and OutUnEscapedJSON ) parameters
										~ 1912.1801: * [Michael Arroyo] Added Comment section to the HashTable
													 * [Michael Arroyo] Added more error control  around the Service Restart
                                        ~ 20.05.2101:* [Michael Arroyo] Updated to support Posh 2.0
#>
    [Alias('Update-FirewallProfileStatus')]
    Param
    (
        [Parameter(Position = 1)]
        [ValidateSet('DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC')]
        [String]$ProfileType = 'DOMAIN+PRIVATE+PUBLIC',

        [Parameter(Position = 2)]
        [ValidateSet('ENABLE','DISABLE')]
        [String]$Status = 'ENABLE',
		
		[Switch]$ReportOnly,

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
        $HashReturn['UpdateFirewallProfileStatus'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['UpdateFirewallProfileStatus'].StartTime = $($StartTime).DateTime
        $HashReturn['UpdateFirewallProfileStatus']['Status'] = @()
		$HashReturn['UpdateFirewallProfileStatus']['Comments'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['UpdateFirewallProfileStatus'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Constants
            $FWDOMAIN = 'domainprofile'
            $FWPRIVATE = 'privateprofile'
            $FWPUBLIC = 'publicprofile'
        #endregion Constants

        #region Manage Profile Type
            $ProfileList = @()

            switch
            (
                $ProfileType
            )
            {
                'DOMAIN'
                {
                    $ProfileList += "$FWDOMAIN"
                    break
                }
                'PRIVATE'
                {
                    $ProfileList += "$FWPRIVATE"
                    break
                }
                'PUBLIC'
                {
                    $ProfileList += "$FWPUBLIC"
                    break
                }
                'DOMAIN+PRIVATE+PUBLIC'
                {
                    $ProfileList += "$FWDOMAIN"
                    $ProfileList += "$FWPRIVATE"
                    $ProfileList += "$FWPUBLIC"
                    break
                }
            }
        #endregion Manage Profile Type

        #region Manage Profile Status
			If
			(
				-Not $ReportOnly
			)
			{
	            $ArrProfileUpdate = @()

	            $ProfileList | ForEach-Object `
	            -Process `
	            {
	                $Profile = $_

	                If
	                (
	                    $Status -eq 'Enable'
	                )
	                {
	                    $EnableFlag = 'on'
	                }
	                else
	                {
	                    $EnableFlag = 'off'
	                }

	                $null = Invoke-Expression -Command "$env:SystemDrive\Windows\System32\netsh.exe advfirewall set $Profile state $EnableFlag"

					Try
					{
						$Error.clear()
	                	$null = Restart-Service -Name 'mpssvc' -Force -ErrorAction Stop
					}
					Catch
					{
						$ErrorReturn = New-Object -TypeName PSObject -Property @{
							'Error' = $($Error[0].exception | Out-String)
							'StackTrace' = $($Error[0].ScriptStackTrace -replace '^(.*)?,.*:\s(line\s\d?)','$1,$2' -split '\n') | Select-Object -First 1
						}
						
						$HashReturn['UpdateFirewallProfileStatus']['Comments'] += $ErrorReturn
						$null = Remove-Variable -Name ErrorReturn -Force
						$Error.clear()
					}
	            }
			}
		#endregion Manage Profile Status
		
		#region Capture Firewall Details
			$objFirewall = Invoke-Expression -Command "$env:SystemDrive\Windows\System32\netsh advfirewall show allprofiles"
			
			$ObjFireWallProp = @{
				'State' = $null
				'FirewallPolicy' = $null
				'LocalFirewallRules' = $null
				'LocalConSecRules' = $null
				'InboundUserNotification' = $null
				'RemoteManagement' = $null
				'UnicastResponseToMulticast' = $null
				'LogAllowedConnections' = $null
				'LogDroppedConnections' = $null
				'FileName' = $null
				'MaxFileSize' = $null
			    'Info' = $null
				'Profile' = $null
			}

			Function GetFireWallStatus
			{
			    Param
			    (
			        [Object]$ProfileObject
			    )
			        $CurRegEx = $_
			        Switch -Regex ($ProfileObject.Info)
			        {
			            #region State Information
				            '(State\s+(?<State>.*)\n)'
				            {
				                $ProfileObject.State = $Matches.State -replace '\r'
				            }
			            #endregion State Information
						
						#region Firewall Policy Information
				            '(Firewall\sPolicy\s+(?<FirewallPolicy>.*)\n)'
				            {
				                $ProfileObject.FirewallPolicy = $Matches.FirewallPolicy -replace '\r'
				            }
						#endregion Firewall Policy Information

						#region LocalFirewallRules Information
				            '(LocalFirewallRules\s+(?<LocalFirewallRules>.*)\n)'
				            {
				                $ProfileObject.LocalFirewallRules = $Matches.LocalFirewallRules -replace '\r'
				            }
						#endregion LocalFirewallRules Information

						#region LocalConSecRules Information
				            '(LocalConSecRules\s+(?<LocalConSecRules>.*)\n)'
				            {
				                $ProfileObject.LocalConSecRules = $Matches.LocalConSecRules -replace '\r'
				            }
						#endregion LocalConSecRules Information

						#region InboundUserNotification Information
				            '(InboundUserNotification\s+(?<InboundUserNotification>.*)\n)'
				            {
				                $ProfileObject.InboundUserNotification = $Matches.InboundUserNotification -replace '\r'
				            }
						#endregion InboundUserNotification Information

						#region RemoteManagement Information
				            '(RemoteManagement\s+(?<RemoteManagement>.*)\n)'
				            {
				                $ProfileObject.RemoteManagement = $Matches.RemoteManagement -replace '\r'
				            }
						#endregion RemoteManagement Information

						#region UnicastResponseToMulticast Information
				            '(UnicastResponseToMulticast\s+(?<UnicastResponseToMulticast>.*)\n)'
				            {
				                $ProfileObject.UnicastResponseToMulticast = $Matches.UnicastResponseToMulticast -replace '\r'
				            }
						#endregion UnicastResponseToMulticast Information

						#region LogAllowedConnections Information
				            '(LogAllowedConnections\s+(?<LogAllowedConnections>.*)\n)'
				            {
				                $ProfileObject.LogAllowedConnections = $Matches.LogAllowedConnections -replace '\r'
				            }
						#endregion LogAllowedConnections Information

						#region LogDroppedConnections Information
				            '(LogDroppedConnections\s+(?<LogDroppedConnections>.*)\n)'
				            {
				                $ProfileObject.LogDroppedConnections = $Matches.LogDroppedConnections -replace '\r'
				            }
						#endregion LogDroppedConnections Information

						#region FileName Information
				            '(FileName\s+(?<FileName>.*)\n)'
				            {
				                $ProfileObject.FileName = $Matches.FileName -replace '\r'
				            }
						#endregion FileName Information

						#region MaxFileSize Information
				            '(MaxFileSize\s+(?<MaxFileSize>.*)\n)'
				            {
				                $ProfileObject.MaxFileSize = $Matches.MaxFileSize -replace '\r'
				            }
						#endregion MaxFileSize Information
			        }

			    Return $ProfileObject
			}
					
			#region Domain Profile Scraping
				If
				(
					$ProfileType -match 'Domain'
				)
				{
					$null = $($objFirewall | Out-String) -match 'Domain\sProfile\sSettings:.*\n.*\n(?<Domain>.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n)'
					$ObjDomain = New-Object -TypeName psobject -Property $ObjFireWallProp
					$ObjDomain.Profile = 'Domain'
					$ObjDomain.Info = $Matches.Domain
					$ObjDomain = GetFireWallStatus -ProfileObject $ObjDomain
					$HashReturn['UpdateFirewallProfileStatus']['Status'] += $($ObjDomain | Select-Object -Property Profile,State,FirewallPolicy,LocalFirewallRules,LocalConSecRules,InboundUserNotification,RemoteManagement,UnicastResponseToMulticast,LogAllowedConnections,LogDroppedConnections,FileName,MaxFileSize)
				}
			#endregion Domain Profile Scraping

			#region Private Profile Scraping
				If
				(
					$ProfileType -match 'Private'
				)
				{
					$null = $($objFirewall | Out-String) -match 'Private\sProfile\sSettings:.*\n.*\n(?<Private>.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n)'
					$ObjPrivate = New-Object -TypeName psobject -Property $ObjFireWallProp
					$ObjPrivate.Profile = 'Private'
					$ObjPrivate.Info = $Matches.Private
					$ObjPrivate = GetFireWallStatus -ProfileObject $ObjPrivate
					$HashReturn['UpdateFirewallProfileStatus']['Status'] += $($ObjPrivate | Select-Object -Property Profile,State,FirewallPolicy,LocalFirewallRules,LocalConSecRules,InboundUserNotification,RemoteManagement,UnicastResponseToMulticast,LogAllowedConnections,LogDroppedConnections,FileName,MaxFileSize)
				}
			#endregion Private Profile Scraping

			#region Public Profile Scraping
				If
				(
					$ProfileType -match 'Public'
				)
				{
					$null = $($objFirewall | Out-String) -match 'Public\sProfile\sSettings:.*\n.*\n(?<Public>.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n)'
					$ObjPublic = New-Object -TypeName psobject -Property $ObjFireWallProp
					$ObjPublic.Profile = 'Public'
					$ObjPublic.Info = $Matches.Public
					$ObjPublic = GetFireWallStatus -ProfileObject $ObjPublic
					$HashReturn['UpdateFirewallProfileStatus']['Status'] += $($ObjPublic | Select-Object -Property Profile,State,FirewallPolicy,LocalFirewallRules,LocalConSecRules,InboundUserNotification,RemoteManagement,UnicastResponseToMulticast,LogAllowedConnections,LogDroppedConnections,FileName,MaxFileSize)
				}
			#endregion Public Profile Scraping
		#endregion Capture Firewall Details
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['UpdateFirewallProfileStatus'].EndTime = $($EndTime).DateTime
        $HashReturn['UpdateFirewallProfileStatus'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $($HashReturn['UpdateFirewallProfileStatus']['Status'])
        }
        Else
        {
            If
            (
                $OutUnEscapedJSON
            )
            {
                Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
            }
            Else
            {
                Return $HashReturn
            }
        }
    #endregion Output
}
#endregion Update-BluGenieFirewallProfileStatus (Function)