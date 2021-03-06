# Set-BluGenieUpdateMods

## SYNOPSIS
Set-BluGenieUpdateMods is an add-on to manage the UpdateMods Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieUpdateMods [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieUpdateMods is an add-on to manage the UpdateMods status in the BluGenie Console.

Force all managed BluGenie files and folders to be updated on the remote machine

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieUpdateMods
 ``` 
 ```yam 
 Description: Toggle the UpdateMods setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieUpdateMods -SetTrue
 ``` 
 ```yam 
 Description: Enable UpdateMods
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieUpdateMods -SetFalse
 ``` 
 ```yam 
 Description: Disable UpdateMods
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieUpdateMods -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieUpdateMods -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### SetTrue
 ```yam 
 -SetTrue [<SwitchParameter>]
    Description: Enable UpdateMods
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SetFalse
 ```yam 
 -SetFalse [<SwitchParameter>]
    Description: Disable UpdateMods
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


