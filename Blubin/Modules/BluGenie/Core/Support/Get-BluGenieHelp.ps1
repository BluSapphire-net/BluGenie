#region Get-BluGenieHelp (Function)
Function Get-BluGenieHelp
{
<#
    .SYNOPSIS
        Get-BluGenieHelp is a Blugenie Internal Function to Dynamically Pull and Display Synopsis Information for all of BluGenies Functions

    .DESCRIPTION
        Get-BluGenieHelp is a Blugenie Internal Function to Dynamically Pull and Display Synopsis Information for all of BluGenies Functions

		To speed up this informational query a Help Index file is created --> $ScriptDirectory\Tools\Blubin\HelpMnu.dat
		If this file doesn't exist, Once help is called it will be created before displaying the information.

		You can also do quick searches on the Commands and Discriptions using RegEx.  Check the Examples for more information.

		In BluGenie all references will be made using the follow command --> /Help
		In BluGenie all references will be made using the follow command --> /Help:<Search String>
		In BluGenie all references will be made using the follow command --> BluGenie.exe /Help
		In BluGenie all references will be made using the follow command --> BluGenie.exe /Help:<Search String>
		In BluGenie all references will be made using the follow command --> BluGenie.exe "/Help:<Search String>"

    .PARAMETER $Search
        Description: Search the Commands and Discriptions using RegEx.
        Notes: Syntax is
                </Help><:><Search String> --> /Help:Firewall
                -or
                <Get-BluGenieHelp> <-Search> <Search String> --> Get-BluGenieHelp -Search "Firewall"
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: /Help
        Description: Display general help while in the BluGenie Console
        Notes:

    .EXAMPLE
        Command: /help:enable
        Description: Display help with (enable) in either the command or the synopsis
        Notes:

	.EXAMPLE
        Command: "/help:enable firewall"
        Description: Display help with (enable firewall) in the synopsis field
        Notes:

	.EXAMPLE
        Command: BluGenie.exe /help
        Description: Display general help and exit the program
        Notes:

	.EXAMPLE
        Command: BluGenie.exe /help:enable
        Description: Display help with (enable) in either the command or the synopsis
        Notes:

	.EXAMPLE
        Command: BluGenie.exe "/help:enable firewall"
        Description: Display help with (enable firewall) in the synopsis field
        Notes:

    .EXAMPLE
        Command: Get-BluGenieHelp -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieHelp -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1911.1401
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1911.2001

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  19.11.1401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o  Michael Arroyo
        • [Latest Build Version]
            o  21.04.0701
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
            o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 1911.1401:• [Michael Arroyo] Posted
    o 1911.1901:• [Michael Arroyo] Changed filter for $AllowedCommands.  Commands are now setup with (" -Help")
    o 1911.2001:• [Michael Arroyo] Changed filter for $AllowedCommands.  Help will be pulled for every Allowed Command now.
    o 21.04.0701• [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				• [Michael Arroyo] Moved Build Notes out of General Posh Help section
                • [Michael Arroyo] Added a new parameter called ( Force ) to forcefully create a new help cache file if one already exists.
                • [Michael Arroyo] Removed the poistion property from the ( Search ) parameter.  This forces the use of the parameter name.
                • [Michael Arroyo] Removed the poistion property from the ( Help ) parameter.  This foreces the use of the parameter name.
                • [Michael Arroyo] Added a new Alias called ( BGHelp )
                • [Michael Arroyo] Added a process to disable the Posh Progress bar while parsing Help information headers.
#>
#endregion Build Notes
[cmdletbinding()]
    [Alias('Get-BGHelp','BGHelp')]
    #region Parameters
        Param
        (
            [string]$Search,

            [switch]$Force,

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
        $HelpmnuExists = $false

        #region Show Progress Check
            $ProgressPreferenceOld = $ProgressPreference

            $ProgressPreference = 'SilentlyContinue' # hide the progress bar
        #endregion Show Progress Check

        if
        (
            Test-Path -Path $('{0}\HelpMnu.dat' -f $ToolsDirectory) -ErrorAction SilentlyContinue
        )
        {
            $BGHelpMenu = Get-Content -Path $('{0}\HelpMnu.dat' -f $ToolsDirectory) -ErrorAction SilentlyContinue
            $HelpmnuExists = $true
        }


        If
        (
            -Not $HelpmnuExists -or $Force
        )
        {
            Write-VerboseMsg -Message 'Rebuilding Help Index' -Status StartTask
            [System.Collections.ArrayList]$BGHelpMenu = @()

            $(Get-Command -Module 'BluGenie' -CommandType Alias) | Select-Object -ExpandProperty Name | ForEach-Object `
            -Process `
            {
                $CurHelpItem = $_
                $CurHelpInfo = $('* {0}{1}' -f $($CurHelpItem.PadRight(35, ' ')),$($(Get-Help -Name $CurHelpItem -ErrorAction SilentlyContinue) | `
                    Select-Object -ExpandProperty Synopsis))

                Try
                {
                    $null = $BGHelpMenu.add("$CurHelpInfo")
                }
                Catch
                {
                    #Nothing
                }
            }

            If
            (
                $BGHelpMenu
            )
            {
                $BGHelpMenu | Out-File -FilePath $('{0}\HelpMnu.dat' -f $ToolsDirectory) -Force -ErrorAction SilentlyContinue
            }

            Write-VerboseMsg -Message 'Rebuilding Help Index' -Status StopTask
        }
    #endregion Main

    #region Output
        $ProgressPreference = $ProgressPreferenceOld

        If
		(
			$Search
		)
		{
			Write-Host "`nBluGenie Help" -ForegroundColor Cyan
			Write-Host "To run help on a command type the <Command> -Help`n" -ForegroundColor Yellow
			Show-More -Source $($BGHelpMenu | Select-String -Pattern "$Search") -LineCount 20
			Write-Host "`n"
		}
		Else
		{
			Write-Host "`nBluGenie Help" -ForegroundColor Cyan
			Write-Host "To run help on a command type the <Command> -Help`n" -ForegroundColor Yellow
			Show-More -Source $BGHelpMenu -LineCount 20
			Write-Host "`n"
		}
    #endregion Output
}
#endregion Get-BluGenieHelp (Function)