# Set-BluGenieNoExit

## SYNOPSIS
Set-BluGenieNoExit is an add-on to manage the NoExit Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieNoExit [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieNoExit is an add-on to manage the NoExit status in the BluGenie Console.

Setting this option will stay in the Console after executing an automated Job or command from the CLI.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieNoExit
 ``` 
 ```yam 
 Description: Toggle the NoExit setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieNoExit -SetTrue
 ``` 
 ```yam 
 Description: Enable NoExit
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieNoExit -SetFalse
 ``` 
 ```yam 
 Description: Disable NoExit
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieNoExit -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieNoExit -WalkThrough
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
    Description: Enable NoExit
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
    Description: Disable NoExit
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


