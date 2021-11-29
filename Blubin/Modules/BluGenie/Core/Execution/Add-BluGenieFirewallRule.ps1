#region Add-BluGenieFirewallRule (Function)
Function Add-BluGenieFirewallRule
{
<#
    .SYNOPSIS
        Add Windows Firewall Rule(s) from a Rule configuration file

    .DESCRIPTION
        Add Windows Firewall Rule(s) from a Rule configuration file

    .PARAMETER RuleName
        Description: Full Path to a New Firewall Rule (.Rule) file.
        Notes: This can be more than one file, seperated with a comma (,) or an array of strings
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
	    Command: Add-BluGenieFirewallRule -RulePath 'Agent_445_Inbound_TCP'
        Description: This will add the Agent_445_Inbound_TCP rules from the Script Directory to the Windows Firewall Rule list.
        Notes: 

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RulePath 'Agent_445_Inbound_TCP,Agent_445_Inbound_UDP'
        Description: This will add the Agent_445_Inbound_TCP and Agent_445_Inbound_UDP rules from the Script Directory to the Windows Firewall Rule list.
        Notes: 

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RulePath 'Agent_445_Inbound_TCP','Agent_445_Inbound_UDP'
        Description: This will add the Agent_445_Inbound_TCP and Agent_445_Inbound_UDP rules from the Script Directory to the Windows Firewall Rule list.
        Notes:

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RuleName 'C:\Windows\Temp\BGAgent_445_Inbound_TCP.RULE'
        Description: This will add the Agent_445_Inbound_TCP rules from the C:\Windows\Temp\<Rule_Config> to the Windows Firewall Rule list.
        Notes:  The rules are in JSON format

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RuleName 'C:\Windows\Temp\BGAgent_445_Inbound_TCP.RULE,C:\Windows\Temp\BGAgent_445_Inbound_UDP.RULE'
        Description: This will add the Agent_445_Inbound_TCP and Agent_445_Inbound_UDP rules from the C:\Windows\Temp\<Rule_Config> to the Windows Firewall Rule list.
        Notes:  These rules are in JSON format and also note the the rule names are in a sinlge string seperated by a comma.  The parameter can also use an array "<rule1>","<rule2>"

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RuleName 'C:\Windows\Temp\BGAgent_445_Inbound_TCP.RULE','C:\Windows\Temp\BGAgent_445_Inbound_UDP.RULE'
        Description: This will add the Agent_445_Inbound_TCP and Agent_445_Inbound_UDP rules from the C:\Windows\Temp\<Rule_Config> to the Windows Firewall Rule list.
        Notes:  These rules are in JSON format and also note the the rule names are in an array "<rule1>","<rule2>".  The parameter can also use a single string with a comma delimiter.

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -Help
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -WalkThrough
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RuleName 'C:\Windows\Temp\BGAgent_445_Inbound_TCP.RULE' -OutUnEscapedJSON
        Description: This will add the Agent_445_Inbound_TCP rules from the C:\Windows\Temp\<Rule_Config> to the Windows Firewall Rule list.
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters

    .EXAMPLE
	    Command: Add-BluGenieFirewallRule -RuleName 'C:\Windows\Temp\BGAgent_445_Inbound_TCP.RULE' -ReturnObject
        Description: This will add the Agent_445_Inbound_TCP rules from the C:\Windows\Temp\<Rule_Config> to the Windows Firewall Rule list.
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
                       

    .NOTES

                    * Original Author           : Michael Arroyo
                    * Original Build Version    : 1809.1501
                    * Latest Author             : Michael Arroyo
                    * Latest Build Version      : 20.05.2101
                    * Comments                  :
                    * Dependencies              :
                                                    ~ Pull-FirewallRules (Defined to $FireWallRuleEnum) Syntax: $FireWallRuleEnum = Pull-FirewallRules
                                                    ~ Invoke-WalkThrough
                    * Build Version Details     :
                                                    ~ 1809.1501: * [Michael Arroyo] Posted
                                                    ~ 1902.0401: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                                                 * [Michael Arroyo] Removed the Mandatory flag on the $RuleName variable and added an If statement check instead.  This allows for WalkThrough to work without any options.
                                                    ~ 1910.1001: * [Michael Arroyo] Added support for External Firewall Rules
                                                                 * [Michael Arroyo] Added support for Rule names formated in Array
                                                                 * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                                 * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                                 * [Michael Arroyo] Added more detailed information to the Return data
                                                                 * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                                 * [Michael Arroyo] Added support for ReturnObject
                                                                 * [Michael Arroyo] Updated the -Help | -WalkThrough parameter.  If Invoke-WalkThrough is an active function it will be called.  If not the default help will be called.
                                                    ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
                                                    
#>
    [Alias('Add-FirewallRule')]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]$RuleName,

        [Parameter(Position=1)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=1)]
        [Switch]$ReturnObject,

        [Parameter(Position=1)]
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
            $HashReturn.AddFireWallRule = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.AddFireWallRule.StartTime = $($StartTime).DateTime
            $HashReturn.AddFireWallRule['Rulenames'] = @()
            $HashReturn.AddFireWallRule['Import'] = @()
        #endregion

        #region Parameter Set Results
            $HashReturn.AddFireWallRule.ParameterSetResults = $PSBoundParameters
        #endregion Parameter Set Results

        #region Add Firewall Rules
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

            $ArrReturnObjectStatus = @()

            $Rules | ForEach-Object `
            -Process `
            {
                $CurRuleName = $_
                $Curstatus = $false
                $CurComments = $null

                If
                (
                    $FireWallRuleEnum.$CurRuleName
                )
                {
                    $objImport = $FireWallRuleEnum.$CurRuleName
                }
                Else
                {
                    $objImport = Get-Content -Path $CurRuleName -ErrorAction SilentlyContinue | Out-String | ConvertFrom-Json
                }

                $objNewRule = New-Object -ComObject HNetCfg.FWRule

                If($objImport.Name){$objNewRule.Name = [string]$objImport.Name}
                If($objImport.Description){$objNewRule.Description = [string]$objImport.Description}
                If($objImport.ApplicationName){$objNewRule.ApplicationName = [string]$objImport.ApplicationName}
                If($objImport.serviceName){$objNewRule.serviceName = [string]$objImport.serviceName}
                If($objImport.Protocol){$objNewRule.Protocol = [int]$objImport.Protocol}
                If($objImport.LocalPorts){$objNewRule.LocalPorts = [string]$objImport.LocalPorts}
                If($objImport.RemotePorts){$objNewRule.RemotePorts = [string]$objImport.RemotePorts}
                If($objImport.LocalAddresses){$objNewRule.LocalAddresses = [string]$objImport.LocalAddresses}
                If($objImport.RemoteAddresses){$objNewRule.RemoteAddresses = [string]$objImport.NRemoteAddressesame}
                If($objImport.IcmpTypesAndCodes){$objNewRule.IcmpTypesAndCodes = [string]$objImport.IcmpTypesAndCodes}
                If($objImport.Direction){$objNewRule.Direction = [int]$objImport.Direction}
                If($objImport.Interfaces){$objNewRule.Interfaces = [int]$objImport.Interfaces}
                If($objImport.InterfaceTypes){$objNewRule.InterfaceTypes = [string]$objImport.InterfaceTypes}
                If($objImport.Enabled){$objNewRule.Enabled = [bool]$objImport.Enabled}
                If($objImport.Grouping){$objNewRule.Grouping = [string]$objImport.Grouping}
                If($objImport.Profiles){$objNewRule.Profiles = [int]$objImport.Profiles}
                If($objImport.EdgeTraversal){$objNewRule.EdgeTraversal = [bool]$objImport.EdgeTraversal}
                If($objImport.Action){$objNewRule.Action = [int]$objImport.Action}
                If($objImport.EdgeTraversalOptions){$objNewRule.EdgeTraversalOptions = [int]$objImport.EdgeTraversalOptions}
                If($objImport.LocalAppPackageId){$objNewRule.LocalAppPackageId = [string]$objImport.LocalAppPackageId}
                If($objImport.LocalUserOwner){ $objNewRule.LocalUserOwner = [string]$objImport.LocalUserOwner}
                If($objImport.LocalUserAuthorizedList){$objNewRule.LocalUserAuthorizedList = [string]$objImport.LocalUserAuthorizedList}
                If($objImport.RemoteUserAuthorizedList){$objNewRule.RemoteUserAuthorizedList = [string]$objImport.RemoteUserAuthorizedList}
                If($objImport.RemoteMachineAuthorizedList){$objNewRule.RemoteMachineAuthorizedList = [string]$objImport.RemoteMachineAuthorizedList}
                If($objImport.SecureFlags){$objNewRule.SecureFlags = [int]$objImport.SecureFlags}

                Try
                {
                    $objFirewall.Rules.Add($objNewRule)
                }
                Catch
                {
                }

                If
                (
                    $objFirewall.Rules | Where-Object -Property Name -eq $objImport.Name
                )
                {
                    $CurStatus = $true
                }
                Else
                {
                    $curComments = $Error[0].Exception.Message
                }

                $HashReturn.AddFireWallRule.Import += @{
                    $($objImport.Name) = @{
                        status = $CurStatus
                        comment = $CurComments
                        timestamp =  $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
                        ruleinfo = $objImport
                    }
                }

                $HashReturn.AddFireWallRule.Rulenames += $($objImport.Name)
                $ArrReturnObjectStatus += New-Object -TypeName PSObject -Property @{
                    RuleName = $objImport.Name
                    Status = $CurStatus
                }
            }
        #endregion Add Firewall Rules
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn.AddFireWallRule.EndTime = $($EndTime).DateTime
        $HashReturn.AddFireWallRule.ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
#endregion Add-BluGenieFirewallRule (Function)