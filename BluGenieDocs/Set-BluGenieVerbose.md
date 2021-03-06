# Set-BluGenieVerbose

## SYNOPSIS
Set-BluGenieVerbose is an add-on to manage the Verbose Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieVerbose [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieVerbose is an add-on to manage the Verbose status in the BluGenie Console.

Verbose is used to display Time Stamped Messages to the screen. You can view overall progress, elapsed time from one message to the
next.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieVerbose
 ``` 
 ```yam 
 Description: Toggle the Verbose setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieVerbose -SetTrue
 ``` 
 ```yam 
 Description: Enable Verbose
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieVerbose -SetFalse
 ``` 
 ```yam 
 Description: Disable Verbose
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieVerbose -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieVerbose -WalkThrough
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
    Description: Enable Verbose
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
    Description: Disable Verbose
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


