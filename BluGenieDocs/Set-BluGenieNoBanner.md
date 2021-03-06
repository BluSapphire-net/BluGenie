# Set-BluGenieNoBanner

## SYNOPSIS
Set-BluGenieNoBanner is an add-on to manage the NoBanner Status in the BluGenie Console

## SYNTAX
```
Set-BluGenieNoBanner [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieNoBanner is an add-on to manage the NoBanner status in the BluGenie Console.

Do not display the BluGenie Welcome Screen.

Note: This option is set to $false by default.
        This is only valid when using it in an automated job / artifact.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieNoBanner
 ``` 
 ```yam 
 Description: Toggle the NoBanner setting (True to False or False to True)
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieNoBanner -SetTrue
 ``` 
 ```yam 
 Description: Enable NoBanner
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieNoBanner -SetFalse
 ``` 
 ```yam 
 Description: Disable NoBanner
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieNoBanner -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieNoBanner -WalkThrough
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
    Description: Enable NoBanner
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
    Description: Disable NoBanner
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


