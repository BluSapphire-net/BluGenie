 #region Set-BluGenieScriptCredentials (Function)
Function Set-BluGenieScriptCredentials
{
<#
    .SYNOPSIS
        Set Credentials at the command line

    .DESCRIPTION
        Set Credentials without using Get-Credentials and being prompted for a password

    .PARAMETER SetUser
        Description: User Name for the Current Credentials
        Notes: You can set a domain by using "Domain_Name\UserName"
        Alias: 'UserName','Usr'
        ValidateSet:

    .PARAMETER SetPass
        Description: Password for the Current Credentials
        Notes:
        Alias: 'Password','Pw'
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: $Creds = Set-BluGenieScriptCredentials -UserName 'Guest' -Password 'Password!'
        Description: Use this command to Set Credentials and save that information to a variable called $Creds
        Notes:

    .EXAMPLE
        Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
        Description: Use this command to Set Domain Credentials and save that information to a variable called $Creds
        Notes: This command uses the Alias command name

    .EXAMPLE
        Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
                    $Creds.ShowPassword()
        Description: Use this command to show an already saved Cred Password
        Notes: This is a known PowerShell method which will expose the current password.  This is not a secure method for managing Passwords.

    .EXAMPLE
        Command: Set-BluGenieScriptCredentials -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Set-BluGenieScriptCredentials -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.06.2101 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [PowerShell Compatibility]
            o  2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 21.02.1201: • [Michael Arroyo] Function Template
    o 21.06.2101: • [Michael Arroyo] Posted
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Set-ScriptCredentials','SetCred')]
    #region Parameters
        Param
        (
            [Parameter(
				Mandatory = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0
            )]
            [ValidateNotNullOrEmpty()]
            [Alias('UserName','Usr')]
            [String]$SetUser,

            [Parameter(
                    Mandatory = $true,
                    ValueFromPipelineByPropertyName = $true,
                    Position = 1
            )]
            [ValidateNotNullOrEmpty()]
            [Alias('Password','Pw')]
            [String]$SetPass,

            [Alias('Help')]
            [Switch]$Walkthrough
        )
    #endregion Parameters

    #region Main
        $Creds = New-Object -TypeName System.Management.Automation.PSCredential `
			-ArgumentList "$SetUser", ("$SetPass" | ConvertTo-SecureString -AsPlainText -Force)

        $Creds | Add-Member -MemberType ScriptMethod -Name "ShowPassword" -Value {$this.GetNetworkCredential().Password} -Force
    #endregion Main

    #region Output
        Return $Creds
    #endregion Output
}
#endregion Set-BluGenieScriptCredentials (Function)