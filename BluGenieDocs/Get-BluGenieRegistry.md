# Get-BluGenieRegistry

## SYNOPSIS
Searches the registry for a specified text pattern.

## SYNTAX
```
Get-BluGenieRegistry [[-StartKey] <String>] [[-Pattern] <String>] [[-ExcludePattern] <String>] [-MatchKey] [-MatchValueName] [-MatchData] 
[-RootKeyOnly] [-NotMatch] [-ExactMatch] [-Remove] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Searches the registry for a specified text pattern. Supports searching for any combination of key names, value names, and/or value data. 
The text pattern is a case-insensitive regular expression.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly
 ``` 
 ```yam 
 Description: Query Keys Only, Process the Root with No Sub Keys, Using the StartKey Param, Using the Short Hand Hive name
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run'
 ``` 
 ```yam 
 Description: Specify a specific pattern to search for, Query Keys Only, Process the Root with No Sub Keys
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'
 ``` 
 ```yam 
 Description: Specify a specific pattern to search for while using an Exclude pattern, Query Keys Only, Process the Root with No Sub Keys
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'  -ReturnObject
 ``` 
 ```yam 
 Description: Return Data as an Object
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'  -ReturnObject -FormatView csv
 ``` 
 ```yam 
 Description: Return Data as an Object, Reformat the Object as CSV,JSON,CustomObject,UnEscapedJSON.
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly
 ``` 
 ```yam 
 Description: Query Keys Only, Process the Root with No Sub Keys, Using the Path Param, Using the Long Name Hive Name
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths'
 ``` 
 ```yam 
 Description: Query Value Names (Default), Process Sub Keys, Using the Long Name Hive Name
Notes:
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths' -MatchKey -Pattern 'Write' -Remove
 ``` 
 ```yam 
 Description: Query Key Names, Process Sub Keys, Using the Long Name Hive Name, Remove Keys Found
Notes:
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths' -MatchData -Pattern 'Word' -Remove
 ``` 
 ```yam 
 Description: Query Data Values, Process Sub Keys, Using the Long Name Hive Name, Remove ValueNames Found
Notes:
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -MatchValueName -Pattern '(?=.*Auto)(?=.*Logon)' -ExcludePattern 'Sid|Count'
 ``` 
 ```yam 
 Description: RegEx Search Pattern and Exclude Pattern
Notes:
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -OutUnEscapedJSON -MatchValueName -Pattern '(?=.*Auto)(?=.*Logon)' -ExcludePattern 'Sid|Count'
 ``` 
 ```yam 
 Description: RegEx Search Pattern and Exclude Pattern, Output UnEscaped JSON
Notes:
 ``` 
 
### EXAMPLE 12
 ``` 
 Command: Get-BluGenieRegistry -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 13
 ``` 
 Command: Get-BluGenieRegistry -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 14
 ``` 
 Command: Get-BluGenieRegistry -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Get-BluGenieRegistry and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 15
 ``` 
 Command: Get-BluGenieRegistry -ReturnObject
 ``` 
 ```yam 
 Description: Get-BluGenieRegistry and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 16
 ``` 
 Command: Get-BluGenieRegistry -ReturnObject -FormatView JSON
 ``` 
 ```yam 
 Description: Get-BluGenieRegistry and Return Object formatted in a JSON view
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 17
 ``` 
 Command: Get-BluGenieRegistry -ReturnObject -FormatView Custom
 ``` 
 ```yam 
 Description: Get-BluGenieRegistry and Return Object formatted in a PSCustom view
Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
           *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
           Update-FormatData cmdlet to add them to PowerShell.
 ``` 


## PARAMETERS

### StartKey
 ```yam 
 -StartKey <String>
    Description: Starts searching at the specified key. 
    Notes: The key name uses the following format:
    
            HKEY_LOCAL_MACHINE\
            HKEY_CURRENT_USER\
            HKEY_USERS\
            HKEY_CLASSES_ROOT\
    Alias: Path
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                HKEY_LOCAL_MACHINE\SOFTWARE
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Pattern
 ```yam 
 -Pattern <String>
    Description: Searches for the specified regular expression pattern. The pattern is not case-sensitive.
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                ^(?s:.)*
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ExcludePattern
 ```yam 
 -ExcludePattern <String>
    Description: Used in conjuction with -Pattern.  Reparse found items from pattern with an Exclude pattern
    Notes:  This cannot be used on it's own and cannot be used with -NotMatch.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MatchKey
 ```yam 
 -MatchKey [<SwitchParameter>]
    Description: Matches registry key names.
    Notes: Default option is MatchData
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MatchValueName
 ```yam 
 -MatchValueName [<SwitchParameter>]
    Description: Matches registry value names.
    Notes: Default option is MatchData
    Alias: MatchValue
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MatchData
 ```yam 
 -MatchData [<SwitchParameter>]
    Description: Matches registry value data.
    Notes: This option is default
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RootKeyOnly
 ```yam 
 -RootKeyOnly [<SwitchParameter>]
    Description: If Selected the Query will only parse the root of the Search Key given.  No sub keys will be queried.
    Notes: 
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NotMatch
 ```yam 
 -NotMatch [<SwitchParameter>]
    Description: Not Matching or Exclude pattern queries
    Notes: 
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ExactMatch
 ```yam 
 -ExactMatch [<SwitchParameter>]
    Description: The Match type is equal or exact to the Pattern string
    Notes: 
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Remove
 ```yam 
 -Remove [<SwitchParameter>]
    Description: Removes any matching patterns found in the registry.
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
### FormatView
 ```yam 
 -FormatView <String>
    Description: Select which format to return the object data in.
    Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
    Alias:
    ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'
    
    Required?                    false
    Position?                    named
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


