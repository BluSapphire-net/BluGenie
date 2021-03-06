# Get-BluGenieSessionVariableList

## SYNOPSIS
Get-BluGenieSessionVariableList will display, export, and remove all user defined variables for the current powershell session

## SYNTAX
```
Get-BluGenieSessionVariableList [-RemoveAll] [-Export] [[-ExportPath] <String>] [[-FormatView] <String>] [-Walkthrough] [-ReturnObject] 
[-OutUnEscapedJSON] [<CommonParameters>]
```

## DESCRIPTION
Get-BluGenieSessionVariableList will display, export, and remove all user defined variables for the current powershell session

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieSessionVariableList
 ``` 
 ```yam 
 Description: Get the user defined variables for the current PowerShell session
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieSessionVariableList -RemoveAll
 ``` 
 ```yam 
 Description: Remove all user defined variables for the current PowerShell session
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieSessionVariableList -RemoveAll -Force
 ``` 
 ```yam 
 Description: Remove all user defined variables including this function and its dependencies
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieSessionVariableList -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieSessionVariableList -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieSessionVariableList -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Get the user defined variables for the current PowerShell session and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieSessionVariableList -ReturnObject
 ``` 
 ```yam 
 Description: Get the user defined variables for the current PowerShell session and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieSessionVariableList -ReturnObject -FormatView JSON
 ``` 
 ```yam 
 Description: Get the user defined variables for the current PowerShell session and Return Object formatted in a JSON view
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-BluGenieSessionVariableList -ReturnObject -FormatView Custom
 ``` 
 ```yam 
 Description: Get the user defined variables for the current PowerShell session and Return Object formatted in a PSCustom view
Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
           *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
           Update-FormatData cmdlet to add them to PowerShell.
 ``` 


## PARAMETERS

### RemoveAll
 ```yam 
 -RemoveAll [<SwitchParameter>]
    Description: Remove all user defined variables
    Notes: This does not include this function or any of the dependencies
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Export
 ```yam 
 -Export [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ExportPath
 ```yam 
 -ExportPath <String>
    
    Required?                    false
    Position?                    1
    Default value                
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
    Position?                    2
    Default value                Table
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
    Notes: This is the default return type
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


