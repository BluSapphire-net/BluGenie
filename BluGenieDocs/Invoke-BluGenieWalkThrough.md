# Invoke-BluGenieWalkThrough

## SYNOPSIS
Invoke-BluGenieWalkThrough is an interactive help menu system

## SYNTAX
```
Invoke-BluGenieWalkThrough [[-Name] <String>] [[-RemoveRun]] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Invoke-BluGenieWalkThrough is an interactive help menu system.  It will convert the static PowerShell help into an interactive menu system
    -Added with a few new tag descriptors for (Parameter and Examples).  This information will structure the help 
    information displayed and also help with bulding  the dynamic help menu

    Example
     PARAMETER <parameter>
        Description:  Desciption of the Parameter
        Notes:        Any Notes
        Alias:        Alias if any
        ValidateSet:  ValidationSet Array Items

     EXAMPLE
        Command:     Your command string
        Description: Decription of what the command above will do
        Notes:       Any Notes

## EXAMPLES

### EXAMPLE 1
 ``` 
 -Help
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.
 ``` 
 
### EXAMPLE 2
 ``` 
 -WalkThrough
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.
 ``` 
 
### EXAMPLE 3
 ``` 
 
 ``` 
 ```yam 
 Description: This will start the Dynamic help menu system on the called function
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 -RemoveRun
 ``` 
 ```yam 
 Description: This will start the Dynamic help menu system on the called function
Notes: The menu system item ( Run ) will be disabled
 ``` 


## PARAMETERS

### Name
 ```yam 
 -Name <String>
    Description:  Specify the Function name to help build a Dynamic Help menu for
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RemoveRun
 ```yam 
 -RemoveRun [<SwitchParameter>]
    Description:  This will remove the Run menu item and command from the Help menu
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
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
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


