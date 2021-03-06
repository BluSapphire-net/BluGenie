# Invoke-BluGenieAnalyzer

## SYNOPSIS
BGAnalyzer is a C# project that performs a number of security oriented host-survey "safety checks" relevant from both offensive and
defensive security perspectives.

## SYNTAX
```
Invoke-BluGenieAnalyzer [[-FilterType] <String>] [[-FilterData] <String>] [-Full] [-AddException] [-LeaveException] [[-ToolPath] <String>] 
[-ClearGarbageCollecting] [-UseCache] [[-CachePath] <String>] [-RemoveCache] [[-DBName] <String>] [[-DBPath] <String>] [-UpdateDB] [-ForceDBUpdate] 
[-NewDBTable] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-OutYaml] [[-FormatView] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-BluGenieAnalyzer is a wrapper around the BGAnalyzer tool.  BGAnalyzer is a C# project that performs a number of security oriented
host-survey "safety checks" relevant from both offensive and defensive security perspectives.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Invoke-BGAnalyzer -AddException
 ``` 
 ```yam 
 Description: Use this command to update the Windows Defender Exception list to allow for the BGAnalyzer .NET application to run
Notes: Some .NET code has been used in other open source projects and Microsoft has flagged any scans based on similar techniques
        to be potentially malicious.
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Invoke-BGAnalyzer
 ``` 
 ```yam 
 Description: Use this BluGenie reference Alias to run BGAnalyzer and gather all security scan inventory
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Invoke-BGAnalyzer -LeaveException
 ``` 
 ```yam 
 Description: Use this command to gather all security scan inventory and leave the Windows Defender exception for future scans
Notes: By default the exception is removed after each execution
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Invoke-BluGenieAnalyzer
 ``` 
 ```yam 
 Description: Use this command to run BGAnalyzer and gather all security scan inventory
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Invoke-BGAnalyzer
 ``` 
 ```yam 
 Description: Use this BluGenie reference Alias to run BGAnalyzer and gather all security scan inventory
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Invoke-Analyzer
 ``` 
 ```yam 
 Description: Use this Long-hand Alias to run BGAnalyzer and gather all security scan inventory
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Invoke-Analyzer -Full
 ``` 
 ```yam 
 Description: Use this command to Expand on the Data returned for LocalGroups, Processes, ScheduledTasks, Services, and the WindowsFirewall
Notes:  By default this option is not set
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Invoke-BGAnalyzer -FilterType 'Install|Update'
 ``` 
 ```yam 
 Description: Use this command to filter the Query type for Installed Products and Windows Updates
Notes: Check the filter parameter to see all the filter options.  The filter uses Regex.
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Invoke-BGAnalyzer -FilterType 'Install' -FilterData 'Python'
 ``` 
 ```yam 
 Description: Use this command to filter for a specific product installation.
Notes: You can change the type and data filters to select specific information you need.
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Invoke-BGAnalyzer -FilterType 'Install' -FilterData 'Python' -UseCache -CachePath $Env:Temp
 ``` 
 ```yam 
 Description: Use the command to Cache the gathered information to a file on the current users Temp directory
Notes: By default the Cache location is %SystemDrive%\Windows\Temp
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Invoke-BGAnalyzer -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 12
 ``` 
 Command: Invoke-BGAnalyzer -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 13
 ``` 
 Command: Invoke-Analyzer -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Use this command to Return a detailed report in an UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 14
 ``` 
 Command: Invoke-Analyzer -OutYaml
 ``` 
 ```yam 
 Description: Use this command to Return a detailed report in YAML format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 15
 ``` 
 Command: $Info = Invoke-Analyzer -ReturnObject
 ``` 
 ```yam 
 Description: Use this command to capture the return data as a Powershell Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        This parameter is also used with the FormatView
 ``` 
 
### EXAMPLE 16
 ``` 
 Command: Invoke-Analyzer -FilterType 'install' -FilterData 'python' -ReturnObject -FormatView CSV
 ``` 
 ```yam 
 Description: Use this command to Output the return data in CSV format
Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
        Default is set to (None) and normal PSObject.
 ``` 


## PARAMETERS

### FilterType
 ```yam 
 -FilterType <String>
    Description: Command Types (Filtered with RegEx)
    Notes:  Default is set to '.*'
                  ** Other Types **
                  o AMSIProviders          - Providers registered for AMSI
                  o AntiVirus              - Registered antivirus (via WMI)
                  o AppLocker              - AppLocker settings, if installed
                  o ARPTable               - Lists the current ARP table and adapter information (equivalent to arp -a)
                  o AuditPolicies          - Enumerates classic and advanced audit policy settings
                  o AuditPolicyRegistry    - Audit settings via the registry
                  o AutoRuns               - Auto run executables/scripts/programs
                  o ChromiumBookmarks      - Parses any found Chrome/Edge/Brave/Opera bookmark files
                  o ChromiumHistory        - Parses any found Chrome/Edge/Brave/Opera history files
                  o ChromiumPresence       - Checks if interesting Chrome/Edge/Brave/Opera files exist
                  o CloudCredentials       - AWS/Google/Azure/Bluemix cloud credential files
                  o CloudSyncProviders     - All configured Office 365 endpoints (tenants and teamsites) which are synchronised by OneDrive.
                  o CredEnum               - Enumerates the current user's saved credentials using CredEnumerate()
                  o CredGuard              - CredentialGuard configuration
                  o Dir                    - Lists files/folders. By default, lists users' downloads, documents, and desktop folders
                  o DNSCache               - DNS cache entries (via WMI)
                  o DotNet                 - DotNet versions
                  o DpapiMasterKeys        - List DPAPI master keys
                  o EnvironmentPath        - Current environment %PATH$ folders and SDDL information
                  o EnvironmentVariables   - Current environment variables
                  o ExplicitLogonEvents    - Explicit Logon events (Event ID 4648) from the security event log. Default of 7 days
                  o ExplorerMRUs           - Explorer most recently used files (last 7 days)
                  o ExplorerRunCommands    - Recent Explorer "run" commands
                  o FileZilla              - FileZilla configuration files
                  o FirefoxHistory         - Parses any found FireFox history files
                  o FirefoxPresence        - Checks if interesting Firefox files exist
                  o Hotfixes               - Installed hotfixes (via WMI)
                  o IdleTime               - Returns the number of seconds since the current user's last input.
                  o IEFavorites            - Internet Explorer favorites
                  o IETabs                 - Open Internet Explorer tabs
                  o IEUrls                 - Internet Explorer typed URLs (last 7 days)
                  o InstalledProducts      - Installed products via the registry
                  o InterestingFiles       - "Interesting" files matching various patterns in the user's folder. Note: takes non-trivial time.
                  o InterestingProcesses   - "Interesting" processes - defensive products and admin tools
                  o InternetSettings       - Internet settings including proxy configs and zones configuration
                  o KeePass                - Finds KeePass configuration files
                  o LAPS                   - LAPS settings, if installed
                  o LastShutdown           - Returns the DateTime of the last system shutdown (via the registry).
                  o LocalGPOs              - Local Group Policy settings applied to the machine/local users
                  o LocalGroups            - Local groups
                  o LocalUsers             - Local users, whether they're active/disabled, and pwd last set
                  o LogonEvents            - Logon events (Event ID 4624) from the security event log. Default of 10 days.
                  o LogonSessions          - Windows logon sessions
                  o LOLBAS                 - Locates Living Off The Land Binaries and Scripts (LOLBAS) on the system. Note: takes non-trivial time.
                  o LSASettings            - LSA settings (including auth packages)
                  o MappedDrives           - Users' mapped drives (via WMI)
                  o McAfeeConfigs          - Finds McAfee configuration files
                  o McAfeeSiteList         - Decrypt any found McAfee SiteList.xml configuration files.
                  o MicrosoftUpdates       - All Microsoft updates (via COM)
                  o NamedPipes             - Named pipe names and any readable ACL information.
                  o NetworkProfiles        - Windows network profiles
                  o NetworkShares          - Network shares exposed by the machine (via WMI)
                  o NTLMSettings           - NTLM authentication settings
                  o OfficeMRUs             - Office most recently used file list (last 7 days)
                  o OracleSQLDeveloper     - Finds Oracle SQLDeveloper connections.xml files
                  o OSInfo                 - Basic OS info (i.e. architecture, OS version, etc.)
                  o OutlookDownloads       - List files downloaded by Outlook
                  o PoweredOnEvents        - Reboot and sleep schedule based on the System event log EIDs 1, 12, 13, 42, and 6008. Default of 7 days
                  o PowerShell             - PowerShell versions and security settings
                  o PowerShellEvents       - PowerShell script block logs (4104) with sensitive data.
                  o PowerShellHistory      - Searches PowerShell console history files for sensitive regex matches.
                  o Printers               - Installed Printers (via WMI)
                  o ProcessCreationEvents  - Process creation logs (4688) with sensitive data.
                  o Processes              - Running processes with file info company names that don't contain 'Microsoft'
                  o ProcessOwners          - Running non-session 0 process list with owners
                  o PSSessionSettings      - Enumerates PS Session Settings from the registry
                  o PuttyHostKeys          - Saved Putty SSH host keys
                  o PuttySessions          - Saved Putty configuration (interesting fields) and SSH host keys
                  o RDCManFiles            - Windows Remote Desktop Connection Manager settings files
                  o RDPSavedConnections    - Saved RDP connections stored in the registry
                  o RDPSessions            - Current incoming RDP sessions
                  o RDPsettings            - Remote Desktop Server/Client Settings
                  o RecycleBin             - Items in the Recycle Bin deleted in the last 30 days - only works from a user context!
                  o Reg                    - Registry key values (HKLM\Software)
                  o RPCMappedEndpoints     - Current RPC endpoints mapped
                  o SCCM                   - System Center Configuration Manager (SCCM) settings, if applicable
                  o ScheduledTasks         - Scheduled tasks (via WMI) that aren't authored by 'Microsoft'
                  o SearchIndex            - Query results from the Windows Search Index, default term of 'passsword'.
                  o SecPackageCreds        - Obtains credentials from security packages
                  o SecurityPackages       - Enumerates the security packages currently available using EnumerateSecurityPackagesA()
                  o Services               - Services with file info company names that don't contain 'Microsoft'
                  o SlackDownloads         - Parses any found 'slack-downloads' files
                  o SlackPresence          - Checks if interesting Slack files exist
                  o SlackWorkspaces        - Parses any found 'slack-workspaces' files
                  o SuperPutty             - SuperPutty configuration files
                  o Sysmon                 - Sysmon configuration from the registry
                  o SysmonEvents           - Sysmon process creation logs (1) with sensitive data.
                  o TcpConnections         - Current TCP connections and their associated processes and services
                  o TokenGroups            - The current token's local and domain groups
                  o TokenPrivileges        - Currently enabled token privileges (e.g. SeDebugPrivilege/etc.)
                  o UAC                    - UAC system policies via the registry
                  o UdpConnections         - Current UDP connections and associated processes and services
                  o UserRightAssignments   - Configured User Right Assignments (e.g. SeDenyNetworkLogonRight, SeShutdownPrivilege, etc.)
                  o WindowsAutoLogon       - Registry autologon information
                  o WindowsCredentialFiles - Windows credential DPAPI blobs
                  o WindowsDefender        - Windows Defender settings (including exclusion locations)
                  o WindowsEventForwarding - Windows Event Forwarding (WEF) settings via the registry
                  o WindowsFirewall        - Firewall rules - (allow/deny/tcp/udp/in/out/domain/private/public)
                  o WindowsVault           - Credentials saved in the Windows Vault (i.e. logins from Internet Explorer and Edge).
                  o WMIEventConsumer       - Lists WMI Event Consumers
                  o WMIEventFilter         - Lists WMI Event Filters
                  o WMIFilterBinding       - Lists WMI Filter to Consumer Bindings
                  o WSUS                   - Windows Server Update Services (WSUS) settings, if applicable
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                .*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FilterData
 ```yam 
 -FilterData <String>
    Description: Return Data (Filtered with RegEx)
    Notes:  Default is set to '.*'
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                .*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Full
 ```yam 
 -Full [<SwitchParameter>]
    Description: Expand on the Data returned for (LocalGroups, Processes, ScheduledTasks, Services, and the WindowsFirewall)
    Notes:  o LocalGroups     - "Full" displays all groups / Default: Non-empty local groups
                  o Processes       - "Full" enumerates all processes / Default: Running processes with file info company names that don't
                      contain 'Microsoft'
                  o ScheduledTasks  - "Full" dumps all Scheduled tasks / Default: Scheduled tasks (via WMI) that aren't authored by 'Microsoft'
                  o Services        - "Full" dumps all processes / Default: Services with file info company names that don't contain 'Microsoft'
                  o WindowsFirewall - "Full" dumps all FireWall rules (allow/deny/tcp/udp/in/out/domain/private/public) / Default: Non-standard
                      rules
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### AddException
 ```yam 
 -AddException [<SwitchParameter>]
    Description: Add an Exception to Windows Defender to allow the .NET process to run
    Notes: Windows Defender does not allow for adding an Exception and running the newly excluded process in the same runspace.
                  If you use the -AddException parameter (No other option will process)  There is also no return.  The script just adds the
                  exception and ends.
    
                  Running the command for a 2nd time without the -AddException parameter will execute the .NET process without issue.
    
                  The exception is removed by default.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### LeaveException
 ```yam 
 -LeaveException [<SwitchParameter>]
    Description: Leave the Windows Defender Exception for continues runs at a later point
    Notes: Windows Defender does not allow for adding an Exception and running the newly excluded process in the same runspace.
                  If you use the -AddException parameter (No other option will process)  There is also no return.  The script just adds the
                  exception and ends.
    
                  Running the command for a 2nd time without the -AddException parameter will execute the .NET process without issue.
    
                  The exception is removed by default.  However if you use this parameter -LeaveException the Exception is not removed.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ToolPath
 ```yam 
 -ToolPath <String>
    Description:  This is the path to the BGAnalyzer tool.
    Notes: There are 2 subfolders.
                  .\3.5 which houses the .NET 3.5 version of the binary
                  .\4.0 wihch houses the .NET 4.0 version of the binary
    
                  This is automatically selected based on PowerShell's supported CRL Version.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                $(Resolve-Path -Path $ToolsDirectory | Select-Object -ExpandProperty Path)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ClearGarbageCollecting
 ```yam 
 -ClearGarbageCollecting [<SwitchParameter>]
    Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
    Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### UseCache
 ```yam 
 -UseCache [<SwitchParameter>]
    Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
    Notes: By default the Cache location is %SystemDrive%\Windows\Temp
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CachePath
 ```yam 
 -CachePath <String>
    Description: Path to store the Cache information
    Notes: By default the Cache location is %SystemDrive%\Windows\Temp
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    4
    Default value                $('{0}\Windows\Temp\{1}.log' -f $env:SystemDrive, $(New-BluGenieUID))
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RemoveCache
 ```yam 
 -RemoveCache [<SwitchParameter>]
    Description: Remove Cache data on completion
    Notes: Cache information is removed right before the data is returned to the calling process
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### DBName
 ```yam 
 -DBName <String>
    Description: Database Name (Without extention)
    Notes: The default name is set to 'BluGenie'
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    5
    Default value                BluGenie
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### DBPath
 ```yam 
 -DBPath <String>
    Description: Path to either Save or Update the Database
    Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    6
    Default value                $('{0}\BluGenie' -f $env:ProgramFiles)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### UpdateDB
 ```yam 
 -UpdateDB [<SwitchParameter>]
    Description: Save return data to the Sqlite Database
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ForceDBUpdate
 ```yam 
 -ForceDBUpdate [<SwitchParameter>]
    Description: Force an update of the return data to the Sqlite Database
    Notes: By default only new items are saved.  The primary key is ( FullName )
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NewDBTable
 ```yam 
 -NewDBTable [<SwitchParameter>]
    Description: Delete and Recreate the Database Table
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
    Notes:
    Alias: Help
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Description: Return information as an Object
    Notes: By default the data is returned as a Hash Table
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Description: Remove UnEsacped Char from the JSON information.
    Notes: This will beautify json and clean up the formatting.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutYaml
 ```yam 
 -OutYaml [<SwitchParameter>]
    Description: Return detailed information in Yaml Format
    Notes: Only supported in Posh 3.0 and above
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FormatView
 ```yam 
 -FormatView <String>
    Description: Automatically format the Return Object
    Notes: Yaml is only supported in Posh 3.0 and above
    Alias:
    ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'
    
    Required?                    false
    Position?                    7
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


