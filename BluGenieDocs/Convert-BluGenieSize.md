# Convert-BluGenieSize

## SYNOPSIS
convert a value from Bytes, KB, MB, GB, TB to [TB/GB/MB/KB/Bytes]

## SYNTAX
```
Convert-BluGenieSize [-Value] <Double> [-InputType <String>] [-OutputType <String>] [-Precision <Int32>] [-Walkthrough] [-ReturnObject] 
[-OutUnEscapedJSON] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
convert a value from Bytes, KB, MB, GB, TB to [TB/GB/MB/KB/Bytes]

## EXAMPLES

### EXAMPLE 1
 ``` 
 
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Convert-BluGenieSize -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Convert-BluGenieSize -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Convert-BluGenieSize -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: <command_here> and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Convert-BluGenieSize -ReturnObject
 ``` 
 ```yam 
 Description: <command_here> and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### Value
 ```yam 
 -Value <Double>
    Description: The Size value to be converted
    Notes: 
    Alias:
    ValidateSet:
    
    Required?                    true
    Position?                    1
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### InputType
 ```yam 
 -InputType <String>
    Description: Source Size Type
    Notes: Default is KB
    Alias:
    ValidateSet: 'Bytes','KB','MB','GB','TB'
    
    Required?                    false
    Position?                    named
    Default value                KB
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutputType
 ```yam 
 -OutputType <String>
    Description: Destination Size Type
    Notes: Default is MB
    Alias:
    ValidateSet: 'Bytes','KB','MB','GB','TB'
    
    Required?                    false
    Position?                    named
    Default value                MB
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Precision
 ```yam 
 -Precision <Int32>
    Description: Return the value of digits after the dot/decimal point
    Notes: Default is 2
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                2
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


