# Get-BluGenieErrorAction

## SYNOPSIS
Get-BluGenieErrorAction is a function that will round up any errors into a smiple object

## SYNTAX
```
Get-BluGenieErrorAction [-Clear] [-List] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [<CommonParameters>]
```

## DESCRIPTION
Get-BluGenieErrorAction is a function that will round up any errors into a smiple object

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieErrorAction
 ``` 
 ```yam 
 Description: Display error information in a readable format
Notes: This includes 
     * Action			= The actioning item or cmdlet
  * StackTracke	= From what Function, ScriptBlock, or CmdLet the error came from and the Line number
  * Line			= The command used when the error was generated
  * Error			= A string with a readable error message
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieErrorAction -Clear
 ``` 
 ```yam 
 Description: Clear all errors after processing each error message
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieErrorAction -List
 ``` 
 ```yam 
 Description: Return information in a List format
Notes: By default the information is displayed in a Table format
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieErrorAction -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieErrorAction -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieErrorAction -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Get-BluGenieErrorAction and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is an Object.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieErrorAction -ReturnObject
 ``` 
 ```yam 
 Description: Get-BluGenieErrorAction and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default.
 ``` 


## PARAMETERS

### Clear
 ```yam 
 -Clear [<SwitchParameter>]
    Description: Clear all errors after trapping 
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### List
 ```yam 
 -List [<SwitchParameter>]
    Description: Return data is in a List format
    Notes: By default the return data is in a Table format
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


