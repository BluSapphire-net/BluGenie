# Get-BluGenieSettings

## SYNOPSIS
Get-BluGenieSettings is an add-on to show all defined values for the current session in the BluGenie Console

## SYNTAX
```
Get-BluGenieSettings [[-OutputType] <String>] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Get-BluGenieSettings is an add-on to show all defined values for the current session in the BluGenie Console

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieSettings
 ``` 
 ```yam 
 Description: This will output the current BluGenie Console Settings in a JSON format
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieSettings -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieSettings -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### OutputType
 ```yam 
 -OutputType <String>
    Description:  Select the format of the Outpuut to display the settings configuration in
    Notes:  The default is 'YAML'
    Alias:
    ValidateSet: 'YAML','JSON','OutUnEscapedJSON'
    
    Required?                    false
    Position?                    1
    Default value                YAML
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


