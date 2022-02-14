# Blugenie
Automated Response and Remediation - there are plenty of powershell frameworks for offense. This is a powershell framework for defense.
The only Response and Remediation Framework in PS today offering complete visibility on user endpoints such as servers, laptops and desktops, 
both stationary and remote, wherever your users may be working from.

You can use this framework for Threat Hunting, automated Response and Remediation also. This framework may also be used for forensic artifact collection except collecting images.

# Overview

## EQL Queries:
- execute any EQL queries
- option to add custom fields along with EQL fields
- run EQL queries on a single machine or multiple systems or all systems on your infrastructure
- get results in YAML or JSON

## Run Yara Rule Files:
- run any of the 100+ yara rule files prebuilt into the tool
- run any arbitrary yara file downloaded from any TI sources including US-CERT
- run yara on one or many systems at the time
- get results in YAML or JSON

## Firewall Audit and Protection:
Display a full list of firewall rules and their attributes for each firewall profile
- Enable / Disable GPO Security
- Enable / Disable Rules (A selected few or all of them)
- Install / Uninstall Rules (A selected few or all of them)
- Query all rules and the entire rule property table
- Configure (Domain, Public, Private) firewall profile status

## Process Audit and Protection:
Display information regarding each process in the process stack for all users including the parent command and full command line used that initialized the execution.
- Query based on all property attributes of any process (in memory or installed on disk)
- Query and Manage based on Signature
- Query and Manage based on Algorithm
  - MACTripleDES
  - MD5
  - RIPEMD160
  - SHA1
  - SHA256
  - SHA384
  - SHA512
- Terminate, Pause, or Restart processes
- Quickly determine what processes are completely running in memory

## Remote Audit and Protection:
Display information of the current remote configuration and accessibility of the remote machine.
- Manage remote host with WMI
- Manage remote host with WinRM
- Enable WinRM with WMI
- Enable / Disable Remote Desktop Protocol (RDP)

## File and Folder Audit and Protection:
Displays file and folder information including
- Algorithm, Signature, File Permissions, and ADS information
- Quick File and Folder search (Faster than the normal search function) even hidden files and folders.  Query an entire OS file system in less than 3 min for any file or folder.
- Remove file(s) and folder(s)
- Query Alternate Data Streams
  - Shows Stream names
  -Shows Stream data
- Query and Manage based on Algorithm
  - MACTripleDES
  - MD5
  - RIPEMD160
  - SHA1
  - SHA256
  - SHA384
  - SHA512
- Convert any variablized path to a literal path
- Export a detailed file and folder (details view snapshot) including
  - Attributes, Date Created, File Size, and Full file name
- Copy files and folders to and from a remote source.
  - Using SMB
  - Using WinRM (even if SMB is disabled)

## Registry Audit and Protection:
Display registry information including
- User profile attributes
- Username
- Profile Path 
- User Hive Path
- User from SID information
- Loaded Shell information
- Load and Unload registry hives
- Convert SID to readable user / service name
- Convert User / Service name to SID
- Export Registry Snapshots (.REG format)

## Network Audit and Protection:
Displays all connections and listening ports and the executable involved in creating each connection
- Terminate a connection and the executable managing it
- Query based on any property attribute
- Convert Foreign Address IP information to Domain Name

## Services Audit and Protection:
Display information regarding each service and child process including the processing command line that was used in the initialize execution.
- Query based on all property attributes of any service
- Query and Manage based on Signature
- Query and Manage based on Algorithm
  - MACTripleDES
  - MD5
  - RIPEMD160
  - SHA1
  - SHA256
  - SHA384
  - SHA512
- Terminate, Pause, or Restart processes
- Start, Stop, Restart, or Remove Services

## Threat Hunt and Protection:
Display information regarding COM Object Hijacking, Auto Run Processes, System Prefect Data, and Most Recently Used (MRU) application and file history.
- Query for possible COM Object Hijacking.  The process searches for (*.EXE, *.DLL, *.AX, *.CPL, and *.OCX) files that can be Hijacked using the registry CLSID.
- Display MRU Activity
- Enable / Disable Windows Prefetching
- Enable / Disable Audit Level Process Tracking
- Enable / Disable Audit Level Process Policy
- Display what programs are configured to run during system boot-up and session logins

## System Information:
Display information regarding Active Directory, GPO, System configuration and hardware
- Display Active Directory Machine Information (Without RSAT)
  - Assigned GPO List
  - System Group Membership
  - Group Members of the System
  - LDAP Container location
  - Default AD Attributes
    - Password Last Set
    - Last Logon Time
    - Logon Count
    - Object Category
    - Is Critical System Object
    - Operating System
    - Last Logon Date
    - Name
    - Bad Password Timeout
    - Service Principle Names
    - Object Class
    - Bad Password Count
    - Sam Account Type
    - Object Created Date
    - Object Changed Date
    - Object SID
    - Last Log off
    - Account Expires
    - Local Policy Flags
    - Container
    - Country Code
    - Primary Group ID
    - DNS Host Name
    - Distinguished name
    - Account expires Date
    - Supported encryption types
    - SAM Account Name
- Display Windows Updates
  - Patches
  - Rollups
  - Service Packs
  - Hotfixes
  - Definition Update Information
  - Live link to Microsoft Information Database for each identified item
- Display System Configuration and Hardware Information for the following items
  - Local Disks
  - Domain
  - System Description
  - Manufacturer
  - Model
  - CPU
  - System Type
  - Primary Owner
  - Logged on users
  - PowerShell Supported Versions
  - Memory
  - Operating System Information
    - Version
    - Installed Date
    - Service Packs
- Dot Net Versions
- System Boot Time
- 3rd Party Application / Tool Installation and Removal
- Download and Install Windows SysInternals Tools from Microsoft
- Install / Uninstall and Configure SysMon Service
- Install / Uninstall and Configure WinLogBeat Service

## Overall Engine Design:
- Run 1 to many managed jobs to thousands of remote systems
- 3 major execution sections will speed up performance on remote systems
    - Pre – Any command(s) processed here are started first and run synchronously
    - Parallel - Any command(s) processed here are started after all the Pre commands have finished.  These commands run in parallel.
    - Post – Any command(s) processed here are started after all the Pre and Parallel commands have finished.  These commands run synchronously
- Can manage Multiple IP ranges in a single job
- Jobs can run from the Console Command Line, BluGenie Management Framework, or a JSON configuration file.  Future support for YAML and XML.
- Over 150 Functions.  For the Full Documentation, Function list, and Tactical Artifacts check out the manual [here](https://docs.blusapphire.io/blugenie)
