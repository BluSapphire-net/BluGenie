#region Set-BluGenieSessionInfo (Function)
Function Set-BluGenieSessionInfo
{
<#
    .SYNOPSIS
        Set-BluGenieSessionInfo will set a Current Session Environment varialbe to be passed to each new PSSession Runspace automatically

    .DESCRIPTION
        Set-BluGenieSessionInfo will set a Current Session Environment varialbe to be passed to each new PSSession Runspace automatically.

        All System variables will be removed once all Child and Parent sessions are closed.

    .PARAMETER CaptureVarName
        Description: Define which Current Session variables will be captured into a Current System Variable 
        Notes:  This String is parsed as RegEx.
        
                The default values are as follows
                BGMemory
                BGNoBanner
                BGNoExit
                BGNoSetRes
                BGRemoveMods
                BGUpdateMods
                ConsoleDebug
                ConsoleJobTimeout
                ConsolePrompt
                ConsoleThreadCount
                ConsoleTrap
                CurTool
                ErrTrap
                LibVersion
                ScriptBasename
                ScriptDirectory
                ScriptFullName
                ToolsConfig
                ToolsConfigFile
                ToolsDirectory
                TranscriptsDir
                TranscriptsFile
        Alias:
        ValidateSet:  

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
	    Command: Set-BluGenieSessionInfo
        Description: Capture the Default BluGenie Session variables in to an Environement variable named BGSessionInfo
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieSessionInfo -CaptureVarName 'TestVar' -EnvVarName 'NewSesson'
        Description: Capture the Variable TestVar in to a System Variable named NewSession
        Notes: 

    .EXAMPLE
	    Command: Set-SessionInfo
        Description: Capture the Default BluGenie Session variables in to an Environement variable named BGSessionInfo
        Notes: 

    .EXAMPLE
	    Command: Set-SessionInfo -CaptureVarName '^BG.*'
        Description: Capture all variables that start with BG in to an Environement variable named BGSessionInfo
        Notes: 

    .EXAMPLE
	    Command: Set-SessionInfo
                 Start-Job -Name 'Job1' -InitializationScript { Import-Module BluGenie; New-BluGenieSessionInfo } -ScriptBlock { Get-Module; Write-Host "`n`nTransDir = $TranscriptsDir" }
                 Receive-Job -Name 'Job1' -Keep
        Description: Capture the default BluGenie session variables, Create a new job, and Initialize the variables in the new session.
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieSessionInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieSessionInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        

    .NOTES

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
    [Alias('Set-SessionInfo')]
    #region Parameters
        Param
        (
            [String]$CaptureVarName = 'BGMemory|BGNoBanner|BGNoExit|BGNoSetRes|BGRemoveMods|BGUpdateMods|
ConsoleDebug|ConsoleJobTimeout|ConsolePrompt|ConsoleThreadCount|ConsoleTrap|CurTool|ErrTrap|LibVersion|ScriptBasename|
ScriptDirectory|ScriptFullName|ToolsConfig|ToolsConfigFile|ToolsDirectory|TranscriptsDir|TranscriptsFile|BGJSONJob',

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
        $CurCapture = New-Object PsObject
        Get-SessionVariableList -FormatView None | Where-Object -FilterScript { $_.Name -match $CaptureVarName } | `
            Select-Object -Property Name,Value | ForEach-Object `
            -Process `
            {
                $CurCapture | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value -Force -ErrorAction SilentlyContinue
            }

        $CurCaptureJSON = $CurCapture | ConvertTo-Json -Depth 5

        New-Item -Path Env:\ -Name $EnvVarName -Value "$CurCaptureJSON" -Force -ErrorAction SilentlyContinue
    #endregion Main
}
#endregion Set-BluGenieSessionInfo (Function)