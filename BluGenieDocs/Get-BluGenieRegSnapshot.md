# Get-BluGenieRegSnapshot

## SYNOPSIS
Get-BluGenieRegSnapshot takes a snapshot of the Registry

## SYNTAX
```
Get-BluGenieRegSnapshot [[-Path] <String>] [[-Walkthrough]] [[-ReturnObject]] [[-LeaveFile]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Get-BluGenieRegSnapshot takes a snapshot of the Registry

## EXAMPLES

### EXAMPLE 1
 ``` 
 Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
 ``` 
 ```yam 
 This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
and return a Hash Table with all the information
 ``` 
 
### EXAMPLE 2
 ``` 
 Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa' -ReturnObject
 ``` 
 ```yam 
 This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
and return just the Object content
 ``` 
 
### EXAMPLE 3
 ``` 
 Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa' -LeaveFile
 ``` 
 ```yam 
 This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'

The temp snapshot file will be removed from the users temp directory.  The file is saved with a guid value
 ``` 
 
### EXAMPLE 4
 ``` 
 Get-BluGenieRegSnapshot -Path 'HKEY_CURRENT_USER\Software\7-Zip'
 ``` 
 ```yam 
 Any values that match HKEY_CURRENT_USER will be convert to HKU keys and all loaded registry hives will be enumerated and
parsed.  A Registry Snapshot of the path will be taken for each loaded hive that has the key path.
 ``` 
 
### EXAMPLE 5
 ``` 
 Get-BluGenieRegSnapshot -Path 'HKEY_CURRENT_USER\Software\7-Zip' -OutUnEscapedJSON
 ``` 
 ```yam 
 Any values that match HKEY_CURRENT_USER will be convert to HKU keys and all loaded registry hives will be enumerated and
parsed.  A Registry Snapshot of the path will be taken for each loaded hive that has the key path.

The return will be a beautified json format
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String>
    The path to the parent registry key
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    An automated process to walk through the current function and all the parameters
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    2
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Return information as an Object.
    By default the data is returned as a Hash Table
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### LeaveFile
 ```yam 
 -LeaveFile [<SwitchParameter>]
    Do not remove snapshot file.
    By default the data is saved has a GUID in the users temp directory
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    4
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Removed UnEsacped Char from the JSON Return.
    This will beautify json and clean up the formatting.
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    5
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


