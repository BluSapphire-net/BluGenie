#region Set-BluGenieRemoteDesktopProcess (Function)
Function Set-BluGenieRemoteDesktopProcess
{
<#
    .SYNOPSIS
        Enable or Disable Remote Desktop functionality

    .DESCRIPTION
        Enable or Disable Remote Desktop functionality
        Managed Setting - HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server[fDenyTSConnections]

    .PARAMETER Value
        Description: Option to enable or disable Terminal Services (RDP) 
        Notes:  
        Alias:
        ValidateSet: 'Enable','Disable'

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
	    Command: Set-BluGenieRemoteDesktopProcess
        Description: Enable Remote Desktop
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -Value Enable
        Description: Enable Remote Desktop [2]
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -Value Disable
        Description: Disable Remote Desktop
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -Value Enable -OutUnEscapedJSON
        Description: Enable Remote Desktop and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Set-BluGenieRemoteDesktopProcess -Value Enable -ReturnObject
        Description: Enable Remote Desktop and Return Output an Object
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
                                        ~ 1910.1901: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
                                                     * [Michael Arroyo] Added support for OutUnEscapedJSON
                                                     * [Michael Arroyo] Added support for ReturnObject
                                                     * [Michael Arroyo] Updated the -Help | -WalkThrough parameter.  If Invoke-WalkThrough is an active function it will be called.  If not the default help will be called.
                                        ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
#>
    [Alias('Set-RemoteDesktopProcess')]
    Param
    (
        [Parameter(Position = 0)]
        [ValidateSet('Enable','Disable')]
        [String]$Value = 'Enable',

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

     #region Create Return hash
        $HashReturn = @{}
        $HashReturn['SetRemoteDesktopProcess'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetRemoteDesktopProcess'].StartTime = $($StartTime).DateTime
    #endregion

    #region Parameter Set Results
        $HashReturn['SetRemoteDesktopProcess'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Set Flag
            if
            (
                $Value -eq 'Enable'
            )
            {
                $Setflag = 0
            }
            else
            {
                $Setflag = 1
            }
        #endregion Set Flag

        #region Set RDP Registry Property
            try
            {
                $Error.Clear()
                $null = Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value $SetFlag -ErrorAction Stop

                $HashReturn['SetRemoteDesktopProcess']['Updated'] += @{
                    Value = $Value
                    SetValue = $true
                    comment = 'RDP Setting has been updated'
                    timestamp =  $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
                }
            }
            catch
            {
                $HashReturn['SetRemoteDesktopProcess']['Updated'] += @{
                    Value = $Value
                    SetValue = $false
                    comment = $($Error.Exception.Message | Out-String)
                    timestamp =  $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
                }
            }
        #endregion Set RDP Registry Property
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SetRemoteDesktopProcess'].EndTime = $($EndTime).DateTime
        $HashReturn['SetRemoteDesktopProcess'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            $ReturnObject
        )
        {
            Return New-Object -TypeName PSObject -Property @{
                System = $env:COMPUTERNAME
                Value = $HashReturn['SetRemoteDesktopProcess']['Updated'].Value
                SetValue = $HashReturn['SetRemoteDesktopProcess']['Updated'].SetValue
                Comment = $HashReturn['SetRemoteDesktopProcess']['Updated'].Comment
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
#endregion Set-BluGenieRemoteDesktopProcess (Function)