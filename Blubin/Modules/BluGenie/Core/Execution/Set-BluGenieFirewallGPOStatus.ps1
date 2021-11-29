#region Set-BluGenieFirewallGPOStatus (Function)
Function Set-BluGenieFirewallGPOStatus
{
<#
    .SYNOPSIS
        Update the GPO assigned restrictions on the Windows Firewall (enable user updates / disable user updates)

    .DESCRIPTION
        Update the GPO assigned restrictions on the Windows Firewall (enable user updates / disable user updates)

    .PARAMETER ServiceState
        Description: Change the Service State to Enabled / Disabled / or Remove it all together 
        Notes: Managed Setting - HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall 
        Alias:
        ValidateSet: 'Remove','Enable','Disable' 

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
	    Command: Set-BluGenieFirewallGPOStatus
        Description: Remove the GPO assigned restrictions on the Firewall settings
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -ServiceState Remove
        Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Remove
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -ServiceState Enable
        Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Enable
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -ServiceState Disable
        Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Disable
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -OutUnEscapedJSON
        Description: Remove the GPO assigned restrictions on the Firewall settings and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Set-BluGenieFirewallGPOStatus -ReturnObject
        Description: Remove the GPO assigned restrictions on the Firewall settings and Return Output an Object
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
            ~ 1911.0101: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                         * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                         * [Michael Arroyo] Added more detailed information to the Return data
                         * [Michael Arroyo] Rewrote the parent If statement to be a switch statement
                         * [Michael Arroyo] Updated the information in the returning hash table to have more info on the requested actions
            ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
#>
    [Alias('Set-FirewallGPOStatus')]
    Param
    (
        [Parameter(Position = 0)]
        [ValidateSet('Enable','Disable','Remove')]
        [string]$ServiceState ='Remove',

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
        $HashReturn['SetFirewallGPOStatus'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetFirewallGPOStatus'].StartTime = $($StartTime).DateTime
        $HashReturn['SetFirewallGPOStatus'].Status = ''
        $HashReturn['SetFirewallGPOStatus'].Comment = ''
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['SetFirewallGPOStatus'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        Switch
        (
            $ServiceState
        )
        {
            'Enable'
            {
                $ServiceStateFlag = '1'
            }

            'Remove'
            {
                $ServiceStateFlag = '2'
            }

            'Disable'
            {
                $ServiceStateFlag = '0'
            }
        }


        if
        (
            $ServiceState -eq 'Remove'
        )
        {
            try
            {
                $null = Get-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall' -ErrorAction Stop

                try
                {
                    $RemoveReturn = $null = Remove-Item -path HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall -Confirm:$false -Force -Recurse -ErrorAction Stop
                    $HashReturn['SetFirewallGPOStatus'].Status = $true
                    $HashReturn['SetFirewallGPOStatus'].Comment = 'Removed (HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall) Firewall GPO Lock Successfully'
                }
                catch
                {
                    $HashReturn['SetFirewallGPOStatus'].Status = $false
                    $HashReturn['SetFirewallGPOStatus'].Comment = 'Failed to Remove (HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall) Firewall GPO Lock'
                }
            }
            Catch
            {
                 $HashReturn['SetFirewallGPOStatus'].Status = $true
                 $HashReturn['SetFirewallGPOStatus'].Comment = "Firewall GPO Lock (HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall) doesn't exist"
            }
        }
        else
        {
            try
            {
                $null = New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft -Name WindowsFirewall -ErrorAction SilentlyContinue
                $null = New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall -Name DomainProfile -ErrorAction SilentlyContinue
                $null = New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall -Name StandardProfile -ErrorAction SilentlyContinue

                $null = Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile -Name EnableFirewall -Value $ServiceStateFlag -Type DWord -ErrorAction Stop -Force
                $null = Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile -Name EnableFirewall -Value $ServiceStateFlag -Type DWord -ErrorAction Stop -Force

                $HashReturn['SetFirewallGPOStatus'].Status = $ServiceState
                $HashReturn['SetFirewallGPOStatus'].Comment = $('Firewall GPO Lock (HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewallset\*Profile[EnableFirewall] set to {0}' -f $ServiceState)
            }
            catch
            {
                $HashReturn['SetFirewallGPOStatus'].Status = $false
                $HashReturn['SetFirewallGPOStatus'].Comment = 'Failed to update (HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewallset\*Profile[EnableFirewall] Firewall GPO Lock'
            }
        }
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetFirewallGPOStatus'].EndTime = $($EndTime).DateTime
        $HashReturn['SetFirewallGPOStatus'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return New-Object -TypeName PSObject -Property @{
                Status = $HashReturn['SetFirewallGPOStatus'].Status
                Comment = $HashReturn['SetFirewallGPOStatus'].Comment
            }
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
#endregion Set-BluGenieFirewallGPOStatus (Function)