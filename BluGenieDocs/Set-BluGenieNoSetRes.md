# Set-BluGenieNoSetRes

## SYNOPSIS
Set-BluGenieNoSetRes is an add-on to manage the NoSetRes Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieNoSetRes [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieNoSetRes is an add-on to manage the NoSetRes status in the BluGenie Console.

Set the NoSetRes value so to not update the frame of the Console.  Use the OS's default command prompt size.
If this option is set to True, the Console Windows Frame will be adjusted to better fit the Verbose Messaging.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieNoSetRes
 ``` 
 ```yam 
 Description: Toggle the NoSetRes setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieNoSetRes -SetTrue
 ``` 
 ```yam 
 Description: Enable NoSetRes
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieNoSetRes -SetFalse
 ``` 
 ```yam 
 Description: Disable NoSetRes
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieNoSetRes -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieNoSetRes -WalkThrough
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
    Description: Enable NoSetRes
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
    Description: Disable NoSetRes
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


