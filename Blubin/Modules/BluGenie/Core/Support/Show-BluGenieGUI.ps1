#region Show-BluGenieGUI (Function)
Function Show-BluGenieGUI
{
<#
    .SYNOPSIS
        Show the advanced Graphical API Toolkit for BluGenie

    .DESCRIPTION
        Show the advanced Graphical API Toolkit for BluGenie

    .PARAMETER Detach
        Description:  Start the Graphical interface in a new process so BluGenie is free to use at the same time.
        Notes:  
        Alias: Help
        ValidateSet: 

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: Show-BluGenieGUI
        Description: Show the advanced Graphical API Toolkit for BluGenie
        Notes: 

    .EXAMPLE
	    Command: Show-GUI
        Description: Alias 1 - Show the advanced Graphical API Toolkit for BluGenie
        Notes: 

    .EXAMPLE
	    Command: GUI
        Description: Alias 2 - Show the advanced Graphical API Toolkit for BluGenie
        Notes: 

    .EXAMPLE
	    Command: Show-BluGenieGUI -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Show-BluGenieGUI -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: None

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.11.1301 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • Latest Author             : 
            o    Michael Arroyo
        • Latest Build Version      : 
            o    20.11.1801
        • Comments                  :
            o    
        • PowerShell Compatibility  : 
            o    2,3,4,5.x
        • Forked Project            : 
            o    
        • Links                     :
            o    
        • Dependencies              :
            o    $ScriptDirectory\Tools\Blubin\GUI\BgGui.ps1 - The Core GUI Script
        • Build Version Details     :
            o 20.11.1301: * [Michael Arroyo] Posted
			o 20.11.1801: * [Michael Arroyo] Added the Detach parameter.  This param will run the GUI as a separate process allowing to still interacte with the BluGenie Console.
                                                    
#>
    [cmdletbinding()]
    [Alias('Show-GUI','GUI')]
    #region Parameters
        Param
        (
            [Switch]$Detach,

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
            $Detach
        )
        {
            $env:BgGUIDetach = $true
            Start-Process -FilePath $('{0}\windows\system32\WindowsPowerShell\v1.0\powershell.exe' -f $env:SystemDrive) -ArgumentList $('-ExecutionPolicy ByPass -File "{0}\Tools\Blubin\GUI\BgGui.ps1"' -f $ScriptDirectory) -WindowStyle Hidden
        }
        Else
        {
            $env:BgGUIDetach = $false
            &$ScriptDirectory\Tools\Blubin\GUI\BgGui.ps1
        }
    #endregion Main
}
#endregion Show-BluGenieGUI (Function)