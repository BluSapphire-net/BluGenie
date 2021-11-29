#region Set-BluGenieFirewallStatus (Function)
Function Set-BluGenieFirewallStatus
{
<#
    .SYNOPSIS
        Update the Firewall Oubound or Inbound status

    .DESCRIPTION
        Update the Firewall Oubound or Inbound status

    .PARAMETER ProfileType
        Description:  Select which profile you would like to update
        Notes:  
                - DOMAIN
                - PRIVATE
                - PUBLIC
                - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
        Alias:
        ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'

    .PARAMETER OutBound
        Description: Select the Firewall Management State per profile 
        Notes:  
                - Block
                - Allow
                - Default - (Default Selection)
        Alias:
        ValidateSet: 'Block','Allow','Default'

    .PARAMETER InBound
        Description: Select the Firewall Management State per profile 
        Notes: 
                - Block
                - Allow
                - Default - (Default Selection) 
        Alias:
        ValidateSet: 'Block','Allow','Default'

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
	    Command: Set-BluGenieFirewallStatus
        Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -ProfileType DOMAIN -Outbound Block -Inbound Block
        Description: Set Inbound and Outbound for the DOMAIN profile to Block
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -ProfileType PRIVATE -Outbound Block -Inbound Allow
        Description: Set Inbound to Allow and Outbound to Block for the PRIVATE Windows Firewall Profile
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -OutUnEscapedJSON
        Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Set-BluGenieFirewallStatus -ReturnObject
        Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting and Return Output an Object
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
                                        ~ 1910.2201: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Updated the Return data.  It was coming back as Blocked for both Inbound and Outbound no matter what the parameter value was.
                                        ~ 1911.1201: * [Michael Arroyo] Bug fix to manage the Firewall Service.  When trying to enable the service the Display Name was being modified.
                                                     * [Michael Arroyo] Added more error control around the Firewall Service
                                        ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
#>
    [Alias('Set-FirewallStatus')]
    Param
    (
        [Parameter(Position=0)]
        [ValidateSet('DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC')]
        [String]$ProfileType = 'DOMAIN+PRIVATE+PUBLIC',

        [Parameter(Position = 1)]
        [ValidateSet('Block','Allow','Default')]
        [string]$OutBound = 'Default',

        [Parameter(Position = 2)]
        [ValidateSet('Block','Allow','Default')]
        [string]$InBound = 'Default',

        [Parameter(Position=3)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=4)]
        [Switch]$ReturnObject,

        [Parameter(Position=5)]
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
        $HashReturn['SetFirewallStatus'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetFirewallStatus'].StartTime = $($StartTime).DateTime
        $HashReturn['SetFirewallStatus']['Profiles'] = @()
    #endregion

    #region Parameter Set Results
        $HashReturn['SetFirewallStatus'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region OutBound Profile Settings
            switch
            (
                $OutBound
            )
            {
                'Allow'
                {
                    [int]$OutBoundFlag = '1'
                }
                'Block'
                {
                    [int]$OutBoundFlag = '0'
                }
                'Default'
                {
                    [int]$OutBoundFlag = '1'
                }
            }
        #endregion OutBound Profile Settings

        #region InBound Profile Settings
            switch
            (
                $InBound
            )
            {
                'Allow'
                {
                    [int]$InBoundFlag = '1'
                }
                'Block'
                {
                    [int]$InBoundFlag = '0'
                }
                'Default'
                {
                    [int]$InBoundFlag = '0'
                }
            }
        #endregion InBound Profile Settings

        #region Profiles
            [int]$FWDOMAIN = 1
            [int]$FWPRIVATE = 2
            [int]$FWPUBLIC = 4

            $ProfileList = @()
        #endregion Profiles

        #region ProfileTypes
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
        #endregion ProfileTypes

        #region Manage Firewall Service
            $FWServiceInfo = Get-Service -Name 'MpsSvc' | Select-Object -ExpandProperty Status

            if
            (
                $FWServiceInfo -ne 'Running'
            )
            {
                Get-Service -Name 'MpsSvc' | Set-Service -StartupType Automatic -Confirm:$false -ErrorAction SilentlyContinue
                Start-Service -DisplayName 'Windows*Firewall' -ErrorAction SilentlyContinue
                $FWServiceInfo = Get-Service -Name 'MpsSvc' | Select-Object -ExpandProperty Status
            }
            
            $HashReturn['SetFirewallStatus']['ServiceStatus'] = $($FWServiceInfo | Out-String).Trim()
        #endregion Manage Firewall Service

        #region Manage Firewall Profiles
            If
            (
                $FWServiceInfo -eq 'Running'
            )
            {
                $objFirewall = New-object -comObject HNetCfg.FwPolicy2

                $ProfileList | ForEach-Object `
                -Process `
                {
                    $CurProfile = $_

                    switch
                    (
                        $CurProfile
                    )
                    {
                        '1'
                        {
                            $RealProfileName = 'DOMAIN PROFILE'
                            break
                        }
                        '2'
                        {
                            $RealProfileName = 'PRIVATE PROFILE'
                            break
                        }
                        '4'
                        {
                            $RealProfileName = 'PUBLIC PROFILE'
                            break
                        }
                    }

                    $objFirewallCheck = New-object -comObject HNetCfg.FwPolicy2

                    If
                    (
                        $OutBound
                    )
                    {
                        $objFirewallCheck.DefaultOutboundAction($CurProfile) = $OutBoundFlag
                        $OutBoundReturn = $objFirewallCheck.DefaultOutboundAction($CurProfile)

                        switch
                        (
                            $OutBoundReturn
                        )
                        {
                            '1'
                            {
                                [string]$OutBoundReturn = 'Allow'
                            }
                            '0'
                            {
                                [string]$OutBoundReturn = 'Block'
                            }
                        }
                    }

                    If
                    (
                        $InBound
                    )
                    {
                        $objFirewallCheck.DefaultInboundAction($CurProfile) = $InBoundFlag
                        $InBoundReturn = $objFirewallCheck.DefaultInboundAction($CurProfile)

                        switch
                        (
                            $InBoundReturn
                        )
                        {
                            '1'
                            {
                                [string]$InBoundReturn = 'Allow'
                            }
                            '0'
                            {
                                [string]$InBoundReturn = 'Block'
                            }
                        }
                    }

                    $HashReturn['SetFirewallStatus']['Profiles'] += New-Object -TypeName PSObject -Property @{
                        Profile = $RealProfileName
                        Request_OutBound = $OutBound
                        Set_OutBound = $OutBoundReturn
                        Request_InBound = $InBound
                        Set_InBound =  $InBoundReturn
                    }
                }
            }
        #endregion Manage Firewall Profiles
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetFirewallStatus'].EndTime = $($EndTime).DateTime
        $HashReturn['SetFirewallStatus'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return $($HashReturn['SetFirewallStatus']['Profiles'])
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
#endregion Set-BluGenieFirewallStatus (Function)