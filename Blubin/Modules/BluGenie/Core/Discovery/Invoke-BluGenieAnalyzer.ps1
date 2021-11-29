#region Invoke-BluGenieAnalyzer (Function)
Function Invoke-BluGenieAnalyzer
{
<#
    .SYNOPSIS
        BGAnalyzer is a C# project that performs a number of security oriented host-survey "safety checks" relevant from both offensive and
        defensive security perspectives.

    .DESCRIPTION
        Invoke-BluGenieAnalyzer is a wrapper around the BGAnalyzer tool.  BGAnalyzer is a C# project that performs a number of security oriented
        host-survey "safety checks" relevant from both offensive and defensive security perspectives.

    .PARAMETER FilterType
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

	.PARAMETER FilterData
		Description: Return Data (Filtered with RegEx)
		Notes:  Default is set to '.*'
		Alias:
		ValidateSet:

    .PARAMETER Full
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

    .PARAMETER AddException
		Description: Add an Exception to Windows Defender to allow the .NET process to run
		Notes: Windows Defender does not allow for adding an Exception and running the newly excluded process in the same runspace.
                If you use the -AddException parameter (No other option will process)  There is also no return.  The script just adds the
                exception and ends.

                Running the command for a 2nd time without the -AddException parameter will execute the .NET process without issue.

                The exception is removed by default.
		Alias:
		ValidateSet:

    .PARAMETER LeaveException
		Description: Leave the Windows Defender Exception for continues runs at a later point
		Notes: Windows Defender does not allow for adding an Exception and running the newly excluded process in the same runspace.
                If you use the -AddException parameter (No other option will process)  There is also no return.  The script just adds the
                exception and ends.

                Running the command for a 2nd time without the -AddException parameter will execute the .NET process without issue.

                The exception is removed by default.  However if you use this parameter -LeaveException the Exception is not removed.
		Alias:
		ValidateSet:

    .PARAMETER ToolPath
		Description:  This is the path to the BGAnalyzer tool.
		Notes: There are 2 subfolders.
                .\3.5 which houses the .NET 3.5 version of the binary
                .\4.0 wihch houses the .NET 4.0 version of the binary

                This is automatically selected based on PowerShell's supported CRL Version.
		Alias:
		ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER UseCache
        Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER RemoveCache
        Description: Remove Cache data on completion
        Notes: Cache information is removed right before the data is returned to the calling process
        Alias:
        ValidateSet:

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER DBName
        Description: Database Name (Without extention)
        Notes: The default name is set to 'BluGenie'
        Alias:
        ValidateSet:

    .PARAMETER DBPath
        Description: Path to either Save or Update the Database
        Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
        Alias:
        ValidateSet:

    .PARAMETER UpdateDB
        Description: Save return data to the Sqlite Database
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ForceDBUpdate
        Description: Force an update of the return data to the Sqlite Database
        Notes: By default only new items are saved.  The primary key is ( FullName )
        Alias:
        ValidateSet:

    .PARAMETER NewDBTable
        Description: Delete and Recreate the Database Table
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ClearGarbageCollecting
        Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
        Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
        Alias:
        ValidateSet:

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

    .PARAMETER OutYaml
        Description: Return detailed information in Yaml Format
        Notes: Only supported in Posh 3.0 and above
        Alias:
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
        Command: Invoke-BGAnalyzer -AddException
        Description: Use this command to update the Windows Defender Exception list to allow for the BGAnalyzer .NET application to run
        Notes: Some .NET code has been used in other open source projects and Microsoft has flagged any scans based on similar techniques
                to be potentially malicious.

    .EXAMPLE
        Command: Invoke-BGAnalyzer
        Description: Use this BluGenie reference Alias to run BGAnalyzer and gather all security scan inventory
        Notes:

    .EXAMPLE
        Command: Invoke-BGAnalyzer -LeaveException
        Description: Use this command to gather all security scan inventory and leave the Windows Defender exception for future scans
        Notes: By default the exception is removed after each execution

    .EXAMPLE
        Command: Invoke-BluGenieAnalyzer
        Description: Use this command to run BGAnalyzer and gather all security scan inventory
        Notes:

    .EXAMPLE
        Command: Invoke-BGAnalyzer
        Description: Use this BluGenie reference Alias to run BGAnalyzer and gather all security scan inventory
        Notes:

    .EXAMPLE
        Command: Invoke-Analyzer
        Description: Use this Long-hand Alias to run BGAnalyzer and gather all security scan inventory
        Notes:

    .EXAMPLE
        Command: Invoke-Analyzer -Full
        Description: Use this command to Expand on the Data returned for LocalGroups, Processes, ScheduledTasks, Services, and the WindowsFirewall
        Notes:  By default this option is not set

    .EXAMPLE
        Command: Invoke-BGAnalyzer -FilterType 'Install|Update'
        Description: Use this command to filter the Query type for Installed Products and Windows Updates
        Notes: Check the filter parameter to see all the filter options.  The filter uses Regex.

    .EXAMPLE
        Command: Invoke-BGAnalyzer -FilterType 'Install' -FilterData 'Python'
        Description: Use this command to filter for a specific product installation.
        Notes: You can change the type and data filters to select specific information you need.

    .EXAMPLE
        Command: Invoke-BGAnalyzer -FilterType 'Install' -FilterData 'Python' -UseCache -CachePath $Env:Temp
        Description: Use the command to Cache the gathered information to a file on the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
        Command: Invoke-BGAnalyzer -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BGAnalyzer -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-Analyzer -OutUnEscapedJSON
        Description: Use this command to Return a detailed report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-Analyzer -OutYaml
        Description: Use this command to Return a detailed report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: $Info = Invoke-Analyzer -ReturnObject
        Description: Use this command to capture the return data as a Powershell Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Invoke-Analyzer -FilterType 'install' -FilterData 'python' -ReturnObject -FormatView CSV
        Description: Use this command to Output the return data in CSV format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        Ã¢â‚¬Â¢ [Original Author]
            o    Michael Arroyo
        Ã¢â‚¬Â¢ [Original Build Version]
            o    21.04.1901 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        Ã¢â‚¬Â¢ [Latest Author]
            o
        Ã¢â‚¬Â¢ [Latest Build Version]
            o
        Ã¢â‚¬Â¢ [Comments]
            o
        Ã¢â‚¬Â¢ [PowerShell Compatibility]
            o    2,3,4,5.x
        Ã¢â‚¬Â¢ [Forked Project]
            o
        Ã¢â‚¬Â¢ [Links]
            o   https://github.com/GhostPack/Seatbelt
        Ã¢â‚¬Â¢ [Dependencies]
            o    Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o    Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o    New-BluGenieUID or New-UID - Create a New UID
            o    ConvertTo-Yaml - ConvertTo Yaml
            o    Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o    ConvertFrom-Yaml - Convert From Yaml
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 21.04.1901Ã¢â‚¬Â¢ [Michael Arroyo] Function Template
                Ã¢â‚¬Â¢ [Michael Arroyo] Posted

#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Invoke-Analyzer','Invoke-BGAnalyzer')]
    #region Parameters
        Param
        (
            [String]$FilterType = '.*',

            [String]$FilterData = '.*',

            [Switch]$Full,

            [Switch]$AddException,

            [Switch]$LeaveException,

            [String]$ToolPath = $(Resolve-Path -Path $ToolsDirectory | Select-Object -ExpandProperty Path),

            [Switch]$ClearGarbageCollecting,

            [Switch]$UseCache,

            [String]$CachePath = $('{0}\Windows\Temp\{1}.log' -f $env:SystemDrive, $(New-BluGenieUID)),

            [Switch]$RemoveCache,

            [String]$DBName = 'BluGenie',

            [String]$DBPath = $('{0}\BluGenie' -f $env:ProgramFiles),

            [Switch]$UpdateDB,

            [Switch]$ForceDBUpdate,

            [Switch]$NewDBTable,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [Switch]$OutYaml,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')]
            [string]$FormatView = 'None'
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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['InvokeSB'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeSB']['Items'] = @()
        $HashReturn['InvokeSB']['FailedToConvert'] = @()
        $HashReturn['InvokeSB']['Comment'] = @()
        $HashReturn['InvokeSB']['ToolPath'] = ''
        $HashReturn['InvokeSB']['ToolCheck'] = 'FALSE'
        $HashReturn['InvokeSB']['CommandLine'] = ''
        $HashReturn['InvokeSB'].StartTime = $($StartTime).DateTime
        $HashReturn['InvokeSB']['CommandLine'] = @()
        $HashReturn['InvokeSB']['ParameterSetResults'] = @()
        $HashReturn['InvokeSB']['CachePath'] = $CachePath
    #endregion Create Return hash

    #region Parameter Set Results
        If
        (
            $PSBoundParameters
        )
        {
            $HashReturn['InvokeSB']['ParameterSetResults'] = $PSBoundParameters
        }
    #endregion Parameter Set Results

    #region Dynamic parameter update
        If
        (
            $PSVersionTable.PSVersion.Major -eq 2
        )
        {
            $IsPosh2 = $true
        }
        Else
        {
            $IsPosh2 = $false
        }

        If
        (
            $PSVersionTable.CLRVersion.Major -ge 4
        )
        {
            $DotNet4 = $true
        }

        Switch
        (
            $null
        )
        {
            {$FormatView -eq 'Yaml' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$FormatView -match 'JSON' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$OutYaml -and $IsPosh2}
            {
                $OutYaml -eq $false
                $FormatView -eq 'None'
            }

            {$FormatView -eq 'Yaml'}
            {
                $UseCache = $true
            }

            { -Not $($ClearGarbageCollecting -eq $false)}
            {
                $ClearGarbageCollecting = $true
            }

            { $ForceDBUpdate }
            {
                $UpdateDB = $true
            }

            { $NewDBTable }
            {
                $UpdateDB = $true
            }

            { $IsPosh2 }
            {
                $UpdateDB = $false
            }
        }
    #endregion Dynamic parameter update

    #region Build Data Table Hash Table
        If
        (
            $UpdateDB
        )
        {
            #region Create Hash Table
                $HSqlite = @{}
            #endregion Create Hash Table

            #region Set Database Full Path
                $HSqlite.DBPath = $DBPath
                $HSqlite.DBName = $DBName
                $HSqlite.Database = Join-Path -Path $($HSqlite.DBPath) -ChildPath $('{0}.SQLite' -f $($HSqlite.DBName))
            #endregion Set Database Full Path

            #region Table Name
                $HSqlite.TableName = 'BGAnalyzer'
            #endregion Table Name

            #region Set Column Information
                #***Sample Column Names (Please Change)***
                $HSqlite.TableColumns = 'Type TEXT,
                Data TEXT'
            #endregion Set Column Information

            #region Set Create Table SQL String
                $HSqlite.CreateTableStr = $('CREATE TABLE IF NOT EXISTS {0} ({1})' -f $HSqlite.TableName, $HSqlite.TableColumns)
            #endregion Set Create Table SQL String

            #region Drop Table SQL String
                $HSqlite.DropTableStr = $('DROP TABLE IF EXISTS {0}' -f $HSqlite.TableName)
            #endregion Drop Table SQL String

            #region Set Check Table SQL String
                $HSqlite.CheckTables = $('PRAGMA table_info({0})' -f $HSqlite.TableName)
            #endregion Set Check Table SQL String

            #region Create DB Table
                If
                (
                    -Not $(Test-Path -Path $DBPath)
                )
                {
                    $null = New-Item -Path  $DBPath -ItemType Directory -Force
                }

                #region New DB Table
                    If
                    (
                        $NewDBTable
                    )
                    {
                        Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.DropTableStr
                    }
                #endregion New DB Table

                Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.CreateTableStr
            #endregion Create DB Table
        }
    #endregion Build Data Table Hash Table

    #region Main
        $OldErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'SilentlyContinue'

        #region Run BGAnalyzer
            $FileOutput = $CachePath -replace '\.log$','.json'
            $CommandOptions = $('-group=all -q -outputfile="{0}"' -f $fileOutput)
            $Error.Clear()
            $ToolName = 'BGAnalyzer.exe'

            If
            (
                $DotNet4
            )
            {
                $ToolPath = Join-Path -Path $ToolPath -ChildPath "BGAnalyzer\4.0\$ToolName"
            }
            Else
            {
                $ToolPath = Join-Path -Path $ToolPath -ChildPath "BGAnalyzer\3.5\$ToolName"
            }

            $HashReturn['InvokeSB']['ToolPath'] = $ToolPath

            If
            (
                Test-Path -Path $ToolPath
            )
            {
                $HashReturn['InvokeSB']['ToolCheck'] = 'TRUE'
            }

            $HashReturn['InvokeSB']['CommandLine'] = $('{0} {1}' -f $ToolPath, $CommandOptions)
            $Error.Clear()

            If
            (
                $HashReturn['InvokeSB']['ToolCheck']
            )
            {
                If
                (
                    $(Get-Command | Where-Object -FilterScript {  $_.Name -eq 'Set-MpPreference'}) -and $AddException# -and $($SBHashes -Contains $(Get-BGHashInfo -Path $ToolPath))
                )
                {
                    $OrgMPPreferences += @(Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ExclusionPath)
                    $CurMPPreferences = $OrgMpPreferences
                    $CurMPPreferences += $ToolPath
                    Set-MpPreference -ExclusionPath $($CurMPPreferences | Select-Object -Unique) -Force -ErrorAction SilentlyContinue
                }

                If
                (
                    $AddException
                )
                {
                    Return
                }

                Try
                {
                    If
                    (
                        $Full
                    )
                    {
                        $CommandOptions = $('-group=all -full -q -outputfile="{0}"' -f $fileOutput)
                        Start-Process -FilePath $(Split-Path -Path $ToolPath -Leaf) `
                            -WorkingDirectory $(Split-Path -Path $ToolPath -Parent) `
                            -ArgumentList $CommandOptions -Wait -WindowStyle Hidden -ErrorAction Stop
                    }
                    Else
                    {
                        Start-Process -FilePath $(Split-Path -Path $ToolPath -Leaf) `
                            -WorkingDirectory $(Split-Path -Path $ToolPath -Parent) `
                            -ArgumentList $CommandOptions -Wait -WindowStyle Hidden -ErrorAction Stop
                    }
                }
                Catch
                {
                    If
                    (
                        $Error
                    )
                    {
                        $Error | ForEach-Object `
                        -Process `
                        {
                            $CurError = $_
                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                            $HashReturn['InvokeSB']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                            Name = 'Exception'
                                                                                                            Expression = {$CurErrorMsg}
                                                                                                           },
                                                                                                           FullyQualifiedErrorId,
                                                                                                           ScriptStackTrace)
                        }
                    }
                }
            }
            Else
            {
                Write-Error -Exception 'Tool could not be found' -ErrorAction SilentlyContinue
                If
                (
                    $Error
                )
                {
                    $Error | ForEach-Object `
                    -Process `
                    {
                        $CurError = $_
                        $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                        $HashReturn['InvokeSB']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                        Name = 'Exception'
                                                                                                        Expression = {$CurErrorMsg}
                                                                                                       },
                                                                                                       FullyQualifiedErrorId,
                                                                                                       ScriptStackTrace)
                    }
                }
            }
        #endregion Run BGAnalyzer

        #region Check Process to make sure it has completed
            If
            (
                Get-Process | Where-Object -FilterScript { $_.Name -eq $($ToolName -split '\.')[0] }
            )
            {
                do
                {
                    Start-Sleep -Seconds 60
                }
                while
                (
                    Get-Process | Where-Object -FilterScript { $_.Name -eq $($ToolName -split '\.')[0] }
                )
            }
        #endregion Check Process to make sure it has completed

        #region Cleanup Defender Exclusion
            If
            (
                $(Get-Command | Where-Object -FilterScript {  $_.Name -eq 'Remove-MpPreference'})# -and $($SBHashes -Contains $(Get-BGHashInfo -Path $ToolPath))
            )
            {
                If
                (
                    $( -Not $LeaveException) -and $(-Not $AddException)
                )
                {
                    #$OrgMPPreferences = @(Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ExclusionPath | `
                    #    Where-Object -FilterScript { $_ -Notmatch $ToolName})
                    #Set-MpPreference -ExclusionPath $($OrgMPPreferences | Select-Object -Unique) -Force
                    Remove-MpPreference -ExclusionPath $ToolPath -Force -ErrorAction SilentlyContinue
                }
            }
        #endregion Cleanup Defender Exclusion

        #region Parse JSON Return
            $error.Clear()
            If
            (
                Test-Path -Path $FileOutput
            )
            {
                #region Get Content and Split file
                    $File = $(Get-Content -Path $FileOutput)
                    $Sep = $file -split "`n"
                #endregion Get Content and Split file

                #region Convert JSON to Posh Object
                    $JsonArray = @()
                    $FailedtoConvert = @()

                    ForEach ( $CurSection in $Sep)
                        {
                            Try
                            {
                                $JsonArray += $($CurSection -Replace '\"Type\":\"Seatbelt\.Commands\.','"Type":"') | `
                                    ConvertFrom-Json -ErrorAction Stop
                            }
                            Catch
                            {
                                $FailedtoConvert += $CurSection
                            }
                        }
                #endregion Convert JSON to Posh Object
            }
            Else
            {
                Write-Error -Exception 'Output file was not created.  Process failed to run' -ErrorAction SilentlyContinue

                If
                (
                    $Error
                )
                {
                    $Error | ForEach-Object `
                    -Process `
                    {
                        $CurError = $_
                        $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                        $HashReturn['InvokeSB']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                        Name = 'Exception'
                                                                                                        Expression = {$CurErrorMsg}
                                                                                                       },
                                                                                                       FullyQualifiedErrorId,
                                                                                                       ScriptStackTrace)
                    }
                }
            }
        #endregion Parse JSON Return

        #region Remove Garbage Collection
            $File = $null
            $Sep = $null
            If
            (
                Test-Path -Path $FileOutput
            )
            {
                Remove-Item -Path $FileOutput -Force -ErrorAction SilentlyContinue
            }

            If
            (
                $ClearGarbageCollecting
            )
            {
                    $null = Clear-BlugenieMemory
            }
        #endregion Remove Garbage Collection

        #region Item Information
            If
            (
                $UseCache -and $(-Not $RemoveCache)
            )
            {
                $JsonArray | Where-Object -FilterScript { $_.Type -Match $FilterType -and $_.Data -Match $FilterData } | `
                    Sort-Object -Property Type | ConvertTo-Yaml | Out-File -FilePath $CachePath -Force
            }

            $HashReturn['InvokeSB']['Items'] = $($JsonArray | `
                Where-Object -FilterScript { $_.Type -Match $FilterType -and $_.Data -Match $FilterData } | Sort-Object -Property Type)

            If
            (
                $FailedtoConvert.Count -gt 0
            )
            {
                $HashReturn['InvokeSB']['FailedToConvert'] = $FailedtoConvert
            }
        #endregion Item Information

        #region Update DB
            If
            (
                $UpdateDB
            )
            {
                If
                (
                    $ForceDBUpdate
                )
                {
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable `
                        $($JsonArray | Out-DataTable) `
                        -Table $HSqlite.TableName -Confirm:$false -ConflictClause Replace
                }
                Else
                {
                    Invoke-SQLiteBulkCopy -DataSource $HSqlite.Database -DataTable `
                        $($JsonArray | Out-DataTable) `
                        -Table $HSqlite.TableName -Confirm:$false -ConflictClause Ignore
                }
            }
        #endregion Update DB
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeSB'].EndTime = $($EndTime).DateTime
        $HashReturn['InvokeSB'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
            Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Remove Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['InvokeSB'].Remove('StartTime')
            $null = $HashReturn['InvokeSB'].Remove('ParameterSetResults')
            $null = $HashReturn['InvokeSB'].Remove('CachePath')
            $null = $HashReturn['InvokeSB'].Remove('EndTime')
            $null = $HashReturn['InvokeSB'].Remove('ElapsedTime')
            $null = $HashReturn['InvokeSB'].Remove('CommandLine')
            $null = $HashReturn['InvokeSB'].Remove('ToolPath')
            $null = $HashReturn['InvokeSB'].Remove('ToolCheck')
        }

        #region Output Type
            $ResultSet = $($HashReturn['InvokeSB']['Items'])

            switch
            (
                $Null
            )
            {
                #region Beautify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 5 | ForEach-Object -Process { [regex]::Unescape($_) })
                    }
                #endregion Beautify the JSON return and not Escape any Characters

                #region Yaml Output of Hash Information
                    { $OutYaml }
                    {
                        Return $($HashReturn | ConvertTo-Yaml)
                    }
                #endregion Yaml Output of Hash Information

                #region Return a PowerShell Object
                    { $ReturnObject }
                    {
                        #region Switch FormatView
                            switch
                            (
                                $FormatView
                            )
                            {
                                #region Table
                                    'Table'
                                    {
                                        Return $($ResultSet | Format-Table -AutoSize -Wrap)
                                    }
                                #endregion Table

                                #region CSV
                                    'CSV'
                                    {
                                        Return $($ResultSet | ConvertTo-Csv -NoTypeInformation)
                                    }
                                #endregion CSV

                                #region Yaml
                                    'Yaml'
                                    {
                                        Return $($ResultSet | ConvertTo-Yaml)
                                    }
                                #endregion Yaml

                                #region CustomModified
                                    'CustomModified'
                                    {
                                        Return $($ResultSet | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
                                    }
                                #endregion CustomModified

                                #region Custom
                                    'Custom'
                                    {
                                        Return $($ResultSet | Format-Custom)
                                    }
                                #endregion Custom

                                #region JSON
                                    'JSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10)
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                            -Process `
                                            {
                                                [regex]::Unescape($_)
                                            }
                                        )
                                    }
                                #endregion OutUnEscapedJSON

                                #region Default
                                    Default
                                    {
                                        Return $ResultSet
                                    }
                                #endregion Default
                            }
                        #endregion Switch Statement RegEx
                    }
                #endregion Return a PowerShell Object

                #region Default
                    Default
                    {
                        Return $HashReturn
                    }
                #endregion Default
            }
        #endregion Output Type
    #endregion Output
}
#endregion Invoke-BluGenieAnalyzer (Function)