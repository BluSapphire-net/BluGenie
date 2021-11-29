#region Enable-BluGenieAllFirewallRules (Function)
Function Enable-BluGenieAllFirewallRules
{
<#
    .SYNOPSIS
        Enable Firewall Rule(s)

    .DESCRIPTION
        Enable Firewall Rule(s) that have been posted to (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules).

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
	    Command: Enable-BluGenieAllFirewallRules
        Description: This will Enable all Windows Firewall Rules that have been posted to (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules).
        Notes: The (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) Registry key Flag will also be removed

    .EXAMPLE
	    Command: Enable-BluGenieAllFirewallRules -Help
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieAllFirewallRules -WalkThrough
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieAllFirewallRules -OutUnEscapedJSON
        Description: The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters
        Notes:  

    .EXAMPLE
	    Command: Enable-BluGenieAllFirewallRules -ReturnObject
        Description: The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        Notes:  

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

                    * Original Author           : Michael Arroyo
                    * Original Build Version    : 1809.1501
                    * Latest Author             : Michael Arroyo
                    * Latest Build Version      : 1910.1701
                    * Comments                  :
                    * Dependencies              :
                                                    ~ Enable-FirewallRule
                                                    ~ Invoke-WalkThrough
                    * Build Version Details     :
                                                    ~ 1809.1501: * [Michael Arroyo] Posted
                                                    ~ 1901.2601: * [Michael Arroyo] Added the removal of the (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules[DisabledFWRFlag]) Registry key Flag
                                                    ~ 1902.0501: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                                    ~ 1910.1501: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                                 * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                                 * [Michael Arroyo] Added more detailed information to the Return data
                                                                 * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                                 * [Michael Arroyo] Added support for ReturnObject
                                                                 * [Michael Arroyo] Updated the -Help | -WalkThrough parameter.  If Invoke-WalkThrough is an active function it will be called.  If not the default help will be called.
#>
    [Alias('Enable-AllFirewallRules')]
    Param
    (
        [Parameter(Position=0)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=1)]
        [Switch]$ReturnObject,

        [Parameter(Position=2)]
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
        $HashReturn['EnableAllFirewallRules'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['EnableAllFirewallRules'].StartTime = $($StartTime).DateTime
        $HashReturn['EnableAllFirewallRules']['Rulenames'] = @()
        $HashReturn['EnableAllFirewallRules']['Status'] = @()
    #endregion

    #region Parameter Set Results
        $HashReturn['EnableAllFirewallRules'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)
            Try
            {
                $EnabledRules = Get-ItemProperty -Path HKLM:\SOFTWARE\BluGenie\FirewallRules -Name Enabled_Backup -ErrorAction Stop | Select-Object -ExpandProperty Enabled_Backup
                $HashReturn.EnableAllFirewallRules.Rulenames = $EnabledRules
            }
            Catch
            {
            }
        #endregion Registry Key Check for (HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\FirewallRules)

        #region Enabled Rule(s)
            If
            (
                $EnabledRules
            )
            {
                $HashReturn.EnableAllFirewallRules.Status = Enable-FirewallRule -RuleName $EnabledRules -ReturnObject

                #region Remove Registry Flag
                    $null = Remove-Item -Path 'HKLM:\SOFTWARE\BluGenie\FirewallRules' -Force -ErrorAction SilentlyContinue
                #endregion
            }
        #endregion Enabled Rule(s)
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['EnableAllFirewallRules'].EndTime = $($EndTime).DateTime
        $HashReturn['EnableAllFirewallRules'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $HashReturn.EnableAllFirewallRules.Status
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
#endregion Enable-BluGenieAllFirewallRules (Function)