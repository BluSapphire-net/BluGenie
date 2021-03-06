# Test-BluGenieIsFileLocked

## SYNOPSIS
Test to see if a file locked by another process

## SYNTAX
```
Test-BluGenieIsFileLocked [-Path] <String[]> [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Test to see if a file locked by another process.

Note:  This will only return a [Bool]. If you are looking for mor details on what is locking the file run Get-BlueGenieLockingProcess or
            Get-LockingProcess

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Test-BluGenieIsFileLocked
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Test-BluGenieIsFileLocked
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Test-BluGenieIsFileLocked -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Test-BluGenieIsFileLocked -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Test-BluGenieIsFileLocked -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: <command_here> and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Test-BluGenieIsFileLocked -ReturnObject
 ``` 
 ```yam 
 Description: <command_here> and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String[]>
    Description: Path of the file being checked
    Notes:
    Alias: 'FullName','PSPath'
    ValidateSet:
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue, ByPropertyName)
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
    Default value                True
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
    
    Required?                    false
    Position?                    named
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


