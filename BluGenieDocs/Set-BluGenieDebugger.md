# Set-BluGenieDebugger

## SYNOPSIS
Set-BluGenieDebugger is an add-on to manage the Debugger Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieDebugger [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieDebugger is an add-on to manage the Debugger status in the BluGenie Console.

Debugger will enable logging of the BluGenie debug information to $env:SystemDrive\Windows\Temp\BluGenieDebug.txt
Data includes:
    o The the BluGenie Arguments passed to this host
    o The current BluGenie Module Path
    o The Current PowerShell Execution Policy
    o All System, Current Session, and Current Script Variables

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieDebugger
 ``` 
 ```yam 
 Description: Toggle the Debugger setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieDebugger -SetTrue
 ``` 
 ```yam 
 Description: Enable debugging
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieDebugger -SetFalse
 ``` 
 ```yam 
 Description: Disable debugging
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieDebugger -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieDebugger -WalkThrough
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
    Description: Enable debugging
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
    Description: Disable debugging
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


