# Get-BluGenieProcessList

## SYNOPSIS
Get a full list of Processes

## SYNTAX
```
Get-BluGenieProcessList [[-FilterType] <String>] [[-Pattern] <String>] [[-Managetype] <String>] [[-LazyPathSearch]] [[-Algorithm] <String>] 
[[-Walkthrough]] [[-Signature]] [[-NotMatch]] [-ClearGarbageCollecting] [-UseCache] [-CachePath <String>] [-RemoveCache] [-DBName <String>] [-DBPath 
<String>] [-UpdateDB] [-ForceDBUpdate] [-NewDBTable] [[-ReturnObject]] [[-OutUnEscapedJSON]] [-OutYaml] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Get a full list of Processes and all linked properties including parent processes and process owner information

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieProcessList
 ``` 
 ```yam 
 Description: Return all the processes on the local machine
Notes: The default Hash Algorithm is (MD5)
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieProcessList -FilterType NoFilter -Algorithm SHA256
 ``` 
 ```yam 
 Description: Return all the processes on the local machine (default option) with a differnet Hash type
Notes: The Hash Algorithm is (SHA256)
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieProcessList -FilterType NullPaths -Algorithm SHA512
 ``` 
 ```yam 
 Description: Return all the processes on the local machine that do not have a valid path
Notes: The Hash Algorithm is (SHA512)
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieProcessList -FilterType Name -Pattern shell
 ``` 
 ```yam 
 Description: Return all the processes on the local machine with a Name field that matches the RegEx pattern
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$'
 ``` 
 ```yam 
 Description: This will return all the processes on the local machine with a Name field that matches the RegEx pattern with an Exact Match
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$' -LazyPathSearch
 ``` 
 ```yam 
 Description: Return all the processes with an Exact Match and validate path with LazyPathSearch
Notes: By default the process path will be searched for under the entire System drive.  This is a (Slow Search).
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieProcessList -FilterType Name -Pattern '^powershell_ise\.exe$' -Managetype Stop
 ``` 
 ```yam 
 Description: Return all the processes with an Exact Match and Terminate the process
Notes: -Managetype can also [Suspend and Resume]
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieProcessList -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-BluGenieProcessList -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Get-BluGenieProcessList -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters
Notes:
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Get-BluGenieProcessList -ReturnObject
 ``` 
 ```yam 
 Description: The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
Notes:
 ``` 


## PARAMETERS

### FilterType
 ```yam 
 -FilterType <String>
    Description: Which property to filter by
    Notes:
        • Filter Option
    o	"Caption" Search the Caption Field
    o	"CommandLine" Search the CommandLine Field
    o	"Name" Search the Name Field
    o	"ProcessId" Search the ProcessID Field
    o	"Path" Search the Path Field
    o	"ProcessOwner" Search the ProcessOwner Field
    o	"Process_Hash" Search the Process_Hash Field
    o	"NoFilter" Return all items with no specific search terms processed
    o	"NullPaths" Return all items with no valid Path found
    o	"Signature_Comment" Display error message while pulling Signature Information
    [Note:  This is only available if you use the -Signature switch]
    o	"Signature_FileVersion" File Version and OS Build information in part of the OS
    [Note:  This is only available if you use the -Signature switch]
    o	"Signature_Description" The description of the files signature [Note:  This is only available if you use the -Signature switch]
    o	"Signature_Date" Date when the file was signed [Note:  This is only available if you use the -Signature switch]
    o	"Signature_Company" The company signing the file [Note:  This is only available if you use the -Signature switch]
    o	"Signature_Publisher" The Publisher signing the file [Note:  This is only available if you use the -Signature switch]
    o	"Signature_Verified" Verification ( Signed / UnSigned / Null ) [Note:  This is only available if you use the -Signature switch]
    Alias:
    ValidateSet: 'Caption','CommandLine','Name','ProcessId','Path','ProcessOwner','Process_Hash','NullPaths','Signature_Comment','Signature_FileVersi
    on','Signature_Description','Signature_Date','Signature_Company','Signature_Publisher','Signature_Verified'
    
    Required?                    false
    Position?                    2
    Default value                Name
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Pattern
 ```yam 
 -Pattern <String>
    Description: Search Pattern using RegEx
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                .*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Managetype
 ```yam 
 -Managetype <String>
    Description: Manage the behavior of the process (Suspend, Resume, Stop)
    Notes:
    Alias:
    ValidateSet: 'Suspend','Resume','Stop'
    
    Required?                    false
    Position?                    4
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### LazyPathSearch
 ```yam 
 -LazyPathSearch [<SwitchParameter>]
    Description:  Search for processes that do not have a valid path
    Notes: The Search is only under any directory in the system environment path variable.
    By default the process would be searched for under the System drive.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    5
    Default value                False
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
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
    Notes:
    Alias: Help
    ValidateSet:
    
    Required?                    false
    Position?                    7
    Default value                False
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
    Position?                    8
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NotMatch
 ```yam 
 -NotMatch [<SwitchParameter>]
    Description: This switch will filter out what items you don't want to query for.
    Notes: The search string is assigned to the (Pattern) property.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    9
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
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Description: Return information as an Object
    Notes: By default the data is returned as a Hash Table
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    10
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Description: Removed UnEsacped Char from the JSON information.
    Notes: This will beautify json and clean up the formatting.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    11
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


