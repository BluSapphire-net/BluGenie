<#
.NOTES

    * Build Version Details:
        * 20.11.1301:
            o [Michael Arroyo] - [psd1] - Moved the Module Help information to this script.  This will no longer be captured in the BluGenie.ps1
			o [Michael Arroyo] - [Core Module] - Added a GUI to BluGenie.  To start the GUI, type one of the following commands
				~ Show-BluGenieGUI
				~ Show-GUI
				~ GUI
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Updated the search function for older systems from /a-o-l to /a-l based on older
				systems not having the parameter /a-o
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Added a Recursive method to detect Junction points.  This stops endless loops when
				detecting Junctions Point.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Updated function to the newest Function Template (20.05.2201)
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Consolidation of over 500 lines of code.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Update to the Permissions method.  Permissions were not grabbing the array of
				permission, which is now being captured.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Updated the FilterType list to 'Path','PathIncludeAll','Name','NameIncludeAll',
				'Type','TypeIncludeAll','Hash','HashIncludeAll','ADS','ADSIncludeAll'
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Added a new search Algorithm to each FilterTyper
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Updated the Permissions method to remove extra spaces at the end of the strings.
				This was causing the return to be on multiple lines.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Updated the ShowStreamContent method to remove extra spaces at the end of the strings.
				This was causing the return to be on multiple lines.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Set the variable SearchPath default value to the scripts current running location.
			o [Michael Arroyo] - [Get-BluGenieSystemInfo] - Removed [Tab]s' from the help section and replaced them with spaces.
			o [Michael Arroyo] - [Get-BluGenieTrapData] - 	Get-BluGenieTrapData will report back any captured BluGenie trap logs.  Functions as
				follows
				* List - Display a list of all the Blugenie Logs captured on the remote machine
				* Path - Specific a path to query for Blugenie Logs (By default this is %SystemDrive%\Windows\Temp)
				* FileName - Specifically select which file you want to report on (By default the last file created is picked).  The file name
					can be picked using RegEx.
				* JobID - Specify which file you want to remote on using the Job ID (Be default this is the last log created with the Job ID
					specified.  You can have more then one log with the same Job ID)
				* Remove - Remove a Specific log file
				* RemoveAll - Remove BluGenie log files including the Debugging Log files
				* Overwrite - Return the current JSON Job data to look just like the Trapped Log data for easier reporting and parsing
			o [Michael Arroyo] - [Get-BluGenieSettings] - Updated the Console Debug variable to capture the information correctly.
			o [Michael Arroyo] - [Edit-BluGenieJSON] - Updated the BGNoSetRes process to also disable the Console updates if enabled.
			o [Michael Arroyo] - [Get-BluGenieCurrentSessionAliases] - Get-BluGenieCurrentSessionAliases will display the current PowerShell
				sessions alias list
			o [Michael Arroyo] - [Get-BluGenieRunSpaceSessionAliases] - Get-BluGenieRunSpaceSessionAliases will display, the default PowerShell
				sessions Alias list
			o [Michael Arroyo] - [Get-BluGenieSessionAliasList] - Get-BluGenieSessionAliasList will display, remove, and export all user defined
				Aliases for the current PowerShell session
			o [Michael Arroyo] - [Invoke-BluGenieProcess] - Updated the detection method for BGDebugger
			o [Michael Arroyo] -  [Invoke-BluGenieWalkThrough] - Removed the Alias [Invoke-WalkThrough] and copied this script over to a Function
				Script called [Invoke-Walkthrough].  Other scripts are looking for a function named [Invoke-Walkthrough], not an Alias.
			o [Michael Arroyo] - [Invoke-BluGenieWalkThrough] - Removed the Alias [Invoke-WalkThrough] and copied this script over to a Function
				Script called [Invoke-Walkthrough].  Other scripts are looking for a function named [Invoke-Walkthrough], not an Alias.
			o [Michael Arroyo] - [Set-BluGenieDebugger] - Updated the detection method for BGDebugger
			o [Michael Arroyo] - [Show-BluGenieGUI] - This is the new function to Enable the Graphical Interface
			o [Michael Arroyo] - [Start-BluGenieRunSpace] - Added Alias injection into the new Runspace.  This will fix any issues while calling
				the old Blugenie commands as well as providing a clone of the parent PowerShell Env.
        * 20.11.1601:
            o [Michael Arroyo] - [BluGenie Exe] Captured the first launch PID into a new Environment variable BgPid
			o [Michael Arroyo] - [BluGenie Exe] Updated the Library version to pull the version number of the BluGenie Framework instead of the
				BluGenie.exe.
			o [Michael Arroyo] - [BluGenie Exe] Captured the PID for the Controlling Windows Frame of BluGenie into a new Environment variable
				BgWinPid
			o [Michael Arroyo] - [BluGenie Exe] Captured the Windows Framework Handle into a new Environment variable BgWinHandle
			o [Michael Arroyo] - [Folder Structure] Added .\Blubin\Help > to house all the new MarkDown help files
			o [Michael Arroyo] - [MarkDown Help] Created Markdown help (Get-BluGenieSystemInfo.md) for function Get-BluGenieSystemInfo
			o [Michael Arroyo] - [Module Update] Added support for the AutoItX (AutoIt) Module
			o [Michael Arroyo] - [GUI] The Graphical interface can now be detached (ran as a separate process from the BluGenie Console) using the
				command (Show-BluGenieGUI -Detach)
			o [Michael Arroyo] - [GUI] Added the PID and Handle information for all BluGenie processes in the Administration > Console tab
			o [Michael Arroyo] - [GUI] While using the -Detach parameter when running the GUI if you send commands to the Console it will now send
				those commands directly to the BluGenie Console.
			o [Michael Arroyo] - [GUI] Fixed the hidden errors on load issue
			o [Michael Arroyo] - [GUI] Fixed error trapping (Use -Detach) for better error control. Note:  This is with or without (Send Console
				commands to the BluGenie Console) being checked in the Administration\Console Tab
			o [Michael Arroyo] - [GUI] Update the returning data to have a cleaner format
			o [Michael Arroyo] - [GUI] Updated the Console > Clear Error's button to run command Error.Clear() either in the current GUI session
				or to send that command to the BluGenie Console.
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Added FullName property value back for Elastic Search specific searches
			o [Michael Arroyo] - [Get-BluGeniChildItemList] Renamed the { Found } key value back to FoundItems for Elastic Search specific
				searches
			o [Michael Arroyo] - [Invoke-WalkThrough] Updated the function name in the script from Invoke-BluGenieWalkThrough to
				Invoke-WalkThrough for older function support
			o [Michael Arroyo] - [Set-BluGenieSessionInfo] Added a new Function called ( Set-BluGenieSessionInfo ) that will set a Current Session
				Environment variable to be passed to each new PSSession Runspace automatically
			o [Michael Arroyo] - [New-BluGenieSessionInfo] Added a new Function called ( New-BluGenieSessionInfo ) that will query a Current
				Session Environment variable and build Posh variables back into new PSSession Runspaces
			o [Michael Arroyo] - [Show-BluGenieGUI] Added the Detach parameter.  This param will run the GUI as a separate process allowing to
				still interact with the BluGenie Console.
			o [Michael Arroyo] - [BluGenie.psm1] Removed the Invoke-WalkThrough alias.  As it was converted back to a separate function for
				older commands calls
			o [Michael Arroyo] - [BluGenie.psm1] Added Alias Set-SessionInfo
			o [Michael Arroyo] - [BluGenie.psm1] Added Alias New-SessionInfo
		* 20.11.2302:
			o [Michael Arroyo] - [BluGenie.exe (Core)] Removed the dependency scanner to load all dependency modules on launch.  This happens in
				the Module itself now
			o [Michael Arroyo] - [BluGenie.exe (Core)] Removed the Allowed Commands section.  This code is no longer needed.  BG now runs all
				Posh commands
			o [Michael Arroyo] - [BluGenie.exe (Core)] Lib information is now posted in BG as the Module version and not the Compiled EXE version
			o [Michael Arroyo] - [BluGenie Module] Module directory consists of Core Commands and Dependency Commands. This helps with running
				the module without BluGenie.exe
			o [Michael Arroyo] - [BluGenie Module] Loaded Modules, Variables, and Functions are now tracked in a variable called BluGenieInfo
			o [Michael Arroyo] - [BluGenie Module] Added a process to dynamically Export Aliases from the Module to the Current PS Session
			o [Michael Arroyo] - [BluGenie Module] Added support module dependencies for all versions of Posh.
				2.0, 3.0, 4.0, 5.0, 5.1, 6.0, 6.2, 7.0, 7.1
			o [Michael Arroyo] - [BluGenie Module] 3rd Party Modules added
				* AutoItX - For GUI Control and Windows Automation
				* PSnmap - NMap for Posh (Added but no BluGenie defined functions added
				* PSSQLite - Added and Tested but no BluGenie defined functions added
				* powershell-yaml - Used for file caching / and much cleaner output
			o [Michael Arroyo] - [BluGenie Module] New function added (Get-BluGenieFileADS).  Query for a files Alternate Data Stream Names.
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Get-BluGenieFilePermissions).  Query file(s) for NTFS Permissions.
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Get-BluGenieFileStreams).  Query file(s) for NTFS ADS Content
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Invoke-BluGenieThreadLock).  Create a named Mutex
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Remove-BluGenieFile).  Remove file
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Test-BluGenieIsFileLocked).  Test to see if a file locked by another
				process
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Test-BluGenieIsMutexAvailable).  Wait, up to a timeout value, to check if
				current thread is able to acquire an exclusive lock on a system mutex.
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Clear-BlugenieMemory).  Garbage Collection in PowerShell to Speed up
				Scripts and help lower memory consumption
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [BluGenie Module] New function added (Convert-BluGenieSize).  Convert a value from Bytes, KB, MB, GB, TB to
				[TB/GB/MB/KB/Bytes]
				Note:  This function used the new template which uses the new parameters (UseCache, RemoveCache, CachePath,
				ClearGarbageCollecting, OutYaml, and FormatView)
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Fixed ParameterSetResults, which now shows a valid output instead of a PowerShell
				Object reference
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added new parameters (UseCache, RemoveCache, CachePath, ClearGarbageCollecting,
				OutYaml, and FormatView)
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Updated Help and Example Information to details the new parameters
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support for (Clean-BluGenieMemory).  This will clean up any garbage collecting
				done by PowerShell
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support to save found artifacts to disk instead of memory using the -UseCache
				parameter
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support to change the Cache Path.  The default path is %WinDir%\Temp.
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support to remove cached data using the -RemoveCache parameter.  By default
				this is disabled.
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support to Output the detailed return data to Yaml
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added support to FormatView to change the Objects returned while using -Returnobject
				to a Yaml format
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added CachePath information to the Detailed report
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added a Dynamic parameter update process to change set parameters if a version of
				Posh 2 is installed.  Currently Caching is not supported in Posh2.
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Updated the Sub function (Recurse) to a valid (Verb-Noun) function name called
				Start-Recurse
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Added a Remove property to the Return data Object / Information
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (Permission Info) to an External function called
				Get-BluGenieFilePermissions
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (ADS Info) to an External function called Get-BluGenieFileADS
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (Stream Info) to an External function called
				Get-BluGenieFileStreams
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (Remove File) to an External function called
				Remove-BluGenieFile
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (Permission) to an External function called
				Get-BluGenieFilePermissions
			o [Michael Arroyo] - [Get-BluGenieChildItemList] Moved the Sub Process (Permission) to an External function called
				Get-BluGenieFilePermissions
			o [Michael Arroyo] - [Get-BluGenieHashInfo] Changed the validation set for Algorithm from using (Double Quotes) to (Single Quotes)
			o [Michael Arroyo] - [Get-BluGenieHashInfo] Updated the ParameterSetResutls Hash table to have the value defined as an Array before
				the value is posted
			o [Michael Arroyo] - [Get-BluGenieHashInfo] Updated the Get-LiteralPath command to Get-BluGenieLiteralPath
			o [Michael Arroyo] - [Get-BluGenieHashInfo] Added a check to see if the file is locked prior to Generating the Hash value.  Added a
				Return if the file is locked instead of returning nothing like prior versions.
			o [Michael Arroyo] - [Get-BluGenieLockingProcess] Changed the validation set for Algorithm from using (Double Quotes) to
				(Single Quotes)
			o [Michael Arroyo] - [Get-BluGenieLockingProcess] Added the FormatView parameter including the new FormatView Output process
			o [Michael Arroyo] - [Get-BluGenieLockingProcess] Added the current local path to the Tool Search path process to find Handle.exe in
				the current path
			o [Michael Arroyo] - [Get-BluGenieLockingProcess] Updated the Get-Item call to the .NET call [System.IO.File] to better manage the
				file information process
			o [Michael Arroyo] - [Get-BluGenieSignature] Changed the validation set for Algorithm from using (Double Quotes) to (Single Quotes)
        * 20.12.1401:
			o [Michael Arroyo] - [BluGenie Module] Added a new function ( Invoke-BGYara ).  Invoke-BluGenieYara is a wrapper around the YARA tool.
				The Yara tools is designed to help malware researchers identify and classify malware samples. It’s been called
				the pattern-matching Swiss Army knife for security researchers (and everyone else).
		* 20.12.1402:
			o [Michael Arroyo] - [BluGenie Module]	Set new Alias in the Module for
				* Name 'Get-BGServiceStatus' Value 'Get-BluGenieServiceStatus'
				* Name 'New-BGService' Value 'New-BluGenieService'
				* Name 'Remove-BGService' Value 'Remove-BluGenieService'
				* Name 'Stop-BGService' Value 'Stop-BluGenieService'
			o [Michael Arroyo] - [BluGenie Core Exe]  Build Version Details "Moved from main help.
					There is a Char limit and PSHelp could not read all the information correctly":
				* Added support for ServiceJob
				* Added CLI Parameter for ServiceJob
				* Added new variable BGServiceJobFile which captures all of the BluGenie Settings and saves it as a
					Job file for the BluGenie Service to use on the remote system
				* Updated the LocalIP call on the remote system to action with WMI.  The new process looks for IP V4 Addresses
					that have a valid GateWay assigned as well.  This helps resolve the 169 address lookup.
				* JSONReturn has been cleaned up.  No difference to Output.
				* Updated the /Debug action to Output debugging information on the remote machine.
					* All Arguments sent to the machine are capture to a single log file called %SystemDrive%\Windows\Temp\BluGenieArgs.txt
					* All Tools Configuration sent to the machine are capture to a single log file called
						%SystemDrive%\Windows\Temp\BluGenieToolsConfig.txt
				* Process BG Settings as a Service Job if the setting is set to True.  The option can be set with the Console or the CLI
					If the machine is Not PowerShell 3 or above and the Service is not running, the normal query job will take place.
			o [Michael Arroyo] - [Get-BluGenieServiceStatus]	Report on the Status of the BluGenie Windows Service
				Report includes
				* Jobs that are currently waiting to run
				* Processing Jobs
				* Completed Jobs
				* Completed JSON reports
				* Service State
				* Service CPU Resources
				* Service Memory Resources
				* BluGenie Service Event Viewer Logs
			o [Michael Arroyo] - [Get-BluGenieSettings]	Added support for the ( ServiceJob ) parameter
			o [Michael Arroyo] - [New-BluGenieService]	Create a New Windows Service called BluGenie
				Service binary resides in the Module Directory

				Once started 3 directories will be created.
					~ .\Logs
					~ .\Jobs
					~ .\Processing

				Log Information
					~ All verbose logging is captured to the Windows Event Log under the Application Log.
					~ The source is named ( BGService )

				Polling Period and Performance
					~ Polling period is set to 60 seconds.  A scan for a BluGenie JSON Job file will be queried in the
					.\Jobs directory.  Once found the actions are processed
			o [Michael Arroyo] - [Remove-BluGenieService]	Remove the Windows Service called BluGenie
			o [Michael Arroyo] - [Stop-BluGenieService]	Stop the Windows Service called BluGenie
				This is not a permenant stop.  This is until the next restart.  If you want to stop the service even after
				a system restart you should remove the BGServcie with Remove-BGService.
			o [Michael Arroyo] - [Edit-BluGenieJSON]	Added support for the ( ServiceJob ) parameter
			o [Michael Arroyo] - [Invoke-BluGenieProcess]	Added support for the ( ServiceJob ) parameter
			o [Michael Arroyo] - [Invoke-BluGenieWipe]	Added support for the ( ServiceJob ) parameter
			o [Michael Arroyo] - [Invoke-BluGenieYara]	Updated the JSON call to no longer use ConvertTo-BluGenieJson and to use the normal
				ConvertTo-Json
		* 21.02.2201:
			* [BluGenie.psd1]
				o [Michael Arroyo] Updated the Code to the '145' column width standard
                o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
			* [PSScriptAnalyzerSettings.psd1]
				o [Michael Arroyo] Fixed ExcludeRules item 'PSAlignAssignmentStatement'
				o [Michael Arroyo] Fixed ExcludeRules item 'PSPossibleIncorrectComparisonWithNull',
				o [Michael Arroyo] Added ExcludeRules item 'PSUseApprovedVerbs'
			* [Get-BluGenieAuditProcessTracking]
				o [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
				o [Michael Arroyo] Updated the Hash Information to follow the new function standards
				o [Michael Arroyo] Updated the function to the new function tempatle
				o [Michael Arroyo] Added more detailed information to the Return data
				o [Michael Arroyo] Updated the Code to the '145' column width standard
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				o [Michael Arroyo] Moved Build Notes out of General Posh Help section
				o [Michael Arroyo] Added support for Caching
				o [Michael Arroyo] Added support for Clearing Garbage collecting
				o [Michael Arroyo] Added support for SQLite DB
				o [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
									unless you manually set the -Verbose parameter.
				o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
			* [Get-BluGenieChildItemList]
				o [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                o [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
			* [Get-BluGenieFirewallRules]
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                o [Michael Arroyo] Moved Build Notes out of General Posh Help section
                o [Ravi Vinod Dubey] Added support for Caching
                o [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
                o [Ravi Vinod Dubey] Added support for SQLite DB
                o [Ravi Vinod Dubey] Updated Process Query and Filtering
                o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
                o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
			* [Get-BluGenieProcessList]
				o [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                o [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
			* [Get-BluGenieRegistryProcessTracking]
				o [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
				o [Michael Arroyo] Updated the Hash Information to follow the new function standards
				o [Michael Arroyo] Updated the function to the new function tempatle
				o [Michael Arroyo] Added more detailed information to the Return data
				o [Michael Arroyo] Updated the Code to the '145' column width standard
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				o [Michael Arroyo] Moved Build Notes out of General Posh Help section
				o [Michael Arroyo] Added support for Caching
				o [Michael Arroyo] Added support for Clearing Garbage collecting
				o [Michael Arroyo] Added supoort for SQLite DB
				o [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
				o [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
				o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
				o [Michael Arroyo] Updated the PrefetchService name now called (SysMain) on Windows 10 Build 1809 and later.
				o [Michael Arroyo] Updated the registry call to grab (EnablePrefetcher) on some newer Windows Builds to detminer the
					Prefect statues
				o [Michael Arroyo] Rebuilt Object reference to support Caching and DB injection
			* [Get-BluGenieSchTaskInfo]
				o [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
				o [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
			* [Get-BluGenieServiceList]
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
				o [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
				o [Michael Arroyo] Updated the Dependencies section in the Help region with the correct syntax
			* [Get-BluGenieSystemInfo]
				o [Michael Arroyo] Fixed bug with -NewDBTable not dropping the original DB and creating a new one.
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
				o [Michael Arroyo] Fixed the -RemoveCache switch so now the Cache file gets removed if selected.
			* [Get-BluGenieWindowsUpdates]
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				o [Michael Arroyo] Moved Build Notes out of General Posh Help section
				o [Michael Arroyo] Added support for Caching
				o [Michael Arroyo] Added support for Clearing Garbage collecting
				o [Michael Arroyo] Added supoort for SQLite DB
				o [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
				o [Michael Arroyo] Added supprt for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
                o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
		* 21.03.0401:
			* [Invoke-BluGenieYara]
				o [Michael Arroyo] Updated the function to the new function template
                o [Michael Arroyo] Added more detailed information to the Return data
                o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                o [Michael Arroyo] Moved Build Notes out of General Posh Help section
                o [Michael Arroyo] Added support for Caching
                o [Michael Arroyo] Added support for Clearing Garbage collecting
                o [Michael Arroyo] Added support for SQLite DB
                o [Michael Arroyo] Updated Service Query and Filtering (10x faster when processing)
                o [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
                                    unless you manually set the -Verbose parameter.
                o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
                o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
                o [Michael Arroyo] Tools path updated with \Tools\Yara\
                o [Michael Arroyo] Updated the CommandlineOptions switch process to pull from the parameters directly instead of the
                    PSBoundParameters. This is cleaner and also allows you to test in real time.  The old way using PSBoundParameters
                    is only valid at runtime or debug mode.
		* 21.03.0801:
			* [BluGenie.psm1]
				o [Michael Arroyo] Moved Directory Blubin to the Root of the BluGenie.exe directory
				o [Michael Arroyo] Moved Directory Tools to the .\Blubin directory (Tools are now copied as files and not via code)
					Root of the .\Blubin looks like the below.
						- BGService
						- BluGenie
						- Tools
							- FirewallRules
							- GUI
							- Help
							- SysMon
							- WinLogBeat
							- Yara
				o [Michael Arroyo] 'ScriptDirectory' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you
					to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'TranscriptsDir' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'TranscriptsFile' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you
					to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ToolsConfigFile' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you
					to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ToolsDirectory' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleSystems' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleRange' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleCommands' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you
					to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleJSONJob' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleJobID' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleThreadCount' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows
					you to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleParallelCommands' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now
					allows you to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsolePostCommands' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows
					you to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleTrap' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleJobTimeout' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you
					to just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'ConsoleDebug' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'command' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to just
					install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGVerbose' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to just
					install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BgHidefromHelp' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGConsole' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to just
					install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGDebugger' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGJSONJob' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGNoSetRes' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGNoExit' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to just
					install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGNoBanner' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGRemoveMods' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGUpdateMods' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGServiceJob' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to
					just install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] 'BGMemory' is now managed by the BluGenie Module, if BluGenie.exe is not running.  This now allows you to just
					install the BluGenie module without using the EXE if you don't want to
				o [Michael Arroyo] Moved the Transcript Start Logging to variable $BluGenieInfo.ScriptSettings.Log.  This change was necessary
					because of how the Module is now ran as an external or secondary process
				o [Michael Arroyo] Moved Global Module Variables and Project Information from the core exe to the .psm1
				o [Michael Arroyo] Set up a dynamic method to detect the module running in the ISE/Console and BluGenie’s Console
				o [Michael Arroyo] Set up a new method to edit and update the ToolsConfig properties in both the Module and the BG Exe.
				o [Michael Arroyo] SysInternal Tools, SysMon, WinLogBeat, etc are now detected from the .\Blubin\Tools directory from inside the
					module
				o [Michael Arroyo] Removed $BGRemoveMods variable.  This is now managed by a new function
				o [Michael Arroyo] Moved the entire Remote Script Block execution into the Module.  This is no longer being managed by the
					BluGenie.exe.  This now gives you full access to run even remote deployments and jobs via the ISE or the normal PowerShell
					Console.
				o [Michael Arroyo] Added new Alias Remove-BGModule for Remove-BluGenieModule
				o [Michael Arroyo] Added the missing region footer to the (Update Function List with 3rd party Module Functions) region
				o [Michael Arroyo] Removed the Remote Script Block (Remove Mods) section of code.
			* [BluGenie.psd1]
				o [Michael Arroyo] Updated the Build reference
				o [Michael Arroyo] Cleaned up the Build Notes to fit to the 145 column line limit
			* [Config.JSON]
				o [Michael Arroyo] Removed Drop Bucket Configuration.  There are 2 Static directories (Completed / InProgress)
				o [Michael Arroyo] Added a new section called SysinternalsSuite.  This is to manage what SysInternal Tools you want to keep once
					the Tools have been downloaded from Microsoft.
				o [Michael Arroyo] Added a new section called ExcludedCopyFiles.  This is to manage what files under .\BluBin get copied to the
					remote system.  This section is also managed using RegEx.
			* [BluGenie Core]
				o [Michael Arroyo] Tools directory moved from the Root of BluGenie.exe to .\BluBin\Modules\Tools.  This is to extent the support
					of copying files to a remote system
						1) By copying files 1 by 1 so if a file or directory is locked on the remote side it will not stop other files or
							directories from getting copied.
						2) Allow Tools to be used and copied while using just the Module and not just the BluGenie.exe
			* [Get-BluGenieSettings]
				o [Michael Arroyo] Removed the flag for RemoveMods
			* [Send-BluGenieItem]
				o [Michael Arroyo] Modified the Build Notes to the new standard
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				o [Michael Arroyo] Updated the WalkThrough Function to the latest version
				o [Michael Arroyo] Updated parameter Source to allow multiple sources to be copied to a single system at once without
					using a Directory or Container as the parent copy item
				o [Michael Arroyo] Added a new parameter called RelativePath.  This string will help remove the current source path and
					replace it with the new Destination path while keeping the entire directory tree intact.
				o [Michael Arroyo] Updated all the parameters to no longer have a position parameter path.  This is no longer needed.
					Meaning the Parameters had to be in a specific order if no named parameter was set.
				o [Michael Arroyo] Added Clean Garbage to the overall process to help clean up memory after the function runs.
				o [Michael Arroyo] Added Parameter OutYaml to return a Yaml specific output
				o [Michael Arroyo] Added Parameter FormatView to give a bigger selection of output formats
				o [Michael Arroyo] Added a new HashReturn property called Command.  This property will show each command line ran to copy a
					file to the remote machine.
				o [Michael Arroyo] Added a new HashReturn property called Process.  This property will show which file(s) have been copied to
					the remote machine
				o [Michael Arroyo] Added the Standard Functions Dynamic parameter update region
				o [Michael Arroyo] Updated the core process to run a ForEach on the Source list.  If copying to or from a session the computer
					name will have a remote connection established only once and all files and or folders will be copied as needed without
					creating new sessions per file like before.
			* [Update-BluGenieSysinternals]
				o [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
				o [Michael Arroyo] Moved Build Notes out of General Posh Help section
				o [Michael Arroyo] Updated Tools path to (Blubin\Modules\Tools)
				o [Michael Arroyo] Updated the Walkthrough / Help region with the current Help process
				o [Michael Arroyo] Updated $Destination to $Global:ToolsDirectory.  This changes now works with Importing the Module
					itself and not running the BluGenie.exe if you don’t want to
				o [Michael Arroyo] Updated $BaseDir to $Global:ToolsDirectory.  This changes now works with Importing the Module itself and not
					running the BluGenie.exe if you don’t want to
				o [Michael Arroyo] Added Parameter called NoCleanUp.  This will leave all the SysInternal Tools that are downloaded and extracted.
					If this flag isn’t set, only the items in the Config.JSON are kept and saved.  All other files will be removed to save space.
			* [Edit-BluGenieJSON]
				o [Michael Arroyo] Removed all references for the flag RemoveMods
			* [Remove-BluGenieModule]
				o [Michael Arroyo] New function to replace the RemoveMods flag in the JSON file.  This is now an external function that can also
					return what files have been removed or failed to remove.
				o [Michael Arroyo] This new function will detect and track if the BluGenie Service was running.  If it was running the Service
					will be Stopped with a wait time of 2 min, and then the Service will be removed.
		* 21.03.2901:
			• [BluGenie Core]
				o [Michael Arroyo] Added support for Config.JSON to also run as Config.YAML
				o [Michael Arroyo] Made Config.YAML the default configuration type
				o [Michael Arroyo] Added Module (Hawk -> Powershell Based tool for gathering information related to O365 intrusions and
					potential Breaches)
				o [Michael Arroyo] Added Azure and Office 365 External Modules
					- AzureAD
					- MSOnline
					- PSAppInsights
					- CloudConnect
					- PSFramework
					- RobustCloudCommand
			• [BluGenie.psd1]
				o [Michael Arroyo] Updated the Build Version
			• [BluGenie.psm1]
				o [Michael Arroyo] Added a detection method to look for either Config.JSON or Config.YAML file.
				o [Michael Arroyo] Moved the Load Config region to action after the External Module injection region is run.
					This is to support YAML as a primary configuration engine.  But will also provide more functionality in the future.
				o [Michael Arroyo] Moved the WSMan Configuration region to action after the External Module injection region is run.
				o [Michael Arroyo] Moved the Copy Downloaded Tools region to action after the External Module injection region is run.
				o [Michael Arroyo] Moved the Detect Needed Project Files region to action after the External Module injection region is run.
				o [Michael Arroyo] Added an If Block to determine if the ToolsConfig exists and if it doesn't not no longer process the following
					regions as they are only needed for the Host.
						- Load Config region
						- WSMan Configuration region
						- Copy Downloaded Tools region
						- Detect Needed Project Files region
				o [Michael Arroyo] Added a Remove-Module process for the 3rd pary modules to make sure the BluGenie 3rd party modules always get
					loaded without conflicts
		* 21.04.0701:
			•	[BluGenie Core]
				o	[Michael Arroyo] The JSONPacks directory has been renamed to JobPacks
				o	[Michael Arroyo] YAML is now supported for both Job Pack Files and the Core configuration.
				o	[Michael Arroyo] HelpMnu.dat has been updated with changes made to this build
			•	[BluGenie.ps1]
				o	[Michael Arroyo] Updated the Loading screen to show how to run the new Help process
				o	[Michael Arroyo] Removed the Help Flag BgHidefromHelp.  This is now managed by the CLI Process
				o	[Michael Arroyo] Updated the CLI Help screen to show a cleaner overview of how to run BluGenie.exe
				o	[Michael Arroyo] Updated all the CLI commands to run as abbreviations as well as the full command names
			•	[BluGenie.psd1]
				o	[Michael Arroyo] Updated Version information
				o	[Michael Arroyo] Updated Build notes
			•	[BluGenie.psm1]
				o	[Michael Arroyo] Updated the Create Hash footer to match the header
				o	[Michael Arroyo] Update the (Update Module Path) region to look for BluGenie\\Modules instead of just BluGenie.  If the user account had the name BluGenie in it, the search for the BluGenie module would fail to select the correct module directory.
				o	[Michael Arroyo] Renamed the BluGenieArg.txt debug log on the remote system to BluGenieDebug.txt which is captured in %SystemRoot%\Windows\Temp if Debug is set to True.
				o	[Michael Arroyo] Added a capture of all the BluGenie Arguments, BluGenie Settings Variables, and Run Time System Variables to the BluGenieDebug.txt.  This helps in the overall troubleshooting of the BluGenie process.  You can now see what variables BluGenie is using at Run Time on the remote system.
			•	 [Get-BluGenieSettings.ps1]
				o	[Michael Arroyo] Updated the Output Type to support YAML, JSON, and OutUnescapedJSON.  The default return is now YAML.  Note:  This is only noticed in the Console view when using the Settings, Get-BGSettings, or Get-BluGenieSettings command.
				o	[Michael Arroyo] Updated script based on (PSScriptAnalyzerSettings.psd1) linter configuration
				o	[Michael Arroyo] Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly"
			•	[Edit-BluGenieJSON.ps1]
				o	[Michael Arroyo] Updated script based on (PSScriptAnalyzerSettings.psd1) linter configuration
				o	[Michael Arroyo] Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly"
				o	[Michael Arroyo] Added support for Importing, Editing, Reviewing, and Exporting YAML job files.
				o	[Michael Arroyo] Added Parameter ExportType to determine which type to use for export.  Note: The default is YAML
				o	[Michael Arroyo] Updated Help and Example information based on the new changes
				o	[Michael Arroyo] Added Alias Edit-BGJSON
				o	[Michael Arroyo] Added Alias Edit-BGYAML
				o	[Michael Arroyo] Added Alias Edit-JSON
				o	[Michael Arroyo] Added Alias Edit-YAML
				o	[Michael Arroyo] Added Alias YAML
				o	[Michael Arroyo] Added Alias Edit-BluGenieYAML
				o	[Michael Arroyo] Added Alias Edit-BGJobPack
				o	[Michael Arroyo] Added Alias Edit-JobPack
				o	[Michael Arroyo] Added Alias JobPack
				o	[Michael Arroyo] Added Alias Edit-BluGenieJobPack
				o	[Michael Arroyo] Updated the FileBrowser function to look for YAML as well as JSON
				o	[Michael Arroyo] Removed all references of JSON from the verbose messaging and set it to just (Job).
				o	[Michael Arroyo] Auto detect the imported file type without a parameter
			•	[Get-BluGenieHelp.ps1]
				o	[Michael Arroyo] Updated script based on the (PSScriptAnalyzerSettings.psd1)
				o	[Michael Arroyo] Moved Build Notes out of General Posh Help section
				o	[Michael Arroyo] Added a new parameter called (Force) to forcefully create a new help cache file if one already exists.
				o	[Michael Arroyo] Removed the position property from the (Search) parameter.  This forces the use of the parameter name.
				o	[Michael Arroyo] Removed the position property from the (Help) parameter.  This forces the use of the parameter name.
				o	[Michael Arroyo] Added a new Alias called (BGHelp)
				o	[Michael Arroyo] Added a process to disable the Posh Progress bar while parsing Help information headers.
			•	[Connect-BluGenieToSystem.ps1]
				o	[Michael Arroyo] Updated the Description with more function detail
				o	[Michael Arroyo] Updated The ComputerName parameter to support multiple computers
				o	[Michael Arroyo] Added the missing parameter help header for (Force).
				o	[Michael Arroyo] Added a new parameter called (CopyModules).  This copies the BluGenie Module content to the remote host over
										WinRM without starting a Job.
				o	[Michael Arroyo] Added a new parameter called (SystemtModulePath).  When Copying the BluGenie Module content, set the save
										path to the default Windows PowerShell Module directory
											Notes: Path is $env:\ProgramFiles\WindowsPowerShell\Modules\BluGenie.
				o	[Michael Arroyo] Fixed the Help information region. Moved the (Build Version Details) from main help.  There is a Char limit
										and PSHelp could not read all the information correctly which also created issues using the (WalkThrough)
										parameter as well.
				o	[Michael Arroyo] Updated this function / script based on the new Linter (PSScriptAnalyzerSettings)
				o	[Michael Arroyo] Added a new Alias called (Connect-BGToSystem)
		* 21.05.1301:
			•	[BluGenie.ps1]
				o	[Michael Arroyo] Added CLI System lookup “/system | /sys” to call selected systems outside of the artifact file
				o	[Michael Arroyo] Added CLI Artifact lookup “/artifact | /a” to call a specific Artifact file
				o	[Michael Arroyo] Updated all JSON and YAML job references to Artifacts
			•	[BluGenie.psm1]
				o	[Michael Arroyo] Removed all JSON and YAML job commands and aliases
				o	[Michael Arroyo] Added Alias Name 'Publish-BGArtifact' Value 'Publish-BluGenieArtifact'
				o	[Michael Arroyo] Added Alias Name ‘BGArtifact' Value 'Publish-BluGenieArtifact'
				o	[Michael Arroyo] Added Alias Name 'Artifact' Value 'Publish-BluGenieArtifact'
				o	[Michael Arroyo] Added Alias Name 'Invoke-Analyzer' Value 'Invoke-BluGenieAnalyzer'
				o	[Michael Arroyo] Added Alias Name 'Invoke-BGAnalyzer' Value 'Invoke-BluGenieAnalyzer'
				o	[Michael Arroyo] Added Alias Name 'Get-BGADGroups' Value 'Get-BluGenieADGroups'
				o	[Michael Arroyo] Added Alias Name 'Get-BGADG' Value 'Get-BluGenieADGroups'
				o	[Michael Arroyo] Added Alias Name 'ADG' Value 'Get-BluGenieADGroups'
				o	[Michael Arroyo] Added Alias Name 'Get-BGADGroupMembers' Value 'Get-BluGenieADGroupMembers'
				o	[Michael Arroyo] Added Alias Name 'Get-BGADGM' Value 'Get-BluGenieADGroupMembers'
				o	[Michael Arroyo] Added Alias Name 'ADGM' Value 'Get-BluGenieADGroupMembers'
			•	[Core Framework]
				o	[Michael Arroyo] Added a sub folder called Artifacts to house the new Artifact files
				o	[Michael Arroyo] Added a sub folder called Collections to house files containing collections of systems
				o	[Michael Arroyo] Added 14 new Artifact files in reference to the new command Invoke-BGAnalyzes
				•	[Get-BluGenieADGroupMembers.ps1]
				o	[Michael Arroyo] Created a new tool to Query Active Directory via LDAP without the need for RSAT to be installed.
						This tool will Query Groups for members.  This will help to maintain Computer Groups/Collections in AD.
			•	[Publish-BluGenieArtifact.ps1]
				o	[Michael Arroyo] Created a new tool to Import, Export, and Review Artifact data from a JSON/YAML file.
						Artifacts are constructed logic to query local and remote systems for a specific Indicator of compromise or IOC.
						IOC is a forensic term that refers to the evidence on a device that points out to a security breach.
						The data of IOC is gathered after a suspicious incident, security event or unexpected call-outs from the network.
			•	[Set-BluGenieSystems.ps1]
				o	[Michael Arroyo] Updated the script based on the Current PSScriptAnalyzerSettings.psd1 settings
				o	[Michael Arroyo] Updated the script based on the new Function template to add more support for the interactive help
				o	[Michael Arroyo] Updated the WalkThrough function to the latest
				o	[Michael Arroyo] Added support to querying Domain Groups for computer objects
				o	[Michael Arroyo] Added support to querying Files for computer objects
			•	[BGAnalyzer.exe]
				o	[Michael Arroyo] .NET application forked from SeatBelt.  This tool is wrapped and managed by Invoke-BluGenieAnalyzer.ps1
				o	[Michael Arroyo] .NET 3.5 and 4.0 versions compiled
			•	[Invoke-BluGenieAnalyzer.ps1]
				o	[Michael Arroyo] Invoke-BluGenieAnalyzer is a wrapper around the BGAnalyzer tool.  BGAnalyzer is a C# project that performs a number of security oriented host-survey "safety checks" relevant from both offensive and defensive security perspectives.
						Items that can be queried:
						AMSIProviders - Providers registered for AMSI
						AntiVirus - Registered antivirus (via WMI)
						AppLocker - AppLocker settings, if installed
						ARPTable - Lists the current ARP table and adapter information (equivalent to arp -a)
						AuditPolicies - Enumerates classic and advanced audit policy settings
						AuditPolicyRegistry - Audit settings via the registry
						AutoRuns - Auto run executables/scripts/programs
						ChromiumBookmarks - Parses any found Chrome/Edge/Brave/Opera bookmark files
						ChromiumHistory - Parses any found Chrome/Edge/Brave/Opera history files
						ChromiumPresence - Checks if interesting Chrome/Edge/Brave/Opera files exist
						CloudCredentials - AWS/Google/Azure/Bluemix cloud credential files
						CloudSyncProviders - All configured Office 365 endpoints (tenants and teamsites) which are synchronised by OneDrive.
						CredEnum - Enumerates the current user's saved credentials using CredEnumerate()
						CredGuard - CredentialGuard configuration
						Dir - Lists files/folders. By default, lists users' downloads, documents, and desktop folders
						DNSCache - DNS cache entries (via WMI)
						DotNet - DotNet versions
						DpapiMasterKeys - List DPAPI master keys
						EnvironmentPath - Current environment %PATH$ folders and SDDL information
						EnvironmentVariables - Current environment variables
						ExplicitLogonEvents - Explicit Logon events (Event ID 4648) from the security event log. Default of 7 days
						ExplorerMRUs - Explorer most recently used files (last 7 days)
						ExplorerRunCommands - Recent Explorer "run" commands
						FileZilla - FileZilla configuration files
						FirefoxHistory - Parses any found FireFox history files
						FirefoxPresence - Checks if interesting Firefox files exist
						Hotfixes - Installed hotfixes (via WMI)
						IdleTime - Returns the number of seconds since the current user's last input.
						IEFavorites - Internet Explorer favorites
						IETabs - Open Internet Explorer tabs
						IEUrls - Internet Explorer typed URLs (last 7 days)
						InstalledProducts - Installed products via the registry
						InterestingFiles - "Interesting" files matching various patterns in the user's folder. Note: takes non-trivial time.
						InterestingProcesses - "Interesting" processes - defensive products and admin tools
						InternetSettings - Internet settings including proxy configs and zones configuration
						KeePass - Finds KeePass configuration files
						LAPS - LAPS settings, if installed
						LastShutdown - Returns the DateTime of the last system shutdown (via the registry).
						LocalGPOs - Local Group Policy settings applied to the machine/local users
						LocalGroups - Local groups
						LocalUsers - Local users, whether they're active/disabled, and pwd last set
						LogonEvents - Logon events (Event ID 4624) from the security event log. Default of 10 days.
						LogonSessions - Windows logon sessions
						LOLBAS - Locates Living Off the Land Binaries and Scripts (LOLBAS) on the system. Note: takes non-trivial time.
						LSASettings - LSA settings (including auth packages)
						MappedDrives - Users' mapped drives (via WMI)
						McAfeeConfigs - Finds McAfee configuration files
						McAfeeSiteList - Decrypt any found McAfee SiteList.xml configuration files.
						MicrosoftUpdates - All Microsoft updates (via COM)
						NamedPipes - Named pipe names and any readable ACL information.
						NetworkProfiles - Windows network profiles
						NetworkShares - Network shares exposed by the machine (via WMI)
						NTLMSettings - NTLM authentication settings
						OfficeMRUs - Office most recently used file list (last 7 days)
						OracleSQLDeveloper - Finds Oracle SQLDeveloper connections.xml files
						OSInfo - Basic OS info (i.e. architecture, OS version, etc.)
						OutlookDownloads - List files downloaded by Outlook
						PoweredOnEvents - Reboot and sleep schedule based on the System event log EIDs 1, 12, 13, 42, and 6008. Default of 7 days
						PowerShell - PowerShell versions and security settings
						PowerShellEvents - PowerShell script block logs (4104) with sensitive data.
						PowerShellHistory - Searches PowerShell console history files for sensitive regex matches.
						Printers - Installed Printers (via WMI)
						ProcessCreationEvents - Process creation logs (4688) with sensitive data.
						Processes - Running processes with file info company names that don't contain 'Microsoft'
						ProcessOwners - Running non-session 0 process list with owners
						PSSessionSettings - Enumerates PS Session Settings from the registry
						PuttyHostKeys - Saved Putty SSH host keys
						PuttySessions - Saved Putty configuration (interesting fields) and SSH host keys
						RDCManFiles - Windows Remote Desktop Connection Manager settings files
						RDPSavedConnections - Saved RDP connections stored in the registry
						RDPSessions - Current incoming RDP sessions
						RDPsettings - Remote Desktop Server/Client Settings
						RecycleBin - Items in the Recycle Bin deleted in the last 30 days - only works from a user context!
						Reg - Registry key values (HKLM\Software)
						RPCMappedEndpoints - Current RPC endpoints mapped
						SCCM - System Center Configuration Manager (SCCM) settings, if applicable
						ScheduledTasks - Scheduled tasks (via WMI) that aren't authored by 'Microsoft'
						SearchIndex - Query results from the Windows Search Index, default term of 'passsword'.
						SecPackageCreds - Obtains credentials from security packages
						SecurityPackages - Enumerates the security packages currently available using EnumerateSecurityPackagesA()
						Services - Services with file info company names that don't contain 'Microsoft'
						SlackDownloads - Parses any found 'slack-downloads' files
						SlackPresence - Checks if interesting Slack files exist
						SlackWorkspaces - Parses any found 'slack-workspaces' files
						SuperPutty - SuperPutty configuration files
						Sysmon - Sysmon configuration from the registry
						SysmonEvents - Sysmon process creation logs (1) with sensitive data.
						TcpConnections - Current TCP connections and their associated processes and services
						TokenGroups - The current token's local and domain groups
						TokenPrivileges - Currently enabled token privileges (e.g. SeDebugPrivilege/etc.)
						UAC - UAC system policies via the registry
						UdpConnections - Current UDP connections and associated processes and services
						UserRightAssignments - Configured User Right Assignments (e.g. SeDenyNetworkLogonRight, SeShutdownPrivilege, etc.)
						WindowsAutoLogon - Registry autologon information
						WindowsCredentialFiles - Windows credential DPAPI blobs
						WindowsDefender - Windows Defender settings (including exclusion locations)
						WindowsEventForwarding - Windows Event Forwarding (WEF) settings via the registry
						WindowsFirewall - Firewall rules - (allow/deny/tcp/udp/in/out/domain/private/public)
						WindowsVault - Credentials saved in the Windows Vault (i.e. logins from Internet Explorer and Edge).
						WMIEventConsumer - Lists WMI Event Consumers
						WMIEventFilter - Lists WMI Event Filters
						WMIFilterBinding - Lists WMI Filter to Consumer Bindings
						WSUS - Windows Server Update Services (WSUS) settings, if applicable
			•	[Get-BluGenieADGroups.ps1]
				o	[Michael Arroyo] Query for Active Directory Groups via LDAP without the need for RSAT to be installed.
		* 21.05.1701:
			•	[Invoke-BluGeniePython]
				o	[Michael Arroyo] Invoke-BluGeniePython will enable a BluGenie Managed Portable version of Python
			•	[Format-BluGenieEvent]
				o	[Michael Arroyo] Format-BluGenieEvent will Format a Windows System Event Log with new properties from the Message field.  An Event has a Message that is one big string.  This function will parse that information and convert any valid line item into a new Object Property and         bind it back to the original PsObject.
				o	[Michael Arroyo] Added Parameter –Schema.  Use a Schema file to change or remap any property name in any Windows Event your trying to Query
				o	[Michael Arroyo] Added Parameter –NoMsgPrefix.  By Default, the Event Message content is parsed and all properties have a Prefix called (Msg).  This option will force the normal property names without (Msg).
				o	[Michael Arroyo] Added Parameter –RemoveCache.  Remove Cache data on completion.  Notes: Cache information is removed right before the data is returned to the calling process
										Items Removed:
											•	JSON Output for EQL Query
											•	SQLite DB if you do not use the -DBPath = ':MEMORY:' parameter.  Note: The DB in memory is the default option for SQL
				o	[Michael Arroyo] Added Parameter –ClearGarbageCollecting.  Garbage Collection in PowerShell to Speed up Scripts and help lower memory consumption
				o	[Michael Arroyo] Updated the Function to the latest template which includes new parameters (Walkthrough, ReturnObject, OutUnEscapedJSON, OutYaml)
				o	[Michael Arroyo] Added Parameter –OutJSON.  Return detailed information in JSON Format
				o	[Michael Arroyo] Added Parameter –ExportPath.  The Path to Export / Save parsed event data to the local disk
				o	[Michael Arroyo] Added Parameter –EQLQuery.  Use EQL Queries to parse the data
				o	[Michael Arroyo] Added Parameter –SQLQuery.  Use SQL Queries to parse the data
				o	[Michael Arroyo] Added Parameter –DBName.  Database name used when parsing using SQL and Setting the DBPath to a local disk path
				o	[Michael Arroyo] Added Parameter –DBTableName.  Database table name when parsing using SQL.
				o	[Michael Arroyo] Added Parameter –DBPath.  Database Path when parsing using SQL
				o	[Michael Arroyo] Added Parameter –PropsOnly.  Used to only parse and display the Properties of an Event Message field.  No other event data will be captured.
				o	[Michael Arroyo] Added Parameter –FormatView.  Automatically format the Return Object to any of the following formats.  ‘Table', 'Custom', 'CustomModified', 'None', 'JSON', 'OutUnEscapedJSON', 'CSV', 'Yaml'
			•	[Install-BluGenieSysMon]
				o	[Michael Arroyo] Updated the function to Install, Update, or Uninstall the SysMon SysInternals tool.  The function will no longer copy the tool to the remote system.
				o	[Michael Arroyo] Updated Source parameter to SourcePath.  The Source location of the SysMon tools
				o	[Michael Arroyo] Added Parameter –ConfigFile.  Full file path for a SysMon Configuation XML
				o	[Michael Arroyo] Added Parameter –Uninstall.  Stop and Remove the SysMon Service
				o	[Michael Arroyo] Added Parameter –ForceInstall.  Overwrite the current installation and remove and reinstall the service.
				o	[Michael Arroyo] Updated the Function to the latest template which includes new parameters (Walkthrough, ReturnObject, OutUnEscapedJSON, OutYaml, DBName, DBPath, UpdateDB, ForceDBUpdate, NewDEBTable, ClearGarbageCollecting, OutYaml, FormatView)
			•	[BluGenie.psd1]
				o	[Michael Arroyo] Updated the Build Notes and Version information
			•	[BluGenie.psm1]
				o	[Michael Arroyo] Added Alias (Name 'Invoke-BGPython' Value 'Invoke-BluGeniePython')
				o	[Michael Arroyo] Added Alias (Name 'BGPython' Value 'Invoke-BluGeniePython')
				o	[Michael Arroyo] Added Alias (Name 'Format-BGEvent' Value 'Format-BluGenieEvent')
				o	[Michael Arroyo] Added Alias (Name 'BGEvent' Value 'Format-BluGenieEvent')
		* 21.05.1702:
			•	[Set-BluGenieScriptCredentials]
				o	[Michael Arroyo] Posted - Set Credentials in runtime without using Get-Credentials and being prompted for a password
			•	[BluGenie Core]
				o	[Michael Arroyo] - Added Module ( RabbitMQTools - Ver 1.3 -> https://github.com/RamblingCookieMonster/RabbitMQTools/archive/master.zip )
				o	[Michael Arroyo] - Added Config/Script location for EQLQueries files 	-> .\Blubin\Modules\BluGenie\Configs\EQLQueries
				o	[Michael Arroyo] - Added Config/Script location for Python files 		-> .\Blubin\Modules\BluGenie\Configs\Python
				o	[Michael Arroyo] - Added Config/Script location for Schema files 		-> .\Blubin\Modules\BluGenie\Configs\Schema
				o	[Michael Arroyo] - Added Config/Script location for SQLQueries files 	-> .\Blubin\Modules\BluGenie\Configs\SQLQueries
				o	[Michael Arroyo] - Added Comments to the Config.Yaml
			•	[Get-BluGenieAutoRuns]
				o [Ravi Vinod Dubey] Moved Build Notes out of General Posh Help section
				o [Ravi Vinod Dubey] Added support for Caching
				o [Ravi Vinod Dubey] Added support for Clearing Garbage collecting
				o [Ravi Vinod Dubey] Added support for SQLite DB
				o [Ravi Vinod Dubey] Updated Process Query and Filtering
				o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
										unless you manually set the -Verbose parameter.
				o [Ravi Vinod Dubey] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
				o [Ravi Vinod Dubey] Change the script to check the AutoRuns tools in ..\Tools\SysinternalsSuite\.
				o [Ravi Vinod Dubey] Change the script to check the AutoRuns $ToolPath.
				o [Michael Arroyo] Updated the ArrToolPath scriptblock
				o [Michael Arroyo] Updated the HideSigned PARAMETER help information.  Removed ValidateSet information.
				o [Michael Arroyo] Removed all parameter position flags.  These options are no longer needed.
				o [Michael Arroyo] Updated the function based on the PSScriptAnalyzerSettings configuration.
				o [Michael Arroyo] Added funtion Alias ( Get-BGAutoRuns )
			•	[Invoke-BluGenieYara]
				o [Ravi Vinod Dubey] Change the script to check the AutoRuns tools in ..\Tools\Yara\.
				o [Ravi Vinod Dubey] Change the $ToolPath from Temp to the $ToolsPathDirectory\Yara.
				o [Michael Arroyo] Updated the ArrToolPath scriptblock
			•	[Get-BluGenieSignature]
				o [Michael Arroyo] Updated the function based on the PSScriptAnalyzerSettings configuration.
				o [Michael Arroyo] Added funtion Alias ( Get-BGSignature )
				o [Michael Arroyo] Updated the ArrToolPath scriptblock
			•	[Test-BluGenieIsFileLocked]
				o [Michael Arroyo] Updated the function based on the PSScriptAnalyzerSettings configuration.
			•	[Invoke-BluGeniePython]
				• [Michael Arroyo] Added a Dynamic Path process to update the pyvenv.cfg file based on where the BGPython directory is located
                • [Michael Arroyo] -Remove will now search the current env:path to make sure you didn't load the BluGenie Python into the
					normal env.  If so, it will remove it as well as the BGPython Directory.
				o [Michael Arroyo] Successful setup is now based on checks to the $env:Path and the pyvenv.cfg to make sure they match
				o  [Michael Arroyo] Once BGPython is setup you can now run Python commands in the BGConsole without running BluGenie commands
									Example: Python --version
									Example: Python $env:temp\MyScript.py
		* 21.05.1703:
			•	[Invoke-BluGeniePython]
				o [Michael Arroyo] Added parameter WinPyConsole.  This will open up the WinPython Command Prompt.
				o [Michael Arroyo] Added $ToolsDirectory\BGPython\scripts to the env path
				o [Michael Arroyo] Updated the env to support EQL calls directory
				o [Michael Arroyo] Updated the env to support EQLLib calls directory
				o [Michael Arroyo] Updated the env to support Python calls Directory
				o [Michael Arroyo] Added env startup script to rebuild or add to the env dynamically by adding Lib / Pip installs to ->
					$ToolsDirectory\BGPython\settings\BGSetup.ps1
			•	[BluGenie Core]
				o [Michael Arroyo] Fixed the Config.YAML config.  The RemoteWSManConfig: section had a space in front of it which caused the file
					not to load.
			•	[Expand-BluGenieArchivePS2]
				o [Michael Arroyo] Fixed parameter $NoErrorMsg in the (Set Extraction Flags) region.
					It was not set as it should, so when calling it the parameter would cause a process failure.
		* 21.05.1704:
			•	[Format-BluGenieEvent]
				o [Michael Arroyo] Added ForceEQLGenericQuery switch to Force an EQL Generic Query even if EQL has a known Schema type
				o [Michael Arroyo] Rebuilt Event Object using (ConvertTo-JSON | ConvertFrom-JSON)
				o [Michael Arroyo] Updated the Schema mapping change to also work on -PropsOnly
				o [Michael Arroyo] Updated the EQL json output to have a list view even if the Object has a single item.
					By default a single item in the json Array would not stay a list.  But EQL needs a list format no matter what.
				o [Michael Arroyo] Fixed the Parsed Count item.  It was coming back as null
				o [Michael Arroyo] Added new Examples for the new EQL Query types
			•	[BluGenie Core]
				o [Michael Arroyo] Added a new Schema file for SysMon Event ID 3
		* 21.05.1705:
			•	[Format-BluGenieEvent]
				o [Michael Arroyo] Added new Parameter UseInputFile - Force Query from a previously saved file and not the Windows Event Log
					The supported file formats are EVT, EVTX, and JSON
				o [Michael Arroyo] Updated the ExportPath parameter to have the default path $env:systemdrive\Windows\Temp\BGFE_<GUID>.json
				o [Michael Arroyo] Added new Parameter Export - Enable the Export of Filtered data for later use
				o [Michael Arroyo] Updated the PropsOnly parameter to work with imported data as well as the Event Viewer Log Data
				o [Michael Arroyo] Added new Parameter ExcludeFilter - Use an ExcludeFilter Yaml file to remove items that you do not want to
					include in the Event Search.
			•	[Invoke-BluGeniePython]
				o [Michael Arroyo] Removed Progress Bar while processing BGPython Extract to speed up performance.
				o [Michael Arroyo] Fixed some of the region headers in Main
				o [Michael Arroyo] Updated BGSetup.ps1 to support Local Wheel installs
				o [Michael Arroyo] Added a new directory to house the local wheel installs $ToolsDirectory\BGPython\settings\localwheels
				o [Michael Arroyo] Added local wheel install (psutil-5.8.0-cp38-cp38-win_amd64.whl)
				o [Michael Arroyo] Added local wheel install (pywin32-301-cp38-cp38-win_amd64.whl)
				o [Michael Arroyo] Added local wheel install (regex-2021.7.6-cp38-cp38-win_amd64.whl)
				o [Michael Arroyo] Added local wheel install (WMI-1.5.1-py2.py3-none-any.whl)
				o [Michael Arroyo] Added Verbose Logging to the BGSetup.ps1 if -Verbose is used with Invoke-BluGeniePython
		* 21.05.1706:
			•	[Format-BluGenieEvent]
				o [Michael Arroyo] Renamed Parameter FilterHashTable to LogName
				o [Michael Arroyo] Added a new Parameter called (ID) to handle the Event ID's instead of adding them to the LogName string
				o [Michael Arroyo] Updated the Help information to the new Event, MaxEvent, and LogID parameter values
				o [Michael Arroyo] Converted FilterHashTable for Get-WinEvent to use a Switch Statement
				o [Michael Arroyo] Created a new Parameter called (AppendEventHash) - Query based on more Event Filter Hash Table information
				o [Michael Arroyo] Parse each message field and auto correct Type information to rebuild [Int] types if captured as [String]
				o [Michael Arroyo] Set the default location for an EQLQuery file.  The default lookup location is
									$BluGenieModulePath\BluGenie\Configs\EQLQueries\
				o [Michael Arroyo] Set the default location for an SQLQuery file.  The default lookup location is
									$BluGenieModulePath\BluGenie\Configs\SQLQueries\
				o [Michael Arroyo] Set the default location for an Exclude file.  The default lookup location is
									$BluGenieModulePath\BluGenie\Configs\Schema\
			•	[Invoke-BluGeniePython]
				o [Michael Arroyo] Set the $Global:ProgressPreference on Start and End of this funtion
		* 21.11.0801:
			[BluGenie]
				o [Michael Arroyo] Updated HelpMnu.dat to include the new Help Module information
				o [Michael Arroyo] Added Walk as an Alias for Invoke-WalkThrough
				o [Michael Arroyo] Added Trap to the Alias list (This is to support the BluGenie Console Settings functions)
				o [Michael Arroyo] Added new function [Set-BGVerbose] to manage the Verbose Setting value in the BluGenie Console
				o [Michael Arroyo] Added new function [Set-BluGenieNoSetRes] to manage the NoSetRes Setting value in the BluGenie Console
				o [Michael Arroyo] Added new function [Set-BluGenieNoExit] to manage the NoExit Setting value in the BluGenie Console
				o [Michael Arroyo] Added new function [Set-BluGenieNoBanner] to manage the NoBanner Setting value in the BluGenie Console
				o [Michael Arroyo] Added new function [Set-BluGenieUpdateMods] to manage the UpdateMods Setting value in the BluGenie Console
				o [Michael Arroyo] Added new function [Set-BluGenieServiceJob] to manage the ServiceJoib Setting value in the BluGenie Console
			[BluGenie.psm1]
				o [Michael Arroyo] Consolidated Code (Removed 800 plus lines of code with this update)
				o [Michael Arroyo] Updated all ForEach-Object references to ForEach to determine speed updates (only gained 3 seconds in load time)
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
				o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
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
				o [Ravi Vinod Dubey] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
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
				o [Michael Arroyo] Added support for the -Verbose parameter.  The query return will no longer shows extended debugging info
					unless you manually set the -Verbose parameter.
				o [Michael Arroyo] Added support for the -NewDBTable parameter.  This will delete and recreate the DB Table.
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -ForceDBUpdate is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to enable -UpdateDB if -NewDBTable is used
				o [Michael Arroyo] Updated the Dynamic parameter update region to disable -UpdateDB if running under PowerShell 2
				o [Michael Arroyo] Tools path updated with $('{0}\Tools\Yara\{1}' -f $(Get-Location | Select-Object -ExpandProperty Path), $Yara)
				o [Michael Arroyo] Updated the CommandlineOptions switch process to pull from the parameters directly instead of the
					PSBoundParameters. This is cleaner and also allows you to test in real time.  The old way using PSBoundParameters
					is only valid at runtime or debug mode.
			[Set-BluGenieDebugger]
				o [Michael Arroyo] Consolidated Code
				o [Michael Arroyo] Updated the Parameter and Example Help Header Information
				o [Michael Arroyo] Updated the Description Information for Help content
				o [Michael Arroyo] Updated the Walk Through
			[PSScriptAnalyzerSettings]
				o [Michael Arroyo] Updated to look like the below.
									PSPlaceCloseBrace = @{
										Enable             = $true
										NoEmptyLineBefore  = $true
										IgnoreOneLineBlock = $false
										NewLineAfter       = $false
									}
									PSPlaceOpenBrace = @{
										Enable             = $true
										OnSameLine         = $true
										NewLineAfter       = $false
										IgnoreOneLineBlock = $false
									}
			[Set-BluGenieJobTimeout]
				o [Michael Arroyo] Consolidated Code
				o [Michael Arroyo] Updated the Parameter and Example Help Header Information
				o [Michael Arroyo] Updated the Description Information for Help content
				o [Michael Arroyo] Updated the Walk Through
			[Set-BluGenieTrapping]
				o [Michael Arroyo] Consolidated Code
				o [Michael Arroyo] Updated the Parameter and Example Help Header Information
				o [Michael Arroyo] Updated the Description Information for Help content
				o [Michael Arroyo] Updated the Walk Through
			[Set-BGVerbose]
				o [Michael Arroyo] (Initial Post) Set-BluGenieVerbose is an add-on to manage the Verbose status in the BluGenie Console.
			[Set-BluGenieNoSetRes]
				o [Michael Arroyo] Set the NoSetRes value so to not update the frame of the Console.  Use the OS's default command prompt size.
			[Set-BluGenieNoExit]
				o [Michael Arroyo] Setting this option will stay in the Console after executing an automated Job or command from the CLI.
			[Set-BluGenieNoBanner]
				o [Michael Arroyo] Do not display the BluGenie Welcome Screen.
			[Set-BluGenieUpdateMods]
				o [Michael Arroyo] Force all managed BluGenie files and folders to be updated on the remote machine
			[Set-BluGenieServiceJob]
				o [Michael Arroyo] Send the artifact to the remote machine to be run by the BluGenie Service.
									Note: This will only work if the BluGenie service is running. If not, the artifact will fallback to the remote
											connection execution process.
			[Set-BluGenieCores]
				o [Michael Arroyo] Set-BluGenieCores is an add-on to control how many Cores to use while in the BluGenie Console
									Select the amount of cores you want this job to use.  Default is (ALL).
									Core information is pulled from the ($env:NUMBER_OF_PROCESSORS) variable.
			[Set-BluGenieJobMemory]
				o [Michael Arroyo] Set-BluGenieJobMemory is an add-on to control the Job Memory used while processing a BluGenie Job
									Select the amount of Memory you want this job to use.  Default is (512mb).
									Memory information is pulled from (ClassName Win32_PhysicalMemory)
#>
@{

	# Script module or binary module file associated with this manifest
	# RootModule = 'BluGenie.psm1' #(Posh 3 and up)
	ModuleToProcess = 'BluGenie.psm1'

	# Version number of this module.
	ModuleVersion = '21.11.0801'

	# ID used to uniquely identify this module
	GUID = '5f602af5-3b61-4513-95aa-899a4ba069b9'

	# Author of this module
	Author = 'BluSapphire'

	# Company or vendor of this module
	CompanyName = 'BluSapphire'

	# Copyright statement for this module
	Copyright = '(c) 2020. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'A Cyber Security framework for Windows PowerShell.'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = ''

	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''

	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = ''

	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = ''

	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules = @()

	# Functions to export from this module
	FunctionsToExport = '*' #For performance, list functions explicitly

	# Cmdlets to export from this module
	CmdletsToExport = '*'

	# Variables to export from this module
	VariablesToExport = '*'

	# Aliases to export from this module
	AliasesToExport = '*' #For performance, list alias explicitly

	# List of all modules packaged with this module
	ModuleList = @()

	# List of all files packaged with this module
	FileList = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()

			# A URL to the license for this module.
			# LicenseUri = ''

			# A URL to the main website for this project.
			# ProjectUri = ''

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			# ReleaseNotes = ''

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}