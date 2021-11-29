#region Enable-BluGenieFirewallRule (Function)
Function Enable-BluGenieFirewallRule
{
<#
    .SYNOPSIS
        Enable Firewall Rule(s)

    .DESCRIPTION
        Enable Firewall Rule(s)

    .PARAMETER Rulename
        Description: The name of the Firewall Rule(s) to be enable
        Notes: Can be a sinlge rule, multiple rules broken up by a comma, or an array of rule names
        Alias: Name
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
	    Command: Enable-BluGenieFirewallRule -Name Agent_445_Inbound_TCP
        Description: This will enable the firewall rule Agent_445_Inbound_TCP
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP,Agent_445_Inbound_UDP'
        Description: This will enable the firewall rule Agent_445_Inbound_TCP
        Notes: The rules are in a String format using a comma delimiter.  You can also use an array.

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP','Agent_445_Inbound_UDP'
        Description: This will enable the firewall rule Agent_445_Inbound_TCP
        Notes: The rules are in an Array format.  You can also use a String format using a comma delimiter

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -Help
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -WalkThrough
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: 

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -Name Agent_445_Inbound_TCP -OutUnEscapedJSON
        Description: This will enable the firewall rule Agent_445_Inbound_TCP
        Notes: The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters

    .EXAMPLE
	    Command: Enable-BluGenieFirewallRule -Name Agent_445_Inbound_TCP -ReturnObject
        Description: This will enable the firewall rule Agent_445_Inbound_TCP
        Notes: The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES
        * Original Author           : Michael Arroyo
        * Original Build Version    : 1809.1501
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1910.1501
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough
        * Build Version Details     :
                                        ~ 1809.1501: * [Michael Arroyo] Posted
                                        ~ 1902.0501: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                        ~ 1910.1501: * [Michael Arroyo] Added support for Rule names formated in Array
                                                     * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                     * [Michael Arroyo] Added support for ReturnObject
                                                     * [Michael Arroyo] Updated the -Help | -WalkThrough parameter.  If Invoke-WalkThrough is an active function it will be called.  If not the default help will be called.
                                                    
#>
    [Alias('Enable-FirewallRule')]
    Param
    (
        [Parameter(Position = 0)]
        [Alias("Name")]
        [string[]]$RuleName,

        [Parameter(Position=1)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=2)]
        [Switch]$ReturnObject,

        [Parameter(Position=3)]
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

    #region Main
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
            $HashReturn.EnableFirewallRule = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.EnableFirewallRule.StartTime = $($StartTime).DateTime
            $HashReturn.EnableFirewallRule.Rulenames = @()
            $HashReturn.EnableFirewallRule.Processed = @()
        #endregion

        #region Parameter Set Results
            $HashReturn.EnableFirewallRule.ParameterSetResults = $PSBoundParameters
        #endregion Parameter Set Results

        #region Main routine for Disable-FirewallRule
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

            #region Enable Found Rules

                $ArrReturnObjectStatus = @()

                $Rules | ForEach-Object `
                -Process `
                {
                    $CurRule = $_
                    $CurRuleList = $objFirewall.Rules | Where-Object -FilterScript { $_.Name -match [System.Text.RegularExpressions.Regex]::Escape($CurRule) }

                    If
                    (
                        $CurRuleList
                    )
                    {
                        $HashReturn.EnableFirewallRule.Rulenames += $CurRuleList | Select-Object -ExpandProperty Name
                        $CurRuleList | ForEach-Object `
                        -Process `
                        {
                            $CurPropList = $_
                            $CurPropList.Enabled = $true
                        }
                    }
                    
                    $ArrReturnObjectStatus += $CurRuleList | Select-Object -Property Name,Enabled
                }
            #endregion Enable Found Rules

            #region Rules Check
                If
                (
                    $ArrReturnObjectStatus
                )
                {
                    If
                    (
                        $ArrReturnObjectStatus | Where-Object -FilterScript { $_.Enabled -eq $false }
                    )
                    {
                        $HashReturn.EnableFirewallRule['Status'] = $false
                    }
                    Else
                    {
                        $HashReturn.EnableFirewallRule['Status'] = $true
                    }
                }
                Else
                {
                    $HashReturn.EnableFirewallRule['Comment'] = 'No Rules found with the current search value'
                }

                $HashReturn.EnableFirewallRule.Processed = $ArrReturnObjectStatus
            #endregion Rules Check
        #endregion Main routine for Disable-FirewallRule
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['EnableFirewallRule'].EndTime = $($EndTime).DateTime
        $HashReturn['EnableFirewallRule'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $ArrReturnObjectStatus
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
#endregion Enable-BluGenieFirewallRule (Function)