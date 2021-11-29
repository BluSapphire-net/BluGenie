#region Remove-BluGenieFirewallRule (Function)
Function Remove-BluGenieFirewallRule
{
<#
    .SYNOPSIS
        Remove Windows Firewall Rule(s)

    .DESCRIPTION
        Remove Windows Firewall Rule(s)

    .PARAMETER RuleName
        Description: The name(s) of the firewall rule you would like to remove 
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
        Description: Removed UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias: 
        ValidateSet: 

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP'
        Description: Remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list.
        Notes: 

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP,BGAgent_445_Inbound_UDP'
        Description: Remove the BGAgent_445_Inbound_TCP and BGAgent_445_Inbound_UDP rules from the Windows Firewall Rule list.
        Notes: 

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -RuleName '^BGAgent.*'
        Description: Remove the BGAgent_445_Inbound_TCP and BGAgent_445_Inbound_UDP rules from the Windows Firewall Rule list.
        Notes: 

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -Help
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -WalkThrough
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP' -OutUnEscapedJSON
        Description: Remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list and return an UnEsacped JSON formated report.
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters

    .EXAMPLE
	    Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP' -ReturnObject
        Description: This will remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list and return an Object with the returning results
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
                                        ~ 1807.2801: * [Michael Arroyo] Posted
                                        ~ 1902.0701: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                        ~ 1910.2401: * [Michael Arroyo] Added support for Rule names formated in Array
                                                     * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                     * [Michael Arroyo] Added support for ReturnObject
                                        ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
#>
    [Alias('Remove-FirewallRule')]
    Param
    (
        [Parameter(Position=0)]
        [String[]]$RuleName,

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

    #region Check Parameter RuleName ( if nothing than exit )
        If
        (
            -Not $RuleName
        )
        {
            Return
        }
    #endregion Check Parameter RuleName ( if nothing than exit )

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['RemoveFirewallRule'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['RemoveFirewallRule'].StartTime = $($StartTime).DateTime
        $HashReturn['RemoveFirewallRule']['Rulenames'] = @()
        $HashReturn['RemoveFirewallRule']['Status'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['RemoveFirewallRule'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $objFirewall = New-Object -ComObject HNetCfg.FwPolicy2

        #region Define rule names
            If
            (
                $RuleName -match '\,'
            )
            {
                $Rules = $RuleName -split (',')
            }
            Else
            {
                $Rules = $RuleName
            }
        #endregion Define rule names

        #region Manage Rules
            $ArrRuleList = @()

            $Rules | ForEach-Object `
            -Process `
            {
                $CurRule = $_
                $RuleList = $objFirewall.Rules | Where-Object -FilterScript { $_.Name -match $CurRule }
                If
                (
                    $RuleList
                )
                {
                    $HashReturn['RemoveFirewallRule']['Rulenames'] += $RuleList.Name
                    
                    $RuleList.Name | ForEach-Object `
                    -Process `
                    {
                        $CurRuleName = $_
                        Try
                        {
                            $objFirewall.Rules.Remove("$CurRuleName")
                        }
                        Catch
                        {
                        }
                    }

                    $RuleList.Name | ForEach-Object `
                    -Process `
                    {
                        $CheckCurRule = $_

                        If
                        (
                            $($objFirewall.Rules | Where-Object -FilterScript { $_.Name -eq $CheckCurRule })
                        )
                        {
                            $ArrRuleList += New-Object -TypeName PSObject -Property @{
                                RuleName = $CheckCurRule
                                Removed = $false
                            }
                        }
                        Else
                        {
                            $ArrRuleList += New-Object -TypeName PSObject -Property @{
                                RuleName = $CheckCurRule
                                Removed = $true
                            }
                        }
                    }
                }
            }

            $HashReturn['RemoveFirewallRule']['Status'] += $ArrRuleList
        #endregion Manage Rules


    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['RemoveFirewallRule'].EndTime = $($EndTime).DateTime
        $HashReturn['RemoveFirewallRule'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $ArrRuleList
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
#endregion Remove-BluGenieFirewallRule (Function)