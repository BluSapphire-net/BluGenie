#region Disable-BluGenieAllFirewallRules (Function)
Function Disable-BluGenieAllFirewallRules
{
<#
    .SYNOPSIS
        Disable Firewall Rule(s)

    .DESCRIPTION
        Disable Firewall Rule(s) without removing them and backup the data to (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules).

    .PARAMETER Force
        Description: Force will override the default flag, which will allow the process to run even though the (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) key exists.
        Notes:  This will not remove the (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) flag.
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
        Description: Removed UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias: 
        ValidateSet: 

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules
        Description: Disable all ( Enabled ) Windows Firewall Rules
        Notes: If the (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) key exists, the process will be skipped

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules -Force
        Description: Forcefully disable all ( Enabled ) Windows Firewall Rules
        Notes: This will bypass the (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) key.

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules -WalkThrough
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules -OutUnEscapedJSON
        Description: Disable all ( Enabled ) Windows Firewall Rules.  Return Output as UnEscaped JSON
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters

    .EXAMPLE
	    Command: Disable-BluGenieAllFirewallRules -ReturnObject
        Description: Disable all ( Enabled ) Windows Firewall Rules.  Return Output as Objects
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1809.1501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1910.1801
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough
                                        ~ Disable-FireWallRule
        * Build Version Details     :
                                        ~ 1910.1001: * [Michael Arroyo] Posted
                                        ~ 1809.1501: * [Michael Arroyo] Posted
                                        ~ 1901.2601: * [Michael Arroyo] Added the Completed Flag so a new instance of this process will not run on its own
                                                     * [Michael Arroyo] Added the Force switch to bypass the Completed Flag
                                        ~ 1902.0501: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information            
                                        ~ 1910.1801: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                     * [Michael Arroyo] Added support for ReturnObject
                                                     * [Michael Arroyo] Updated the -Help | -WalkThrough parameter.  If Invoke-WalkThrough is an active function it will be called.  If not the default help will be called.
#>
    Param
    (
        [Parameter(Position=0)]
        [Switch]$Force,

        [Parameter(Position=2)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=3)]
        [Switch]$ReturnObject,

        [Parameter(Position=4)]
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
        $HashReturn['DisableAllFirewallRules'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['DisableAllFirewallRules'].StartTime = $($StartTime).DateTime
        $HashReturn['DisableAllFirewallRules']['Rulenames'] = @()
        $HashReturn['DisableAllFirewallRules']['Status'] = @()
        $HashReturn['DisableAllFirewallRules']['Comments'] = @()

    #endregion

    #region Parameter Set Results
        $HashReturn['DisableAllFirewallRules'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)
            If
            (
                Get-ItemProperty -Path 'HKLM:\SOFTWARE\BluGenie\FirewallRules' -Name 'DisabledFWRFlag' -ErrorAction SilentlyContinue
            )
            {
                $FlagCheck = $true
            }
            Else
            {
                $FlagCheck = $false
            }

            $HashReturn['DisableAllFirewallRules'].FlagCheck = $FlagCheck
        #endregion Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)

        #region Allow Disable to Process
            $Process = $false
            If
            (
                $FlagCheck
            )
            {
                If
                (
                    $Force
                )
                {
                    $Process = $true
                }
            }
            Else
            {
                $Process = $true
            }
        #endregion Allow Disable to Process

        #region Disable Rules Main
            If
            (
                $Process
            )
            {
                $objFirewall = New-Object -ComObject HNetCfg.FwPolicy2
                $HashReturn['DisableAllFirewallRules']['Rulenames'] = $objFirewall.Rules | Select-Object -ExpandProperty Name -Unique

                #region Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)
                    If
                    (
                            Get-Item -Path 'HKLM:\SOFTWARE\BluGenie\FirewallRules' -ErrorAction SilentlyContinue
                    )
                    {
                        $HashReturn['DisableAllFirewallRules'].BackupKeyExists = $true
                    }
                    Else
                    {
                        $HashReturn['DisableAllFirewallRules'].BackupKeyExists = $false
                    }
                #endregion Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)

                #region Backup Rules
                    If
                    (
                        $HashReturn['DisableAllFirewallRules'].BackupKeyExists -eq $false -or $Force -eq $true
                    )
                    {
                            $HashReturn['DisableAllFirewallRules'].BackupCount = $($HashReturn['DisableAllFirewallRules']['Rulenames']).Count

                            Try
                            {
                                $Error.Clear()
                                $null = New-Item -Path 'HKLM:\SOFTWARE\BluGenie\FirewallRules' -Force -ErrorAction Stop
                                $null = New-ItemProperty -Path HKLM:\SOFTWARE\BluGenie\FirewallRules -Name Enabled_Backup -Value $($HashReturn['DisableAllFirewallRules']['Rulenames']) -Type MultiString -Force -ErrorAction Stop

                                $HashReturn['DisableAllFirewallRules']['Status'] = Disable-FirewallRule -RuleName $($HashReturn['DisableAllFirewallRules']['Rulenames']) -ReturnObject -ErrorAction SilentlyContinue

                                $null = New-ItemProperty -Path HKLM:\SOFTWARE\BluGenie\FirewallRules -Name DisabledFWRFlag -Value $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss)) -Type String -Force -ErrorAction SilentlyContinue
                            }
                            Catch
                            {
                                $HashReturn['DisableAllFirewallRules']['Comments'] += $($Error.exception.message)
                            }
                    }
                #endregion Backup Rules
            }
        #endregion Disable Rules Main
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['DisableAllFirewallRules'].EndTime = $($EndTime).DateTime
        $HashReturn['DisableAllFirewallRules'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $HashReturn['DisableAllFirewallRules']['Status'] | Select-Object -Property Enabled,Name
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
#endregion Disable-BluGenieAllFirewallRules (Function)