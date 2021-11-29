<#
    .SYNOPSIS
        BluGenie Console

    .DESCRIPTION
        BluGenie Console

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1903.2005
        * Build Date Posted			:
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.11.0801
        * Comments                  :
        * Dependencies              :
            ~
#>

#region Build Notes
    <#
    ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
            ~ 1903.2005:* [Michael Arroyo] Added this information header to the main script
            ~ 1903.2104:* [Michael Arroyo] Updated the Parrell process to now capture and report error messages in the main .csv log
                        * [Michael Arroyo] Updated the offline json output to look the same as the online json output
                        * [Michael Arroyo] Modified the Get-ADMachineInfo function to pass data from the Console to remote machine
            ~ 1903.2401:* [Michael Arroyo] Updated the Get-LoadedRegHives function
            ~ 1903.2501:* [Michael Arroyo] Added Command Set-Prefetch to the validation Set List
                        * [Michael Arroyo] Updated function Get-RegistryProcessTracking, read the function help for details
            ~ 1903.2601:* [Michael Arroyo] Updated function Get-RegistryProcessTracking, read the function help for details
                        * [Michael Arroyo] Added Command Format-Event (Helper Function), read the function help for details
            ~ 1903.2701:* [Michael Arroyo] Added Command Get-AuditProcessTracking (Agent Function), read the function help for details
                        * [Michael Arroyo] Updated Command Set-Prefetch, read the function help for details
            ~ 1903.2804:* [Michael Arroyo] Added Command Get-WindowsUpdates (Agent Function), read the function help for details
            ~ 1904.0203:* [Michael Arroyo] Updated function Get-ChildItemList, read the function help for details
            ~ 1904.0204:* [Michael Arroyo] Updated function Get-WindowsUpdates, read the function help for details
            ~ 1904.0403:* [Michael Arroyo] Added Command Get-AutoRuns (Agent Function), read the function help for details
                        * [Michael Arroyo] Updated function Get-Signature, read the function help for details
                        * [Michael Arroyo] Updated function Get-ChildItemList, read the function help for details
            ~ 1904.0901:* [MIchael Arroyo] Updated function Build-HelpMenu, read the function help for details
            ~ 1904.1101:* [MIchael Arroyo] Updated function Get-SystemInfo, read the function help for details
                        * [Michael Arroyo] Updated JSON Import to Validate both the JSON System Names and the passed parameter System Names
                        * [Michael Arroyo] Updated JSON Import to Validate both the JSON JobID and the passed parameter JobID value
                        * [Michael Arroyo] Updated function Build-HelpMenu, read the function help for details
            ~ 1904.1703:* [Michael Arroyo] Updated function Commands to use the new function More or Show-More function to display data in
                                            the [More] format.
                        * [Michael Arroyo] Added function Show-More, Read the function help for details
                        * [Michael Arroyo] Removed 'HelpMenu Build-HelpMenu' command.  This is processing loop on the help file
                        * [Michael Arroyo] Updated function Build-HelpMenu, read the function help for details
                        * [Michael Arroyo] Update function Get-Registry, read the function help for details
                        * [Micahel Arroyo] Added function Get-FileSnapshot, Read the function help for details
            ~ 1904.2501:* [Michael Arroyo] Added function Build-Command, Read the function help for details
                        * [Michael Arroyo] Added function Send-Item , Read the function help for details
            ~ 1905.0701:* [Michael Arroyo] Fixed occuring error when running remote commands ("Error";"Cannot bind argument to parameter
                                            'Name' because it is an empty string.")
                        * [Michael Arroyo] Added function Install-Harvester, Read the function help for details
            ~ 1905.1301:* [Michael Arroyo] Updated function Get-SystemInfo, Read the function help for details
                        * [Michael Arroyo] Added Alias Run to function Invoke-Process
                        * [Michael Arroyo] Added Parameter ThreadCount to Invoke-Process / Run to allow for dynamic management of how many
                                            threads are running at once
                        * [Michael Arroyo] Added Open-Log to Allowed Commands
                        * [Michael Arroyo] Added Open-LogDir to Allowed Commands
                        * [Michael Arroyo] Added client function Extract-ArchivePS2 to replace the PowerShell 5.0 version of the command
                        * [Michael Arroyo] Ran the script through a Powershell Analyzer and fixed all outstanding flagged issues or warnings.
                        * [Michael Arroyo] Added Aliases in a PowerShell 2 & 3 format.  PowerShell 5 was the only version to see the Alias
                                            binding in the function itself.
            ~ 1905.2001:* [Michael Arroyo] Updated all source to support PowerShell 3.
                        * [Michael Arroyo] Updated process (Tools Config) to support PowerShell 3.0
                        * [Michael Arroyo] Updated function Invoke-Process, Read the function help for details
                        * [Michael Arroyo] Updated function Pull-FirewallRules, Read the function help for details
            ~ 1905.2202:* [Michael Arroyo] Removed dependency for reverse DSN to be enabled
                        * [Michael Arroyo] Updated all the Dynamic help sub functions to version 1905.2401
                        * [Michael Arroyo] Added a section to copy downloaded files (sysinternal utilities or other) to their appropriate
                                            blubin sub directory locations
                        * [Michael Arroyo] Added function Install-SysMon, Read the function help for details
            ~ 1905.2701:* [Michael Arroyo] Updated function Get-SystemInfo, Read the function help for details
                        * [Michael Arroyo] Updated function Invoke-NetStat, REad the function help for details
            ~ 1905.2702:* [Michael Arroyo] Updated function Send-Item, Read the function help for details
                        * [Michael Arroyo] Updated the reverse DNS call.  After further testing it was detemrined that WMI does a reverse
                                            lookup anyway.
                        * [Michael Arroyo] Updated the CurSytem reference to be the computer name from the remote machine validated with WMI
            ~ 1905.2703:* [Michael Arroyo] Updated function Get-ChildItemList, Read the function help for details
            ~ 1905.2704:* [Michael Arroyo] Updated function Get-ChildItemList, Read the function help for details
                        * [Michael Arroyo] Updated function Get-Registry, Read the function help for details
            ~ 1905.2705:* [Michael Arroyo] Updated function Get-Registry, Read the function help for details
            ~ 1905.2706:* [Michael Arroyo] Updated the current thread count from 50 to 200
            ~ 1906.0701:* [Michael Arroyo] Updated function Get-ChildItemList, Read the function help for details
            ~ 1906.1001:* [Michael Arroyo] Updated function Get-ChildItemList, Read the function help for details
                        * [Michael Arroyo] Updated function Get-HashInfo, Read the function help for details
            ~ 1906.1701:* [Michael Arroyo] Updated function Get-COMObjectInfo, Read the function help for details
            ~ 1906.1702:* [Michael Arroyo] Updated function Get-COMObjectInfo, Read the function help for details
                        * [Michael Arroyo] Updated function Invoke-NetStat, Read the function help for details
            ~ 1906.2501:* [Michael Arroyo] Updated function Send-Item, Read the function help for details
                        * [Michael Arroyo] Updated function Install-Sysmon, Read the function help for details
                        * [Michael Arroyo] Updated the Offline process for Install-Sysmon to push the (Computer Name) on the fly
                        * [Michael Arroyo] Updated the Offline process for Install-Sysmon to only process the -CopyOnly parameter and all
                                            other parameters will get sent to the remote client
            ~ 1907.0201:* [Michael Arroyo] Updated the agent function Install-Sysmon, Read the function help for details
            ~ 1907.0202:* [Michael Arroyo] Updated the agent function Install-Harvester, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Install-Sysmon, Read the function help for details
                        * [Michael Arroyo] Updated the host function Send-Item, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Build-Command, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Install-Sysmon, Read the function help for details
                        * [Michael Arroyo] Updated the Offline process for Install-Harvester to push the (Computer Name) on the fly
                        * [Michael Arroyo] Updated the Offline process for Install-Harvester to only process the -CopyOnly parameter and all
                                            other parameters will get sent to the remote client
            ~ 1907.0203:* [Michael Arroyo] Updated the agent function Get-COMObjectInfo, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Send-Item, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Get-ChildItemList, Read the function help for details
            ~ 1907.0501:* [Michael Arroyo] Added WSMan ConCurrent Session, Shell, Memory, User, and Command limit management.  The
                                            configuation is in Config.JSON and set when Blu Genie if first launched or Reloaded.
            ~ 1907.0502:* [Michael Arroyo] Updated the agent function Get-COMObjectInfo, Read the function help for details
                        * [Michael Arroyo] Updated the agent function Send-Item, Read the function help for details
            ~ 1907.0503:* [Michael Arroyo] Updated the agent function Get-ChildItemList, Read the function help for details
            ~ 1907.0504:* [Michael Arroyo] Added a process to convert all ( INT ) types in the (JSON) output to a ( String ) type for ES.
            ~ 1907.1001:* [Michael Arroyo] Added a process to convert all ( Command ) type properties to an ( Array of Objects ) type for ES.
                        * [Michael Arroyo] Added a process to convert all ( Hash ) type properties to a ( String ) type for ES.
            ~ 1907.1002:* [Michael Arroyo] Added a process to convert all ( Value ) type properties to a ( String ) type for ES.
                        * [Michael Arroyo] Added a process to convert all ( LastTaskResult ) properties to a ( String ) type for ES.
            ~ 1907.1003:* [Michael Arroyo] Updated the agent function Get-SystemInfo, Read the function help for more detials
                        * [Michael Arroyo] Added host function Resolve-BgDnsName (Alias -> Ping), Read the function help for more detials
                        * [Michael Arroyo] Added host function Connect-ToSystem (Alias -> Connect), Read the function help for more detials
            ~ 1907.1004:* [Michael Arroyo] Updated host function Resolve-BgDnsName (Alias -> Ping), Read the function help for more detials
                        * [Michael Arroyo] Updated host function Connect-ToSystem (Alias -> Connect), Read the function help for more detials
            ~ 1907.1501:* [Michael Arroyo] Added agent parallel command processing
                        * [Michael Arroyo] Added agent post command processing
                        * [Michael Arroyo] Updated the JSON job process to support parallel commands
                        * [Michael Arroyo] Updated the JSON job process to support post commands
                        * [Michael Arroyo] Updated the JSON job process to support thread count management
                        * [Michael Arroyo] Added agent function Start-RunSpace, Read the function help for more details.
                                            You cannot make a direct call to this function
                                            This is a hidden function and can only be tested using a JSON job with parallel commands
                        * [Michael Arroyo] Updated the agent function Get-ProcessList, Read the function help for details
                        * [Michael Arroyo] Added BluGenie ASCII Art to the loading screen
                        * [Michael Arroyo] Updated the Commands List to be more descriptive
            ~ 1907.2901:* [Michael Arroyo] Updated agent function Start-RunSpace, Read the function help for more details.
                                            You cannot make a direct call to this function
                                            This is a hidden function and can only be tested using a JSON job with parallel commands
                        * [Michael Arroyo] Updated the JSON return so the parallel and post commands are reassembled back to the older format
                                            (single command list)
                        * [Michael Arroyo] Added a header in the JSON return for parallel commands.  This way you can track what commands were
                                            sent in parallel
                        * [Michael Arroyo] Added a header in the JSON return for post commands.  This way you can track what commands were
                                            sent in post
                        * [Michael Arroyo] Updated agent function Get-ProcessList, Read the function help for more details.
            ~ 1907.2902:* [Michael Arroyo] Updated the IP detection method.  The older method would process a false positive of an IP if there
                                            were 3 ( Periods ) in the FQDN (<hostname>.<domain>.<domain>.com)
                        * [Michael Arroyo] Renamed the Commands function to BGCommands.
                        * [Michael Arroyo] Setup an Alias for Help to point to BGCommands.  The internal PowerShell Help is no longer valid.
            ~ 1907.2903:* [Michael Arroyo] Updated the IP to Hostname resolver.  This will now use whatever name is given back from DNS as the
                                            (connection/remote management) point
            ~ 1907.2904:* [Michael Arroyo] Updated the Hostname to IP resolver to support the use of a FQDN (fully qualifed domain name)
            ~ 1907.2905:* [Michael Arroyo] Updated the BluGenie Agent function called ( Start-RunSpace ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the ParallelCommands process to fix the error ("Property 'parallelcommands' cannot be found
                                            on this object; make sure it exists and is settable.")
                        * [Michael Arroyo] Updated the ParallelCommands section variables to track issues better.  There were no errors but
                                            based on the values being the same name it was harder to track the above error
                        * [Michael Arroyo] Updated the PostCommands section variables to track issues better.  There were no errors but based
                                            on the values being the same name it was harder to track
            ~ 1907.2906:* [Michael Arroyo] Added a BluGenie Host function called ( Systems ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host function called ( Commands ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( ParallelCommands ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( PostCommands ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( ThreadCount ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( Range ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( Invoke-FileBrowser ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( JSON ).  Read the function help for more details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( Wipe ).  Read the function help for more details.
                        * [Michael Arroyo] Updated BGCon.ps1 to run in PowerShell for testing purposes.  The .lib detects if the session is a
                                            console session or an ISE session.
                                            If an ISE session is detected, all console related actions are silenced.
                        * [Michael Arroyo] Updated the BluGenie Client function called ( Build-HelpMenu ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Added a BluGenie Host fucntion called ( Settings ).  Read the function help for more details.
            ~ 1908.0901:* [Michael Arroyo] Updated the BluGenie Host function called ( Send-Item ).  Read the function help for more details.
                        * [Michael Arroyo] Updated the JSON return structure after supporting FQDN.  Easier data captureing from remote hosts.
                        * [Michael Arroyo] Updated the BluGenie Client function called ( Get-HashInfo ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Client fucntion called ( Get-ProcessList ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Client fucntion called ( Get-SystemInfo ). Read the function help for more
                                            details.
            ~ 1908.1401:* [Michael Arroyo] Updated the BluGenie Client function called ( Get-HashInfo ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Client fucntion called ( Get-ProcessList ). Read the function help for more
                                            details.
            ~ 1908.1402:* [Michael Arroyo] Updated the BluGenie Client fucntion called ( Get-ProcessList ). Read the function help for more
                                            details.
            ~ 1908.1403:* [Michael Arroyo] Added a BluGenie Client process called ( YAML Internal Functions ).  This houses all the helper
                                            functions for Yaml Support
                        * [Michael Arroyo] Added a BluGenie Client fucntion called ( ConvertFrom-Yaml ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Added a BluGenie Client fucntion called ( ConvertTo-Yaml ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the remote return data to dynamically collect data from specific objects.  This resolves
                                            issues when calling a valid IP but getting remote return data with an IP of a 2nd nic that doesn't
                                            have a valid IP address.
                        * [Michael Arroyo] Fixed the Command level process indicator
                        * [Michael Arroyo] Added a ( Trap ) parameter to ( Invoke- Process ) to trap all the log data to the remote system.
                                            Job information is logged in the Windows event log under Application.
                                            ID ( 7114 ) No known current ID, G = 71 & 14 so the ID is ( G14 )
                                            Source ( BluGenie )
                        * [Michael Arroyo] Renamed the Field header ( Hostname ) to ( hostname ) for ES related issues.
                        * [Michael Arroyo] Update the TransScriptFile with more loading details
                                            * ScriptDirectory Path
                                            * TranscriptsDir Path
                                            * TranscriptsFile Path
                                            * Loaded Tools and information properties
                                            * WinRM Settings
                        * [Michael Arroyo] Updated the Tools binding process.  Tools will no longer be bound and copied over the Invoke-Command
                                            process.  They will be sent via the new function ( Send-Item )
                        * [Michael Arroyo] Updated the Configuration Tools process to map the FullPath and FullRemoteDestination.  This data is
                                            also logged in the TransScript file.
                        * [Michael Arroyo] Added an automatic debugging mode when running BGCon.ps1 in the ISE.
                                            * ArgHAsh_<computername>.txt is saved to the TransScript Directory and it holds all the Arguments
                                            that will be passed to the remote system.
                                            * Parameter_<computername>.txt is saved to the TransScript Directory and it holds all the Parameters
                                            from ( Invoke-Process ).
                                            * RemoteReturn_<computername>.txt is saved to the TranScript Directory and it holds all the
                                            unfilterd Return data after running all commands on the remote system
                                            * BluGenieArgs.txt is saved on the Remote Host under C:\Windows\Temp and it holds all the Arguemnts
                                            received from the responder
                                            * BluGenieToolsConfig.txt is saved on the Remote Host under C:\Windows\Temp and it holds the Tools
                                            configuration data received from the responder
                        * [Michael Arroyo] Updated the BluGenie Host fucntion called ( Wipe ). Read the function help for more details.
                        * [Michael Arroyo] Updated the BluGenie Host fucntion called ( Settings ). Read the function help for more details.
                        * [Michael Arroyo] Updated the BluGenie Host fucntion called ( Invoke-Process ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host fucntion called ( SetTrapping ). Read the function help for more details.
                        * [Michael Arroyo] Updated the Json Job process to support the ( Trap ) parameter
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Build-HelpMenu ). Read the function help for more
                                            details.
            ~ 1908.1404:* [Michael Arroyo] Added BluGenie support file logging.  All external files needed for BluGenie to work will be
                                            validated and logged.
            ~ 1908.2201:* [Michael Arroyo] Removed Yaml to PSObject code and .DLL support
                        * [Michael Arroyo] Removed Yaml .DLL's from the Main Config
                        * [Michael Arroyo] Updated the BluGenie Host fucntion called ( Resolve-BGDNSName -or- Ping ). Read the function help
                                            for more details.
                        * [Michael Arroyo] Added a Real Time Job Manager to have a quick way to termine what systems have completed, failed,
                                            and are still in progress
                        * [Michael Arroyo] Update the [Settings and Trap Information] Screens to support a Yaml view (No 3rd party support
                                            needed).
                        * [Michael Arroyo] Added the BluGenie Host function called ( Invoke-PSQuery ). Read the function help for more details.
                        * [Michael Arroyo] Added an Alias for the BluGenie Host function called ( Invoke-PSQuery ). Alias is called [PSQuery]
                        * [Michael Arroyo] Added a new BluGenie Host function called ( Invoke-PSQuery -or- PSQuery ). Read the function help
                                            for more details.
            ~ 1909.2001:* [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-Process ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-Parallel ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BGCommands Help Menu to support the new function Invoke-PSQuery and PSQuery
                        * [Michael Arroyo] Updated the Dynamic Help function to support the new function Invoke-PSQuery and PSQuery
            ~ 1909.2401:* [Michael Arroyo] Updated all BG Agent functions to PowerShell 2.0 compatible
            ~ 1910.0301:* [Michael Arroyo] Added a new BluGenie Host function called ( Invoke-WalkThrough ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Client function called ( Add-FirewallRule ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Client function called ( Start-RunSpace ).  Read the function help for more
                                            details.
                        * [Michael Arroyo] Moved the default firewall rules path to $ScriptDirectory\Tools\Blubin\FirewallRules
            ~ 1910.0302:* [Michael Arroyo] Updated the BluGenie Host function called ( Add-FirewallRule ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Enable-FirewallRule ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Enable-AllFirewallRules ). Read the function help for
                                            more details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Disable-FirewallRule ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-ProcessList ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Disable-AllFirewallRules ). Read the function help for
                                            more details.
                        * [Michael Arroyo] Removed the JSON Output parser.  This was to fix an error where it failed to parse the JSON and fix
                                            Type Casting for ES.
                                            The process worked on PS2 but failed on PS3 and PS5 and when made to work on PS3 and PS5, it would
                                            fail on PS2.
            ~ 1910.2301:* [Michael Arroyo] Updated the BluGenie Host function called ( Set-FirewallStatus ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Remove-FirewallRule ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Update-FirewallProfileStatus ). Read the function help
                                            for more details.
            ~ 1910.2501:* [Michael Arroyo] Updated the BluGenie Host function called ( Manage-ProcessHash ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-ChildItemList ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-LiteralPath ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-FirewallRules ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Set-FirewallGPOStatus ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-WalkThrough ). Read the function help for more
                                            details.
            ~ 1911.0401:* [Michael Arroyo] This update is focused on chaining PSQuery commands with BluGenies remote management
                                            BluGenie can now collect general system information over WMI, Filter, and Process remote commands
                                            all in 1 command with an external JSON job file.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-PSQuery ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-Childitemlist ). Read the function help for more
                                            details.
            ~ 1911.0501:* [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-PSQuery ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Updated the BluGenie Host function called ( Get-Childitemlist ). Read the function help for more
                                            details.
            ~ 1911.0701:* [Michael Arroyo] Merged BGCon.ps1 into the main script, BluGenie.ps1 for a single compiled engine and zero AES 256
                                            encrypted external .lib files.
                        * [Michael Arroyo] Updated the Core Display functions to work in both the PowerShell ISE and the Command Console
                                            Framework.
            ~ 1911.1101:* [Michael Arroyo] Updated the BluGenie Host function called ( Set-FirewallStatus ). Read the function help for more
                                            details.
            ~ 1911.1201:* [Michael Arroyo] Updated the CommandLine parser.  The Command line for Blugenies internal functions is the first
                                            parameter.  Other parameters work with or without a command line (/Verbose)
                        * [Michael Arroyo] Updated the BluGenie Client function called ( Invoke-WalkThrough ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Added the BluGenie Host function called ( Write-VerboseMsg ). Read the function help for more
                                            details.
                        * [Michael Arroyo] Added Verbose TimeStamp output to the Console.  This will help idnetify any loading issues and which
                                            section of code is taking the longest to run
						* [Michael Arroyo] Removed Aliases ?? / HelpMenu / and HM
						* [Michael Arroyo] Updated the BluGenie Client function called ( Update-FirewallProfileStatus ). Read the function help
                                            for more details.
			~ 1911.1202:* [Michael Arroyo] Updated External Tool Framework (In this case any SysInternals Tools)
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-AutoRuns ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-BGHelp ). Read the function help for more details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Invoke-WalkThrough ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Update-FirewallProfileStatus ). Read the function help
                                            for more details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-Signature ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Get-LockingProcess ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Start-NewProcess ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( ScriptDirectory ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( ToolsDirectory ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( TranscriptsDir ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( TranscriptsFile ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Show-More ). Read the function help for more details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added better screen visibility.  When running in console mode, the screen will automatically resize
                                            to a buffersize and screen width of 150
			~ 1911.1203:* [Michael Arroyo] Added Function ( Get-LockingProcess ) to the remote command list
						* [Michael Arroyo] Added Function ( Start-NewProces ) to the remote command list
						* [Michael Arroyo] Added a new BluGenie Client function called ( ScriptDirectory ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( ToolsDirectory ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( TranscriptsDir ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( TranscriptsFile ). Read the function help for more
                                            details.
			~ 1911.2501:* [Michael Arroyo] Updated the BluGenie Client function called ( Get-SchTaskInfo ). Read the function help for more
                                            details.
			~ 1911.2502:* [Michael Arroyo] Updated the BluGenie Client function called ( Invoke-NetStat ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Manage-ProcessHash ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-ProcessList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-ServiceList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Get-SchTaskInfo ). Read the function help for more
                                            details.
			~ 1911.2503:* [Michael Arroyo] Updated the Parallel Commands return object to conform with Commands and Post Commands return object
                                            to work with Elastic Search.
				        * [Michael Arroyo] Updated the BluGenie Client function called ( Manage-ProcessHash ). Read the function help for more
                                            details.
			~ 1912.2504:* [Michael Arroyo] Updated the BluGenie Client function called ( Get-COMObjectInfo ). Read the function help for more
                                            details.
			~ 1912.0901:* [Michael Arroyo] Added a new BluGenie Client function called ( Get-COMObjectInfo ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Manage-ProcessHash ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Get-ProcessList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Invoke-Netstat ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Get-ServiceList ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Update-FirewallProfileStatus ). Read the function help
                                            for more details.
						* [Michael Arroyo] Expose Get-Lockedprocess to console and remote commands
						* [Michael Arroyo] Expose Manage-Processhash to console and remote commands
						* [Michael Arroyo] Resolved Loop Back process where the responder connects back to itself
			~ 1912.1601:* [Michael Arroyo] Updated the BluGenie Client function called ( Update-FirewallProfileStatus ). Read the function help
                                            for more details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Get-ErrorAction ). Read the function help for more
                                            details.
						* [Michael Arroyo] Added a new BluGenie Client function called ( Track-FireWallStatus ). Read the function help for
                                            more details.
						* [Michael Arroyo] Updated the core to use default runtime values to figure out where the executable is running from.
										The process no longer looks for the BluGenie PID to figure out where it is running from.
						* [Michael Arroyo] Updated the core to figure out the current executable name using default runtime values.
                                            This was hard coded before to 'BluGenie'.
            ~ 1912.1602:* [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ).
                                            Read the function help for more details.
            ~ 1912.1603:* [Michael Arroyo] JSON import for Invoke-Process is set to similar syntax like JSON Import.
            ~ 1912.1604:* [Michael Arroyo] Updated the Blugenie Help Header to the new viewable standard
                        * [Michael Arroyo] Log Command line to the Transcript Log
						* [Michael Arroyo] Log Command line length to the Transcript Log
						* [Michael Arroyo] Added a new parameter called [ Debug ] to capture any errors left behind in the $Error variable.
						* [Michael Arroyo] Added support for the Jobtimeout parameter in the JSON job
						* [Michael Arroyo] Updated the BluGenie Client function called ( JSON ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Settings ). Read the function help for more
                                            details.
						* [Michael Arroyo] Updated the BluGenie Client function called ( Wipe ). Read the function help for more
                                            details.
			~ 1912.1605:* [Michael Arroyo] Moved the debug overlay up in the process to capture more output in verbose mode
			            * [Michael Arroyo] Added the NoSetRes parameter so to not update the consoles viewable screen size
			            * [Michael Arroyo] Updated the parameter data to use $MyInvocation.UnboundArguments instead of using $Args
			            * [Michael Arroyo] Updated the Command line parser to parse via regex and if a parameter is found to remove it from the
                                            command line string so Blugenie agent commands get processed correctly.
			            * [Michael Arroyo] Added the captured parameter data to the default transcript log file
			            * [Michael Arroyo] Added the captured parameter data length to the defualt transcript log file
			            * [Michael Arroyo] Added Debug information to JSON import on the Invoke-Process function
			            * [Michael Arroyo] Added JobTimeOut information to JSON import on the Invoke-Process function
			            * [Michael Arroyo] Updated the Job data to show RunSpaceTimeOut in Minutes
			            * [Michael Arroyo] Updated the Job data to show SleepTimer in MS = Milliseconds
			~ 1912.1605:* [Michael Arroyo] Updated the Console check to validate only once.  Console validation was happing in the BluGenie
                                            Core and in the Invoke-Process function
						* [Michael Arroyo] Updated the BluGenie Client function called ( Enable-WinRMoverWMI ). Read the function help
                                            for more details.
						* [Michael Arroyo] Updated the /NoSetRes parameter to disable all Screen position updates if enabled
            ~ 2002.1001:• [Michael Arroyo] Rebuilt the /Verbose command to be parsed easier
                        • [Michael Arroyo] Rebuilt the /Help command to be parsed easier
                        • [Michael Arroyo] Rebuilt the /Debug command to be parsed easier
                        • [Michael Arroyo] Rebuilt the /NoSetRes command to be parsed easier
                        • [Michael Arroyo] Added the /NoExit parameter.  This parameter keeps the Console opened even after running an
                                            automated JSONJob.  Helps with troubleshooting, etc.
                        • [Michael Arroyo] Added the /NoBanner parameter.  This parameter will disable the BluGenie Banner from showing
                        • [Michael Arroyo] Added the /OC parameter.  This parameter will enable the older BluGenie Console.  This is also the
                                            default for the console being ran on a PS3 system.
                        • [Michael Arroyo] Added the /Hidden parameter.  This parameter will launch BluGenie with no screen.  This is good for
                                            sessions with no users logged in.
                            o	This also automatically enabled /NoSetRes.  So no updates to the screen will be processed.  As there is no
											viewable screen
                        • [Michael Arroyo] The Entire console was rewritten
                            o	Added a much easier parameter management process.  New parameters can be easily added.
                            o	2 Console engines now exist.
                                	The default using the Read-Host function.
                                    •	The biggest downfall was the commands had to be memorized.  Somewhat difficult to know what commands
										could be ran without running a full /Help process to understand everything.
                                	The new Console engine is identical to how PowerShell runs
                                    •	Custom Tab Completion (for BluGenie Commands Only)
                                    •	Syntax checking
                                    •	Full History that can be viewed at a glance, sorted, filtered, and pushed back into the console.
                                    •	Visual Command List that can be viewed at a glance, sorted, filtered, and pushed back into the console.
                                    •	Visual Help tied directly into the Interactive Help Sub system
			~ 2002.2401:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-SystemInfo ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ProcessList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the Console to remove any special char from the commandline at run time.
                            o	Blugenie.exe "/verbose /debug" was being processed after the switches were removed as
								("    ").  Now there is a regex looking for any special char without interal text and removing them.
			~ 2002.2601:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-SchTaskInfo ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ServiceList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Invoke-NetStat ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Manage-ProcessHash ). Read the function help
                                            for more details.
			~ 2002.2602:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ServiceList ). Read the function help
                                            for more details.
			~ 2002.2603:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ServiceList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-Parallel ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-SchTaskInfo ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the Console to exit all scopes with command [Environement]::Exit().  In PS3 the system
											would hang at the prompt and you would have to type Exit again.
			~ 2002.2604:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Enable-WinRMoverWMI ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-HashInfo ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the New console to only run when Set-PSReadlineKeyHandler and PowerShell Version is greater
                                            than 5.1
			~ 2002.2605:• [Michael Arroyo] Updated the BluGenie Client function called ( Get-ChildItemList ). Read the function help
                                            for more details.
						• [Michael Arroyo] Updated the BluGenie Client function called ( Get-HashInfo ). Read the function help
                                            for more details.
            ~ 2002.2606:• [Michael Arroyo] Updated the Error management around Posh 3,4, and 5 console execution.  This was causing the
                                            console to fail when running on an older version of Posh.  This is a Host related issues,
                                            not a remote client posh error.
                        • [Michael Arroyo] Added the PID information to JSON Computer Job file
                        • [Michael Arroyo] Added the PID and the JObID to the JSON file trap data name
                        • [Michael Arroyo] Updated the BluGenie Client function called ( Get-Registry ). Read the function help
                                            for more details.
                        • [Michael Arroyo] Updated the BluGenie Client function called ( Get-LockingProcess ). Read the function help
                                            for more details.
                        • [Michael Arroyo] Updated the BluGenie Client function called ( Start-NewProcess ). Read the function help
                                            for more details.
                        • [Michael Arroyo] Updated the BluGenie Client function called ( Invoke-Process ). Read the function help
											for more details.
            ~ 2002.2607:• [Michael Arroyo] Added support for memory cap limiting on job creation
                        • [Michael Arroyo] Created a new BluGenie Host function called ( Set-ProcessCPUAffinity ). Read the function help
                                            for more details.
                        • [Michael Arroyo] Crated a new BluGenie Host function called ( Set-ProcessPriority ). Read the function help
                                            for more details.
                        • [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-Parallel ). Read the function help
                                            for more details.
            ~ 2002.2607:• [Michael Arroyo] Added support for memory cap limiting on job creation
                        • [Michael Arroyo] Created a new BluGenie Host function called ( Set-ProcessCPUAffinity )
                        • [Michael Arroyo] Created a new BluGenie Host function called ( Set-ProcessPriority )
                        • [Michael Arroyo] Updated the BluGenie Host function called ( Invoke-Parallel )
                        • [Michael Arroyo] New CLI parameter ( Unlock ) to unlock Posh functions to BG
                        • [Michael Arroyo] New CLI parameter ( Cores ) to set which Core to run BG on
                        • [Michael Arroyo] New CLI parameter ( Priority ) to set BG's Process Priority
                        • [Michael Arroyo] New CLI parameter ( Memory ) to set BG's Memory Limit per job.
                        • [Michael Arroyo] Set the Processor affinity for a running Process by specifying the CPU Cores that it can run on, and
                                            the name or PID of a Process(s)
                        • [Michael Arroyo] Set the Processor Priority for a running Process based on 6 different priority levels.
            ~ 20.06.2701• [Michael Arroyo] Updated remote code to update the Execution Policy while importing BluGenie Modules.  The Execution
											policy is set back to the original setting after the modules are loaded.
			~ 20.11.1801• [Michael Arroyo] Captured the first launch PID into a new Environment variable $Env:BgPid
						• [Michael Arroyo] Updated the Library version to pull the version number of the BluGenie Framework instead of the
                                            BluGenie.exe.
						• [Michael Arroyo] Captured the PID for the Controlling Windows Frame of BluGenie into a new Environment variable
                                            $env:BgWinPid
						• [Michael Arroyo] Captured the Windows Framework Handle into a new Environment variable $env:BgWinHandle
            ~ 20.11.2301• [Michael Arroyo] Updated the Job execution process to run on the local host by using the name (localhost) in the systems
                                            list
                        • [Michael Arroyo] If LocalHost is used in the systems list, WinRM can be disabled (Only for the localhost)
                        • [Michael Arroyo] If LocalHost is used in the systems list, WinRM, the Service, and the WinRM Configuration will not be
                                            parsed or updated (Only for the localhost)
                        • [Michael Arroyo] If LocalHost is used in the systems list, the IP info can be (169.* or 127.*) (Only for the localhost)
                        • [Michael Arroyo] If LocalHost is used in the systems list, Modules will not be copied or reloaded (Only for the
                                            localhost)
                        • [Michael Arroyo] If LocalHost is used in the systems list, the Returned JSON is named (LocalHost.JSON) (Only for the
                                            localhost)
            ~ 20.12.1701• [Michael Arroyo] Added support to only overwrite core (EXE) files being copied to the remote machine if the
                                            $BGUpdateMods = $true  (This speeds up new job tasks)
			~ 21.01.0402• [Michael Arroyo] Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the
                                            information correctly":
						• [Michael Arroyo] Added support for ServiceJob
						• [Michael Arroyo] Added CLI Parameter for ServiceJob
						• [Michael Arroyo] Added new variable $BGServiceJobFile which captures all of the BluGenie Settings and saves it as a
											Job file for the BluGenie Service to use on the remote system
						• [Michael Arroyo] Updated the LocalIP call on the remote system to action with WMI.  The new process looks for IP V4
                                            Addresses
											that have a valid GateWay assigned as well.  This helps resolve the 169 address lookup.
						• [Michael Arroyo] JSONReturn has been cleaned up.  No difference to Output.
						• [Michael Arroyo] Updated the /Debug action to Output debugging information on the remote machine.
											* All Arguments sent to the machine are capture to a single log file called
                                                %SystemDrive%\Windows\Temp\BluGenieArgs.txt
											* All Tools Configuration sent to the machine are capture to a single log file called
                                                %SystemDrive%\Windows\Temp\BluGenieToolsConfig.txt
						• [Michael Arroyo] Process BG Settings as a Service Job if the setting is set to True.  The option can be set with the
                                            Console or the CLI.  If the machine is Not PowerShell 3 or above and the Service is not running, the
                                            normal query job will take place.
			~ 21.02.1501• [Michael Arroyo] Core structure change to support the new executable
						• [Michael Arroyo] Removed the (New-MemoryMappedFile) Function as it’s no longer used
						• [Michael Arroyo] Removed the (Open-MemoryMappedFile) Function as it’s no longer used
						• [Michael Arroyo] Removed the (Out-MemoryMappedFile) Function as it’s no longer used
						• [Michael Arroyo] Removed the (Read-MemoryMappedFile) Function as it’s no longer used
						• [Michael Arroyo] Removed the (Remove-MemoryMappedFile) Function as it’s no longer used
						• [Michael Arroyo] Updated the Bound Parameters to use the $Env:Stub* variables.  The Stub variables are created at
                                            runtime for the Stub.exe -> BluGenie.exe for the current session only.
						• [Michael Arroyo] Moved all the Sub Processes out of the $Setup script block so they run during the BluGenie.exe launch.
                                            They no longer need to be processes as a script block in a new PowerShell session.
						• [Michael Arroyo] Update the parameter /NoExit -> /BGNoExit so to not conflict with the Stub.exe –Blugenie.exe /NoExit.
						• [Michael Arroyo] Removed region 001BluGenie Env Variable which sets all the Memory mapping in PowerShell’s new session.
						• [Michael Arroyo] Removed the New PowerShell session creation in the Start Core Engine region.  This is managed by
                                            Stub.exe -> Blugenie.exe now.
						• [Michael Arroyo] As BluGenie is no longer stored in memory to pass from session to session on the host.  Updating the
                                            BluGenie.exe no longer needs a system restart.
						• [Michael Arroyo] Roughly downsized the BluGenie.ps1 by 500 lines of code with this update.
						• [Michael Arroyo] If BluGenie.ps1 needs to be updated, you no longer have to compile to BluGenie.exe which speeds up
                                            development.
            ~ 21.04.0701• [Michael Arroyo] Updated the Loading screen to show how to run the new Help process
                        • [Michael Arroyo] Removed the Help Flag BgHidefromHelp.  This is now managed by the CLI Process
                        • [Michael Arroyo] Updated the CLI Help screen to show a cleaner overview of how to run BluGenie.exe
                        • [Michael Arroyo] Updated all the CLI commands to run as abbreviations as well as the full command names
            ~ 21.04.1901• [Michael Arroyo] Updated the JSON Job call to the new function Publish-BlugenieArtifact
            ~ 21.11.0801 [BluGenie]
                            o [Michael Arroyo] Updated HelpMnu.dat to include the new Help Module information
                            o [Michael Arroyo] Added Walk as an Alias for Invoke-WalkThrough
                        [BluGenie.psm1]
                            o [Michael Arroyo] Consolidated Code (Removed 800 plus lines of code with this update)
                            o [Michael Arroyo] Updated all ForEach-Object references to ForEach to determine speed updates (only gained 3 seconds
                                in load time)
                        [Set-BluGenieJobId]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through Function to the newest standard
                        [Set-BluGenieCommands]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through Function to the newest standard
                        [Set-BluGenieParallelCommands]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through Function to the newest standard
                        [Set-BluGeniePostCommands]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through Function to the newest standard
                        [Set-BluGenieSystems]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through Function to the newest standard
                        [Set-BluGenieThreadCount]
                            o [Michael Arroyo] Consolidated Code
                            o [Michael Arroyo] Updated the Parameter and Example Help Header Information
                            o [Michael Arroyo] Updated the Description Information for Help content
                            o [Michael Arroyo] Updated the Walk Through
                        [Get-BluGenieAutoRuns]
                            o [Ravi Vinod Dubey] Moved Build Notes out of General Posh Help section
                            o [Ravi Vinod Dubey] Added support for Caching
                            o [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
                            o [Ravi Vinod Dubey] Added support for SQLite DB
                            o [Ravi Vinod Dubey] Updated Process Query and Filtering
                            o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended
                                debugging info unless you manually set the -Verbose parameter.
                            o [Ravi Vinod Dubey] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                            o [Ravi Vinod Dubey] Change the script to check the AutoRuns tools in ..\Tools\SysinternalsSuite\
                        [Get-BluGenieFirewallRules]
                            o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                            o [Michael Arroyo] Moved Build Notes out of General Posh Help section
                            o [Ravi Vinod Dubey] Added support for Caching
                            o [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
                            o [Ravi Vinod Dubey] Added support for SQLite DB
                            o [Ravi Vinod Dubey] Added support for OutYaml
                            o [Ravi Vinod Dubey] Updated Process Query and Filtering
                            o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended
                                debugging info unless you manually set the -Verbose parameter.
                            o [Ravi Vinod Dubey] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                        [Invoke-BluGenieYara]
                            o [Michael Arroyo] Updated the function to the new function template
                            o [Michael Arroyo] Added more detailed information to the Return data
                            o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                            o [Michael Arroyo] Moved Build Notes out of General Posh Help section
                            o [Michael Arroyo] Added support for Caching
                            o [Michael Arroyo] Added support for Clearing Garbage collecting
                            o [Michael Arroyo] Added support for SQLite DB
                            o [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
                            o [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended
                                debugging info unless you manually set the -Verbose parameter.
                            o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                            o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                            o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                            o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                            o [Michael Arroyo] Tools path updated with $('{0}\Tools\Yara\{1}' -f $(Get-Location | Select-Object -ExpandProperty
                                Path), $Yara)
                            o [Michael Arroyo] Updated the CommandlineOptions switch process to pull from the parameters directly instead of the
                                PSBoundParameters. This is cleaner and also allows you to test in real time.  The old way using PSBoundParameters
                                is only valid at runtime or debug mode.
#>
#endregion Build Notes

#region Default Options
    $ErrorActionPreference = 'SilentlyContinue'
    $PSDefaultParameterValues = @{}
    $PSDefaultParameterValues.Add('Out-Default:OutVariable','LastResult')
    $PSDefaultParameterValues.Add("Write-Error:ErrorAction",'SilentlyContinue')
#endregion Default Options

#region Bound Parameters
	$env:BluGenieCommandLine = $env:StubCommandLinePassThrough
    $env:BluGenieParameters = $env:StubParameters
	$env:BluGenieScript = $env:StubBaseName
	$env:BluGenieExec = $env:StubFullname
	$env:BluGenieRoot = $env:StubPath
#endregion Bound Parameters

#region Setup
	$Commandline = $env:BluGenieCommandLine
	$Parameters = $env:BluGenieParameters
    $Env:BgPid = $env:StubPid
	$PSDefaultParameterValues = @{}
	$PSDefaultParameterValues.Add('Out-Default:OutVariable','LastResult')
	$PSDefaultParameterValues.Add("Write-Error:ErrorAction",'SilentlyContinue')
#endregion Setup

#region Command Line Parameters
	If
	(
		$CommandLine -match '/'
	)
	{
		$TempParameters = $CommandLine -replace '/','///'
		$SplitParams = $TempParameters -split '//'
	}
	Else
	{
		$SplitParams = $CommandLine
	}

    [bool]$BGVerbose = $false
	[bool]$BGConsole = $true
	[bool]$BGDebugger = $false
	[String]$BGJSONJob = $null
    [String]$BGSystems = $null
	[bool]$BGNoSetRes = $false
	[bool]$BGNoExit = $false
	[bool]$BGNoBanner = $false
    [bool]$BGUpdateMods = $false
    [bool]$BGServiceJob = $false
    [Int]$BGMemory = 512

    $Parameters -split ';' | ForEach-Object `
    -Process `
    {
        $CurParam = $_

        switch -regex ($CurParam)
        {
            '/verbose|/vb$'
            {
                $BGVerbose = $true
                $CommandLine = $Commandline -replace '/verbose|/vb'
            }
            '/Help|/h$'
            {
                $HelpOutputMsg = @'

Usage:
  BluGenie <options> [commands]

Options:
  /vb,          /verbose          : Show more detailed loading information to the console
  /h,           /help             : Print this message and exit
  /db,          /debug            : Run PowerShell's transcript process to capture more output
  /nos,         /nosetres         : Do not update the frame of the Console.  Use the OS's default command prompt size.
  /noe,         /bgnoexit         : Stay in the Console after executing an automated Job or command from the CLI.
  /nob,         /nobanner         : Do not display the BluGenie Welcome Screen.
  /hd,          /hidden           : Do not show the task window in the foreground view.
  /a=<str>,     /artifact=<str>   : Full file path to the JSON or YAML Artifact file
  /sys=<str>,   /systems=<str>    : Identify what systems to process an Artifact lookup on
                                        To parse a file for a list of computers use the "File:" prefix
                                            o Example: file:.\collections\systems.txt
                                        To parse a domain group for a list of computers use the "Group:" prefix
                                            o Example: group:S_Wrk_Posh3Systems
                                        To parse a domain group with a specific domain name, append to the end of the Group name ":Domain.com"
                                            o Example: group:S_Wrk_Posh3Systems:TestLab.com
                                                o Note:  The domain needs to be a trusted domain
  /c=<int>,     /cores=<int>      : Select the amount of cores you want this job to use.  Default is (ALL)
  /p=<int>,     /priority=<int>   : Select the priority level of the cuurent job. Default is (Normal)
                                        0 = Low
                                        1 = Below Normal
                                        2 = Normal
                                        3 = Above Normal
                                        4 = High
                                        5 = Realtime
  /M=<int>,     /memory=<int>    : Select the memory threshold for the current job.  Default is (512) MB.
                                        Note: <int> must be in MB format.  So 1GB is 1024, and so on.
  /umod,        /updatemods      : Force all managed BluGenie files and folders to be updated on the remote machine
  /sj,          /servicejob      : Send the artifact to the remote machine to be run by the BluGenie Service.
                                        Note: This will only work if the BluGenie service is running
                                                If not, the artifact will fall back to the remote connection
                                                execution process.

Commands:
  Run,          Invoke-BGProcess  : Start the job tasks on all remote systems specified
  BGHelp,       Get-BGHelp        : Display a list of the BluGenie Module Commands

Examples:
  - BluGenie.exe "/vb /nos /nob /a=.\Artifacts\threatdetect1.json run"
  - BluGenie.exe "/a=.\Artifacts\threatdetect1.yaml /c=2 /p=5 /m=2048 run"
  - BluGenie.exe "/artifact=.\Artifacts\threatdetect1.json /servicejob Invoke-BGProcess"
  - BluGenie.exe "/a=.\Artifacts\threatdetect1.yaml /sys=file:.\collections\systems.txt run"
  - BluGenie.exe "/a=.\Artifacts\threatdetect1.yaml /sys=group:S_Wrk_Posh3Systems run"
  - BluGenie.exe "/a=.\Artifacts\threatdetect1.yaml /sys=group:S_Wrk_Posh3Systems:TestLab.com run"
  - BluGenie.exe "/a=.\Artifacts\threatdetect1.yaml /sys=TestPC1,TestPC2,TestPC3 run"
  - BluGenie.exe "/bgnoexit bghelp"

'@
                Write-Host $HelpOutputMsg
                Exit
            }
            '/debug|/db$'
            {
                $BGDebugger = $true
                $CommandLine = $Commandline -replace '/debug|/db$'
            }
            '/nosetres|/nos$'
            {
                $BGNoSetRes = $true
                $CommandLine = $CommandLine -replace '/nosetres|/nos'
            }
            '/bgnoexit|/noe$'
            {
                $BGNoExit = $true
                $CommandLine = $CommandLine -replace '/BGNoExit|/noe'
            }
            '/nobanner|/nob$'
            {
                $BGNoBanner = $true
                $CommandLine = $CommandLine -replace '/nobanner|/nob'
            }
            '/hidden|/hd$'
            {
                $CommandLine = $CommandLine -replace '/hidden|/hd$'
            }
            '/artifact|/a'
            {
                $BGJSONJob = $($CurParam -replace '/artifact=|/a=') -replace '"' -replace "'"
                $CommandLine = $CommandLine.replace("$CurParam",'')
            }
            '/systems|/sys'
            {
                $BGSystems = $($CurParam -replace '/systems=|/sys=') -replace '"' -replace "'"
                $CommandLine = $CommandLine.replace("$CurParam",'')
            }
            '/cores|/c'
            {
                $BGCores = @()
                $($CurParam -replace '/cores=|/c=') -split ',' | ForEach-Object `
                -Process `
                {
                    $BGCores += [Int]$_
                }
                $CommandLine = $CommandLine.replace("$CurParam",'')
            }
            '/priority|/p'
            {
                $BGPriority = $($CurParam -replace '/priority=|/p=')
                $CommandLine = $CommandLine.replace("$CurParam",'')
            }
            '/memory|/m'
            {
                $BGMemory = [int]$($CurParam -replace '/memory=|/m=')
                $CommandLine = $CommandLine.replace("$CurParam",'')

                If
                (
                    $BGMemory -is [int]
                )
                {
                    $MaxmemoryMB = $($BGMemory * 1kb)
                }
            }
            '/updatemods|/umod$'
            {
                $BGUpdateMods = $true
                $CommandLine = $CommandLine -replace '/updatemods|/umod'
            }
            '/servicejob|/sj'
            {
                $BGServiceJob = $true
                $CommandLine = $CommandLine -replace '/servicejob|/sj'
            }
        }
    }

    If
    (
        $CommandLine
    )
    {
        $CommandLine = $($CommandLine).Trim()
		If
		(
			-Not $($CommandLine -match '\d|\w')
		)
		{
			$Commandline = $null
		}
    }
#endregion Command Line Parameters

#region Loading Function
    #region Update Module Path
        $BluGenieModulePath = $(Join-Path -Path $($env:BluGenieRoot) -ChildPath "Blubin\Modules\")
        $env:PSModulePath = $BluGenieModulePath + $([System.IO.Path]::PathSeparator) + $env:PSModulePath
    #endregion Update Module Path

	#region Load BluGenie Module
		If
		(
			$BGVerbose
		)
		{
			Import-Module BluGenie -Verbose -Force
		}
		Else
		{
			Import-Module BluGenie -Force
		}
	#endregion Load BluGenie Module
#endregion Loading Function

#region Global Variables
    $null = Write-VerboseMsg -ClearTimers
    If
	(
		-Not $BgHidefromHelp
	)
	{
		Write-VerboseMsg -Message 'Loading the BluGenie Cyber Security Framework...' -Color Yellow -Status StartTimer
	}
    Write-VerboseMsg -Message 'Setting Global Variables' -Status StartTask -Color Green -CheckFlag BGVerbose

    #region File and Directory Variables

        #region Script Base Name
            $ScriptBasename = $env:BluGenieScript
        #endregion Script Base Name

        #region Query File
            If
            (
                $host.name -notmatch 'ISE'
            )
            {
				Try
				{
					$ScriptFullName = $($env:BluGenieExec)
					If
					(
						$BGNoSetRes
					)
					{
						$Console = $false
					}
					Else
					{
						$Console = $true
					}
				}
				Catch
				{
					$error.Remove($error[0])
					$ScriptFullName = $($env:BluGenieExec)
					$Console = $false
				}
            }
            Else
            {
                $ScriptFullName = Get-Item -Path $($psISE.CurrentFile.FullPath) -ErrorAction SilentlyContinue
            }
        #endregion Query File

		Write-VerboseMsg -Message "Console: $Console" -Status StartTask -Color Green -CheckFlag BGVerbose

        #region TimeStamp
            [String]$CurDate = $('UID.{0}_{1}' -f $(New-BluGenieUID -NumPerSet 5 -NumOfSets 1),$(Get-Date -Format yyy.dd.MM_hh.mm.ss.tt))
        #endregion TimeStamp

        #region Build Global Variables from File Information
            If
            (
                $ScriptFullName
            )
            {
                #Pull the Scripts Parent directory information
                $ScriptDirectory = $($env:BluGenieRoot)

                #Set the Transcripts directory
                $TranscriptsDir = $('{0}\Transcripts' -f $ScriptDirectory)

                #Set the Transcript filename
                $TranscriptsFile = $('{0}\BluGenie_Transcript_{1}.log' -f $TranscriptsDir, $CurDate)

                New-Item -Path $TranscriptsDir -Type Directory -Force -ErrorAction SilentlyContinue | Out-Null
            }
        #endregion Build Global Variables from File Information
	#endregion File and Directory Variables

    #region Script Variables
        $ErrorActionPreference = "silentlycontinue"
        [String]$ToolsConfigFile = $('{0}\Blubin\Modules\Tools\Config.JSON' -f $ScriptDirectory)
        [String]$ToolsDirectory = $('{0}\Blubin\Modules\Tools' -f $ScriptDirectory)
        [System.Collections.ArrayList]$ConsoleSystems = @()
        [System.Collections.ArrayList]$ConsoleRange = @()
        [System.Collections.ArrayList]$ConsoleCommands = @()
        [String]$ConsoleJSONJob = ''
		[String]$ConsoleJobID = ''
        [Int]$ConsoleThreadCount = 50
        [System.Collections.ArrayList]$ConsoleParallelCommands = @()
        [System.Collections.ArrayList]$ConsolePostCommands = @()
        [Switch]$ConsoleTrap = $false
        [Int]$ConsoleJobTimeout = 120
		[System.String]$ConsoleDebug = $BGDebugger
        [String]$command = $null
    #endregion Script Variables

	#region JSON Import
		If
		(
			$BGJSONJob
		)
		{
			Publish-BluGenieArtifact -Artifact "$BGJSONJob" -Import
		}
	#endregion JSON Import

    #region Systems Import
        If
        (
            $BGSystems
        )
        {
            Set-BluGenieSystems -Add $BGSystems
        }
    #endregion Systems Import

	#region Error Tracker
		If
		(
			$ConsoleDebug -eq $true
		)
		{
			$ErrorTracker = @()
		}
	#endregion Error Tracker

	#region Debug Overlay
		If
		(
			$ConsoleDebug -eq $true
		)
		{
			Write-VerboseMsg -Message 'Debugging Enabled...' -Color Red -Status StartTask
			$("Debugging Enabled...`n") | Out-File -FilePath $TranscriptsFile -Append

			$TranscriptsFileDebug = $('{0}.debug.log' -f $($TranscriptsFile -replace '\.log$'))
			$null = Start-Transcript -Path "$TranscriptsFileDebug" -Force
		}
	#endregion Debug Overlay

    Write-VerboseMsg -Message 'Setting Global Variables' -Status StopTask -Color Cyan -CheckFlag BGVerbose
#endregion Global Variables

#region Version Information
    If
    (
        $TranscriptsFile
    )
    {
        $LibVersion = $(Get-Module | Where-Object -FilterScript { $_.Name -eq 'BluGenie' } | Select-Object -ExpandProperty Version).tostring()
        $('Lib Info: BGCon:{0}' -f $LibVersion) | Out-File -FilePath $TranscriptsFile -Append
    }

    If
    (
        $Console -and $($BGNoSetRes -eq $false)
    )
    {
		Write-VerboseMsg -Message 'Setting Console Size' -Status StartTask -Color Cyan -CheckFlag BGVerbose
		Write-VerboseMsg -Message "Set Res $BGNoSetRes" -Status StartTask -Color Cyan -CheckFlag BGVerbose

        Try
        {
            [Console]::Title = $('BGCon:{0}' -f $LibVersion)
            $pshost = get-host
            $pswindow = $pshost.ui.rawui
            $newsize = $pswindow.buffersize
            #$newsize.height = 3000
            $newsize.width = 150
            $pswindow.buffersize = $newsize
            $newsize = $pswindow.windowsize
            #$newsize.height = 50
            $newsize.width = 150
            $pswindow.windowsize = $newsize

            Write-VerboseMsg -Message 'Setting Console Size' -Status StopTask -Color Cyan -CheckFlag BGVerbose
        }
        Catch
        {
            If
            (
                $Error
            )
            {
                $Error.RemoveAt(0)
            }

            $BGNoSetRes = $true
        }
    }
#endregion Version Information

#region Shell Prompt
	$Script:ConsolePrompt = $('BluGenie.' + $LibVersion + ':')
function Prompt
{
    Write-Host $('BluGenie.' + $LibVersion + ':') -nonewline -foregroundcolor Cyan
    return " "
}
#endregion Shell Prompt

#region Set Default Location
    Set-Location -Path $ScriptDirectory -ErrorAction SilentlyContinue
#endregion Set Default Location

#region TransScript Header
    Write-VerboseMsg -Message 'Building TransScript Log' -Status StartTask -Color Green -CheckFlag BGVerbose
@(
"Console Version: $ScriptFileVersion
Start Time: $CurDate"
) | Out-File -FilePath $TranscriptsFile
    Write-VerboseMsg -Message 'Building TransScript Log' -Status StopTask -Color Cyan -CheckFlag BGVerbose
#endregion TransScript Header

#region Log System Paths
    Write-VerboseMsg -Message 'Logging Path Information' -Status StartTask -Color Green -CheckFlag BGVerbose

	$("`nBasename:`n{0}`n" -f $ScriptBasename) | Out-File -FilePath $TranscriptsFile -Append
    $("ScriptDirectory:`n{0}`n" -f $ScriptDirectory) | Out-File -FilePath $TranscriptsFile -Append
    $("TranscriptsDir:`n{0}`n" -f $TranscriptsDir) | Out-File -FilePath $TranscriptsFile -Append
    $("TranscriptsFile:`n{0}`n" -f $TranscriptsFile) | Out-File -FilePath $TranscriptsFile -Append

    Write-VerboseMsg -Message 'Logging Path Information' -Status StopTask -Color Cyan -CheckFlag BGVerbose
#endregion Log System Paths

#region Initialize Output
    If
    (
        $BGNoBanner -eq $false
    )
    {
        If
        (
            -Not $BgHidefromHelp
        )
        {
            Write-VerboseMsg -Message 'Loading the BluGenie Cyber Security Framework...' -Color Yellow -Status StopTimer
            Get-HostingVersion

$BlugenieArt = @'
                                          ..
                                         dP/$.
                                         $4$$%
                                       .ee$$ee.
                                    .eF3??????$C$r.        .d$$$$$$$$$$$e.
 .zeez$$$$$be..                    JP3F$5'$5K$?K?Je$.     d$$$FCLze.CC?$$$e
     """??$$$$$$$$ee..         .e$$$e$CC$???$$CC3e$$$$.  $$$/$$$$$$$$$.$$$$
            `"?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b $$"$$$$P?CCe$$$$$F
                 "?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b$$J?bd$$$$$$$$$F"
                     "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$d$$F"
                        "?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"...
                            "?$$$$$$$$$$$$$$$$$$$$$$$$$F "$$"$$$$b
                                "?$$$$$$$$$$$$$$$$$$F"     ?$$$$$F
                                     ""????????C"
                                     e$$$$$$$$$$$$.
                                   .$b CC$????$$F3eF
                                 4$bC/%$bdd$b@$Pd??Jbbr
                                   ""?$$$$eeee$$$$F?"

                                  WWW.BLUSAPPHIRE.NET

'@
            Write-Host $BlugenieArt -ForegroundColor Cyan
            Write-Host $("  Welcome to the BluGenie Cyber Security Framework...") -ForegroundColor yellow
            Write-Host $("`n  For a list of commands type <Get-BGHelp> and press <enter>") -ForegroundColor yellow
            Write-Host $("  For specific commands type <Get-BGHelp -Search <'Search_Term_w_RegEx'> and press <enter>`n") -ForegroundColor yellow
            Write-Host $("  Example --> ") -ForegroundColor yellow -NoNewline
            Write-Host $("Get-BGHelp -Search 'firewall|commands'`n") -ForegroundColor green
        }
    }
    Else
    {
        If
        (
            -Not $BgHidefromHelp
        )
        {
            Write-VerboseMsg -Message 'Loading the BluGenie Cyber Security Framework...' -Color Yellow -Status StopTimer
            Write-Host $("Welcome to the BluGenie Cyber Security Framework...") -ForegroundColor yellow
            Write-Host $("`nFor a list of commands type </help> and press <enter>`n") -ForegroundColor yellow
        }
    }
#endregion Initialize Output

#region CleanUp
    @(
        #'BGCore',
        'BlugenieArt',
        'LastResult'
    ) | ForEach-Object `
        -Process `
        {
            Try
            {
                Remove-Variable -Name $_ -Force -ErrorAction Stop
            }
            Catch
            {
                $Error.RemoveAt(0)
            }
        }
#endregion CleanUp

#region Console
	$("`nCommandLine: " + $CommandLine) | Out-File -FilePath $TranscriptsFile -Append
	$("CommandLine Length: " + $($CommandLine.Length | Out-String)) | Out-File -FilePath $TranscriptsFile -Append
	$("Parameters`n: {0}" -f $($Parameters | Out-String)) | Out-File -FilePath $TranscriptsFile -Append
	$("Parameters Length: {0}`n" -f $($Parameters.Length | Out-String)) | Out-File -FilePath $TranscriptsFile -Append

    If
    (
        $Error
    )
    {
        $ErrorTracker += Get-ErrorAction -Clear
    }

function Console
{
        #region CommandLine has Data (Run automatically with no Console set)
            If
            (
                $($CommandLine.length -gt 0)
            )
            {
                if
                (
                    $CommandLine -eq 'cls'
                )
                {
                    "Action: $CommandLine" | Out-File -FilePath $TranscriptsFile -Append
                    If
                    (
                        $host.name -notmatch 'ISE'
                    )
                    {
                        Invoke-Expression -Command 'cmd.exe /c cls' -ErrorAction SilentlyContinue
                    }
                    else
                    {
                        Clear-Host
                    }
                    $("Complete Time: " + $(Get-Date -Format yyy.dd.MM_hh.mm.tt)) | Out-File -FilePath $TranscriptsFile -Append
                }
                elseif
                (
                    $CommandLine -match '^/help'
                )
                {
                    "Action: $CommandLine" | Out-File -FilePath $TranscriptsFile -Append
                    if
                    (
                        $CommandLine -match '^/help:'
                    )
                    {
                        Get-BGHelp -Search $($CommandLine -replace '^.*?:')
                        $("Complete Time: " + $(Get-Date -Format yyy.dd.MM_hh.mm.tt)) | Out-File -FilePath $TranscriptsFile -Append
                    }
                    Else
                    {
                        Get-BGHelp
                        $("Complete Time: " + $(Get-Date -Format yyy.dd.MM_hh.mm.tt)) | Out-File -FilePath $TranscriptsFile -Append
                    }
                }
                else
                {
                    $runcommand = [scriptblock]::Create($($CommandLine.TrimStart('-')))
                    "Action: $CommandLine" | Out-File -FilePath $TranscriptsFile -Append
                    $LastResult = Invoke-Command -ScriptBlock $runcommand
                    If
                    (
                        $ConsoleDebug -eq $true
                    )
                    {
                        #$($LastResult | Format-Custom  | Out-String) -replace '}\s\s','},' -replace '\sclass\s.*\s' | Out-File -FilePath $TranscriptsFile -Append
                        $LastResult | ConvertTo-Json -Depth 10 | Out-File -FilePath $TranscriptsFile -Append
                        $ErrorTracker += Get-ErrorAction -Clear
                    }
                    $("Complete Time: " + $(Get-Date -Format yyy.dd.MM_hh.mm.tt)) | Out-File -FilePath $TranscriptsFile -Append
                }

                If
                (
                    -Not $BGNoExit
                )
                {
                    [Environment]::Exit(0)
                }
            }
        #endregion CommandLine has Data (Run automatically with no Console set)
}
#endregion Console

#region Set CPU Affinity
    If
    (
        $BGCores
    )
    {
        $SetAffinityInfo = Set-ProcessCPUAffinity -Id $PID -Core $BGCores -ReturnObject | Select-Object -ExpandProperty ProcessorAffinity

        $SetAffinityReturn = @"
[Process Affinity Set]
Process ID = $PID
Set to CPU = $SetAffinityInfo

"@

        $SetAffinityReturn | Out-File -FilePath $TranscriptsFile -Append
    }
#endregion Set CPU Affinity

#region Set CPU Priority
    If
    (
        $BGPriority
    )
    {
        $SetPriorityInfo = Set-ProcessPriority -id $PID -PriorityLevel $BGPriority -ReturnObject
        $SetPriorityReturn = @"
[Process Priority]
Name           = $($SetPriorityInfo | Select-Object -ExpandProperty Name)
ID             = $($SetPriorityInfo | Select-Object -ExpandProperty Id)
BasePriority   = $($SetPriorityInfo | Select-Object -ExpandProperty BasePriority)
StringPriority = $($SetPriorityInfo | Select-Object -ExpandProperty StringPriority)
"@

        $SetPriorityReturn | Out-File -FilePath $TranscriptsFile -Append
    }
#endregion Set CPU Priority

#region Set Memory Cap
    If
    (
        $BGMemory
    )
    {

        $SetMemoryReturn = @"

[Active Memory Limit]
MemoryMB = $BGMemory
MemoryKB = $MaxmemoryMB

"@

        $SetMemoryReturn | Out-File -FilePath $TranscriptsFile -Append
    }
#endregion Set Memory Cap

#region Start Core Engine
    $env:BgWinPid = $PID
    $env:BgWinHandle = Get-Process -Id $PID | Select-Object -ExpandProperty MainWindowHandle
    Console
#endregion Start Core Engine