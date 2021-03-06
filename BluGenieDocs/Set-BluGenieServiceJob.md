# Set-BluGenieServiceJob

## SYNOPSIS
Set-BluGenieServiceJob is an add-on to manage the ServiceJob Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieServiceJob [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieServiceJob is an add-on to manage the ServiceJob status in the BluGenie Console.

Send the artifact to the remote machine to be run by the BluGenie Service.
Note: This will only work if the BluGenie service is running
        If not, the artifact will fallback to the remote connection execution process.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieServiceJob
 ``` 
 ```yam 
 Description: Toggle the ServiceJob setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieServiceJob -SetTrue
 ``` 
 ```yam 
 Description: Enable ServiceJob
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieServiceJob -SetFalse
 ``` 
 ```yam 
 Description: Disable ServiceJob
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieServiceJob -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieServiceJob -WalkThrough
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
    Description: Enable ServiceJob
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
    Description: Disable ServiceJob
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


