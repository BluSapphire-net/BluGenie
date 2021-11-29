#region New-BluGenieSessionInfo (Function)
Function New-BluGenieSessionInfo
{
<#
    .SYNOPSIS
        New-BluGenieSessionInfo will query a Current Session Environment varialbe and build Posh variables back into new PSSession Runspaces

    .DESCRIPTION
        New-BluGenieSessionInfo will query a Current Session Environment varialbe and build Posh variables back into new PSSession Runspaces

    .PARAMETER EnvVarName
        Description: Name of the Current Systems Envinroment Variable
        Notes: The default is 'BGSessionInfo'
        Alias:
        ValidateSet: 

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: New-BluGenieSessionInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: New-BluGenieSessionInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    OTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.11.1701 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • Latest Author             : 
            o        
        • Latest Build Version      : 
            o    
        • Comments                  :
            o    
        • PowerShell Compatibility  : 
            o    3,4,5.x
        • Forked Project            : 
            o    
        • Links                     :
            o    
        • Dependencies              :
            o    Invoke-WalkThrough - will convert the static PowerShell help into an interactive menu system
        • Build Version Details     :
            o 20.11.1701: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-SessionInfo')]
    #region Parameters
        Param
        (
            [string]$EnvVarName = 'BGSessionInfo',

            [Alias('Help')]
            [Switch]$Walkthrough
        )
    #endregion Parameters

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
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough
            )
            {
                If
                (
                    $Function -eq 'Invoke-BluGenieWalkThrough'
                )
                {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
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
        If
        (
            Test-Path -path $('Env:\{0}' -f $EnvVarName)
        )
        {
            $CurSessionUpdate = Get-Item -path $('Env:\{0}' -f $EnvVarName) | Select-Object -ExpandProperty Value | ConvertFrom-Json -ErrorAction Stop

            If
            (
                $CurSessionUpdate.GetType().Name -match 'Object'
            )
            {
                $CurSessionUpdate | ForEach-Object `
                -Process `
                {
                    Set-Variable -Name $_.Name -Value $_.Value -Scope Global -Force -ErrorAction SilentlyContinue
                }
            }
        }                
    #endregion Main
}
#endregion New-BluGenieSessionInfo (Function)