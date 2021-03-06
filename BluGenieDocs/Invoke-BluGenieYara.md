# Invoke-BluGenieYara

## SYNOPSIS
Yara Scanner

## SYNTAX
```
Invoke-BluGenieYara [[-ItemToScan] <String[]>] [-Rules <String>] [-RulesSource <String[]>] [-CompiledRules] [-ToolPath <String>] [-Count] [-Tag 
<String>] [-Identifier <String>] [-Negate] [-PrintTags] [-PrintMeta] [-MaxStringsPerRule <Int32>] [-PrintStrings] [-PrintStats] [-PrintNamespace] 
[-Threads <Int32>] [-PrintStringLength <Int32>] [-MaxRules <Int32>] [-Timeout <Int32>] [-Recurse] [-FastScan] [-StasckSize <Int32>] 
[-FailOnWarnings] [-NoWarnings] [-Version] [-CommandHelp] [-ClearGarbageCollecting] [-UseCache] [-CachePath <String>] [-RemoveCache] [-DBName 
<String>] [-DBPath <String>] [-UpdateDB] [-ForceDBUpdate] [-NewDBTable] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-OutYaml] [-FormatView 
<String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-BluGenieYara is a wrapper around the YARA tool.  The Yara tools is designed to help malware researchers identify and classify
malware samples. It’s been called the pattern-matching Swiss Army knife for security researchers (and everyone else).

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP
 ``` 
 ```yam 
 Description: Scan all files under $env:temp directory with any .Yar rules found
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -Recurse
 ``` 
 ```yam 
 Description: Recursive Directory Scan
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Invoke-BGYara -ItemToScan $env:TEMP -Recurse
 ``` 
 ```yam 
 Description: Use the (BG) Alias to run Yara
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Yara -ItemToScan $env:TEMP -Recurse
 ``` 
 ```yam 
 Description: Use the Short Name Alias to run Yara scan
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan "$env:TEMP\AttachmentArchive.msg" -Rules 'Attachment'
 ``` 
 ```yam 
 Description: Run all Rules with Attachment in the name against the .MSG file in the temp direcotry
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan "$env:TEMP\AttachmentArchive.msg" -Rules 'Attachment' -RulesSource Z:\YaraRules\Email
 ``` 
 ```yam 
 Description: Run all Rules with Attachment in the name from a specific source, against the .MSG file in the temp direcotry
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $(Get-Process -Name notepad++ | Select-Object -ExpandProperty ID)
 ``` 
 ```yam 
 Description: Scan a PID
Notes:
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan 'AllPids'
 ``` 
 ```yam 
 Description: Scan all PID using all found .Yar rules
Notes:
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache
 ``` 
 ```yam 
 Description: Cache found objects to disk to not over tax Memory resources
Notes: By default the Cache location is %SystemDrive%\Windows\Temp
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -RemoveCache
 ``` 
 ```yam 
 Description: Remove Cache data
Notes: By default the Cache information is removed right before the data is returned to the caller
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -CachePath $Env:Temp
 ``` 
 ```yam 
 Description: Change the Cache path to the current users Temp directory
Notes: By default the Cache location is %SystemDrive%\Windows\Temp
 ``` 
 
### EXAMPLE 12
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -UseCache -ClearGarbageCollecting
 ``` 
 ```yam 
 Description: Scan large directories and limit the memory used to track data
Notes:
 ``` 
 
### EXAMPLE 13
 ``` 
 Command: Invoke-BluGenieYara -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 14
 ``` 
 Command: Invoke-BluGenieYara -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 15
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Return a detailed function report in an UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 16
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -OutYaml
 ``` 
 ```yam 
 Description: Return a detailed function report in YAML format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 17
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -ReturnObject
 ``` 
 ```yam 
 Description: Return Output as a Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        This parameter is also used with the FormatView
 ``` 
 
### EXAMPLE 18
 ``` 
 Command: Invoke-BluGenieYara -ItemToScan $env:TEMP -ReturnObject -FormatView Yaml
 ``` 
 ```yam 
 Description: Output PSObject information in Yaml format
Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
        Default is set to (None) and normal PSObject.
 ``` 


## PARAMETERS

### ItemToScan
 ```yam 
 -ItemToScan <String[]>
    Description: File(s), Directory, PID, or AllPids Scan
    Notes:  If ItemToScan = "AllPids", every PID on the System will be scanned
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Rules
 ```yam 
 -Rules <String>
    Description: .Yar Rule Names (Filtered with RegEx)
    Notes:  Default is set to '.*'
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                .*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RulesSource
 ```yam 
 -RulesSource <String[]>
    Description: Source path to for your .Yar Rule files
    Notes:  Default Search Paths
    			* $Env:SystemDrive\Windows\Temp
    			* %Current Script Directory%
    			* $Env:Temp
    			This scan is not recursive.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CompiledRules
 ```yam 
 -CompiledRules [<SwitchParameter>]
    Description: Load compiled rules
    Notes:
    Alias: 'CR'
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
    Description:
    Notes: Default is set to  $('{0}\Windows\Temp' -f $env:SystemDrive)
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                $(Join-Path -Path $ToolsDirectory -ChildPath 'Yara')
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Count
 ```yam 
 -Count [<SwitchParameter>]
    Description: Print only number of matches
    Notes:
    Alias: 'C'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Tag
 ```yam 
 -Tag <String>
    Description: Print only rules tagged as TAG
    Notes: tag=TAG
    Alias: 'T'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Identifier
 ```yam 
 -Identifier <String>
    Description: Print only rules named IDENTIFIER
    Notes: identifier=IDENTIFIER
    Alias: 'I'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Negate
 ```yam 
 -Negate [<SwitchParameter>]
    Description: Print only not satisfied rules (negate)
    Notes:
    Alias: 'N'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintTags
 ```yam 
 -PrintTags [<SwitchParameter>]
    Description: Print tags
    Notes:
    Alias: 'PT'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintMeta
 ```yam 
 -PrintMeta [<SwitchParameter>]
    Description: Print metadata
    Notes:
    Alias: 'PM'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxStringsPerRule
 ```yam 
 -MaxStringsPerRule <Int32>
    Description: Set maximum number of strings per rule (default=10000)
    Notes:
    Alias: 'MS'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintStrings
 ```yam 
 -PrintStrings [<SwitchParameter>]
    Description: Print matching strings
    Notes:
    Alias: 'PS'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintStats
 ```yam 
 -PrintStats [<SwitchParameter>]
    Description: Print rules' statistics
    Notes:
    Alias: 'PA'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintNamespace
 ```yam 
 -PrintNamespace [<SwitchParameter>]
    Description: Print rules' namespace
    Notes:
    Alias: 'PN'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Threads
 ```yam 
 -Threads <Int32>
    Description: Use the specified NUMBER of threads to scan a directory
    Notes:
    Alias: 'TR'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### PrintStringLength
 ```yam 
 -PrintStringLength <Int32>
    Description: Print length of matched strings
    Notes:
    Alias: 'PL'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxRules
 ```yam 
 -MaxRules <Int32>
    Description: Abort scanning after matching a NUMBER of rules
    Notes:
    Alias: 'M'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Timeout
 ```yam 
 -Timeout <Int32>
    Description: Abort scanning after the given number of SECONDS
    Notes:
    Alias: 'TO'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Recurse
 ```yam 
 -Recurse [<SwitchParameter>]
    Description: Recursively search directories (follows symlinks)
    Notes:
    Alias: 'R'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FastScan
 ```yam 
 -FastScan [<SwitchParameter>]
    Description: Fast matching mode
    Notes:
    Alias: 'F'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### StasckSize
 ```yam 
 -StasckSize <Int32>
    Description: Set maximum stack size (default=16384)
    Notes:
    Alias: 'SS'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FailOnWarnings
 ```yam 
 -FailOnWarnings [<SwitchParameter>]
    Description: Fail on warnings
    Notes:
    Alias: 'FW'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NoWarnings
 ```yam 
 -NoWarnings [<SwitchParameter>]
    Description: Disable warnings
    Notes:
    Alias: 'NW'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Version
 ```yam 
 -Version [<SwitchParameter>]
    Description: Show version information
    Notes:
    Alias: 'V'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CommandHelp
 ```yam 
 -CommandHelp [<SwitchParameter>]
    Description: Show the Yara command help
    Notes:
    Alias: 'CH'
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
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
    Position?                    named
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
    Position?                    named
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
    Position?                    named
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
    Position?                    named
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


