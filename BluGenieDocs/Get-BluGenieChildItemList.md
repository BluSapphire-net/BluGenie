# Get-BluGenieChildItemList

## SYNOPSIS
Query for a list of files and folders that match a specific pattern

## SYNTAX
```
Get-BluGenieChildItemList [[-SearchPath] <Object>] [-Recurse] [[-FilterType] <String>] [[-Pattern] <Object>] [-Remove] [[-StopWatchCounter] <Int32>] 
[[-SleepTimerSec] <Int32>] [[-Algorithm] <String>] [-Signature] [-Permissions] [-ShowStreamValue] [-ShowProgress] [-ClearGarbageCollecting] 
[-UseCache] [[-CachePath] <String>] [-RemoveCache] [[-DBName] <String>] [[-DBPath] <String>] [-UpdateDB] [-ForceDBUpdate] [-NewDBTable] 
[-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-OutYaml] [[-FormatView] <String>] [<CommonParameters>]
```

## DESCRIPTION
Query for a list of files and folders that match a specific pattern

Fastest search is based on the filter type set to "Name" this is default
Slower search is based on all other filter type properties (Reference the Parameter FilterType to review)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath C:\Temp -Recurse -Pattern '^notepad\.\w{3}$'
 ``` 
 ```yam 
 Description: Search C:\Temp and all sub directories for any file or directory named Notepad.*
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath C:\Temp,C:\Trash,C:\Users -Recurse -Pattern '^notepad\.\w{3}$'
 ``` 
 ```yam 
 Description: Search multiple directories and all sub directories for any file or directory named Notepad.*.
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath C:\Temp,C:\Trash,C:\Users -Recurse -Pattern '0e61079d3283687d2e279272966ae99d' -FilterType
 ``` 
 ```yam 
 HashDescription: Search multiple directories and the sub directories for a Hash value determined by the default Algorithm type of MD5
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath C:\Windows -Pattern '^notepad\.\w{3}$' -Permissions -ShowStreamValue -Signature
 ``` 
 ```yam 
 Description: Query the C:\Windows dir for a file or directory named Notepad.* and return all associated Permissions, Alternate Data
Streams, and Signature information
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse
 ``` 
 ```yam 
 Description: Search for all file(s) under (All Temp Locations for each user and the system) and sub directories
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache
 ``` 
 ```yam 
 Description: Cache found objects to disk to not over tax Memory resources
Notes: By default the Cache location is %SystemDrive%\Windows\Temp
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -RemoveCache
 ``` 
 ```yam 
 Description: Remove Cache data
Notes:
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -CachePath $Env:Temp
 ``` 
 ```yam 
 Description: Change the Cache path to the current users Temp directory
Notes: By default the Cache location is %SystemDrive%\Windows\Temp
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-ChildItem -path $env:temp -File | Get-BluGenieChildItemList -SearchPath Temp -Recurse -UseCache -ClearGarbageCollecting
 ``` 
 ```yam 
 Description: Scan large directories and limit the memory used to track data
Notes:
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath 'Temp' -Recurse -FilterType NameIncludeAll -UpdateDB
 ``` 
 ```yam 
 Description: Search every user and system Temp directory for all normal file information including hash and save the return to a DB
Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Get-BluGenieChildItemList -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 12
 ``` 
 Command: Get-BluGenieChildItemList -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 13
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Return a detailed function report in an UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 14
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -OutYaml
 ``` 
 ```yam 
 Description: Return a detailed function report in YAML format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 15
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -ReturnObject
 ``` 
 ```yam 
 Description: Return Output as a Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
This parameter is also used with the ForMat
 ``` 
 
### EXAMPLE 16
 ``` 
 Command: Get-BluGenieChildItemList -SearchPath Temp -Recurse -ReturnObject -FormatView Yaml
 ``` 
 ```yam 
 Description: Output PSObject information in Yaml format
Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml', 'XML')
Default is set to (None) and normal PSObject.
 ``` 


## PARAMETERS

### SearchPath
 ```yam 
 -SearchPath <Object>
    Description: The path to start your search from
    Notes:
            If you specify "Temp" in the SearchPath field all the %SystemDrive%\Users\* Temp directories and the
            %SystemRoot%\Temp will be searched only.
    
            If you specify "AllUsers" in the SearchPath path all User Profiles from %SystemDrive%\Users will be
            prefixed to the rest of the path.
                Example:  -SearchPath 'AllUsers\AppData\Roaming'
    
                Output:     C:\Users\Administrator\AppData\Roaming
                            C:\Users\User1\AppData\Roaming
                            C:\Users\User2\AppData\Roaming
                            C:\Users\User3\AppData\Roaming
                            C:\Users\User4\AppData\Roaming
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                $(Get-Location).Path
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Recurse
 ```yam 
 -Recurse [<SwitchParameter>]
    Description: Recurse through subdirectories
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FilterType
 ```yam 
 -FilterType <String>
    Description:  Which property to filter by
    Notes:
            Filter Option = "Path"					-   Path Query with general file information
            Filter Option = "PathIncludeAll"        -   Path Query with extended file metadata
            Filter Option = "Name"                 	-   Name Query with general file information
            Filter Option = "NameIncludeAll"        -   Name Query with extended file metadata
            Filter Option = "Type"             		-   File Type Query with general file information
            Filter Option = "TypeIncludeAll"        -   File Type Query with extended file metadata
            Filter Option = "Hash"                  -   Hash Value Query with general file information
            Filter Option = "HashIncludeAll"		-	Hash Value Query with extended file metadata
            Filter Option = "ADS"					-	Alternate Data Stream Query (True Only) with general file information
            Filter Option = "ADSIncludeAll"		    -	Alternate Data Stream Query (True Only) with extended file metadata
    
            Default is a "Name" Query
    Alias:
    ValidateSet: 'Path','PathIncludeAll','Name','NameIncludeAll','Type','TypeIncludeAll','Hash','HashIncludeAll','ADS','ADSIncludeAll'
    
    Required?                    false
    Position?                    2
    Default value                Name
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Pattern
 ```yam 
 -Pattern <Object>
    Description: Search Pattern using RegEx
    Notes: Using -SearchHidden will convert the Pattern to RegEx Automatically but without the comma or
    the -SearchHidden the -Pattern is viewed as as a Command Console Search pattern.  You can use (*) wildcards.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                .*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Remove
 ```yam 
 -Remove [<SwitchParameter>]
    Description: Remove the File(s) and Directory(s) found
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### StopWatchCounter
 ```yam 
 -StopWatchCounter <Int32>
    Description: Determine how many times the recheck for removing a file or directory happenes.  By default (12) times with a 5 second sleep
    Notes:  Determine how many times the recheck for removing a file or directory happenes.  By default (12) times with a 5 second sleep
            inbetween which is (60 seconds total)
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    4
    Default value                12
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SleepTimerSec
 ```yam 
 -SleepTimerSec <Int32>
    Description: Determine the Sleep time in seconds before the next recheck.  By default this is a 5 second sleep with 12 rechecks
    Notes:  Determine the Sleep time in seconds before the next recheck.  By default this is a 5 second sleep with 12 rechecks which is
            (60 seconds total)
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    5
    Default value                5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Algorithm
 ```yam 
 -Algorithm <String>
    Description:  Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
    Notes:  The acceptable values for this parameter are:
    
            - SHA1
            - SHA256
            - SHA384
            - SHA512
            - MACTripleDES
            - MD5 = (Default)
            - RIPEMD160
    Alias:
    ValidateSet: 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'
    
    Required?                    false
    Position?                    6
    Default value                MD5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Signature
 ```yam 
 -Signature [<SwitchParameter>]
    Description: Query Signature information
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Permissions
 ```yam 
 -Permissions [<SwitchParameter>]
    Description: Query Access Control List (ACL) information
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ShowStreamValue
 ```yam 
 -ShowStreamValue [<SwitchParameter>]
    Description: If an Alternate Data Stream is found display the Stream data based on each streams name and stream content.
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ShowProgress
 ```yam 
 -ShowProgress [<SwitchParameter>]
    Description: Display file count information to the Host to show query progress
    Notes:
    Alias:
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
    Position?                    7
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
    Position?                    8
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
    Position?                    9
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
    Position?                    10
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


